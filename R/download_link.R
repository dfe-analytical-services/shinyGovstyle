#' Download link
#'
#' @param outputId The name of the output slot that the `downloadHandler` is assigned
#' to.
#' @param link_text Text that will appear describing the download action
#' (default: "Download file").
#' Vague text like 'click here' or 'here' will cause an error, as will ending in
#' a full stop. Leading and trailing white space will be automatically trimmed.
#' If the string is shorter than 7 characters a console warning will be thrown.
#' There is no way to hush this other than providing more detail.
#' @param file_type The file type to be download (default: CSV)
#' @param file_size The file size if known
#' @param ...
#'
#' @returns shiny.tag object
#' @export
#'
#' @examples
#' \dontrun{
#' ui <- fluidPage(
#'   p("Choose a dataset to download."),
#'   selectInput("dataset", "Dataset", choices = c("mtcars", "airquality")),
#'   download_link("download_data", "Download data")
#' )
#'
#' server <- function(input, output) {
#'   # The requested dataset
#'   data <- reactive({
#'     get(input$dataset)
#'   })
#'
#'   output$download_data <- downloadHandler(
#'     filename = function() {
#'       # Use the selected dataset as the suggested file name
#'       paste0(input$dataset, ".csv")
#'     },
#'     content = function(file) {
#'       # Write the dataset to the `file` that will be downloaded
#'       write.csv(data(), file)
#'     }
#'   )
#' }
#'
#' shinyApp(ui, server)
#' }
download_link <- function(
    outputId,
    link_text = "Download data",
    file_type = "CSV",
    file_size = NULL,
    ...) {
  # Trim white space as I don't trust humans not to accidentally include
  link_text <- stringr::str_trim(link_text)

  # Create a basic check for raw URLs
  is_url <- function(text) {
    url_pattern <- "^(https://|http://|www\\.)"
    grepl(url_pattern, text)
  }

  # Check for vague link text on our list
  if (is_url(link_text)) {
    stop(paste0(
      link_text,
      " has been recognised as a raw URL, please change the link_text value",
      "to a description of the page being linked to instead"
    ))
  }

  # Check against curated data set for link text we should banish into room 101
  if (tolower(link_text) %in% shinyGovstyle::bad_link_text$bad_link_text) {
    stop(
      paste0(
        link_text,
        " is not descriptive enough and has has been recognised as bad link",
        " text, please replace the link_text argument with more descriptive",
        " text."
      )
    )
  }

  # Give a console warning if link text is under 7 characters
  # Arbritary number that allows for R Shiny to be link text without a warning
  if (nchar(link_text) < 7) {
    warning(paste0(
      "the link_text: ", link_text, ", is shorter than 7 characters, this is",
      " unlikely to be descriptive for users, consider having more detailed",
      " link text"
    ))
  }

  # Assuming all else has passed, make the link text a nice accessible link
  # Note the file_size is manually assigned and optional right now. Ideally,
  # this would be updated dynamically when linking to a dynamically created
  # file, such as the CSV version of a table in an app.
  if (!is.null(file_size)) {
    file_info <- paste0(file_type, ", ", file_size)
  } else {
    file_info <- file_type
  }
  link_text <- paste0(link_text, " (", file_info, ")")

  # Create the link object
  link <- htmltools::tags$a(
    id = outputId,
    class = "shiny-download-link disabled",
    href = "",
    target = "_blank",
    download = NA,
    htmltools::HTML(link_text)
  )

  # Attach CSS from inst/www/css/visually-hidden.css
  dependency <- htmltools::htmlDependency(
    name = "sr-only",
    version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "sr-only.css"
  )

  # Return the link with the CSS attached
  return(htmltools::attachDependencies(link, dependency, append = TRUE))
}
