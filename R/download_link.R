#' Download link
#'
#' @description
#' The `download_link()` provides a standard way to provide a download
#' link, which facilitates important accessible / positive user experience
#' elements, namely:
#' \itemize{
#' \item file type
#' \item file size
#' }
#' These are necessary in order for users to understand what they are
#' downloading, both in terms of being able to decide if they are comfortable
#' with downloading the file over their current connection and if it's in a form
#' they're able to deal with once it is downloaded. If the exact file size is
#' not easily determined, then it may be acceptable to provide an estimate or an
#' upper limit.
#'
#' @param outputId The name of the output slot that the
#' `shiny::downloadHandler()` is assigned to.
#' @param link_text Text that will appear describing the download action.
#' Vague text like 'click here' or 'here' will cause an error, as will ending in
#' a full stop. Leading and trailing white space will be automatically trimmed.
#' If the string is shorter than 7 characters a console warning will be thrown.
#' There is no way to hush this other than providing more detail.
#' @param file_type The file type to be download (default: CSV)
#' @param file_size The file size if known. Needs to be a string ending in one
#' of KB, MB, GB or rows.
#'
#' @returns shiny.tag object
#' @export
#'
#' @examples
#' if (interactive()) {
#'   ui <- shiny::fluidPage(
#'     gov_text("Choose a data set to download."),
#'     select_Input(
#'       "dataset",
#'       "Data set",
#'       select_text = c("Car road tests", "New York air quality"),
#'       select_value = c("mtcars", "airquality")
#'     ),
#'     gov_text(
#'       download_link(
#'         "download_data",
#'         "Download selected data set",
#'         file_size = "4 KB"
#'       )
#'     )
#'   )
#'
#'   server <- function(input, output) {
#'     # The requested data set
#'     data <- reactive({
#'       get(input$dataset)
#'     })
#'
#'     output$download_data <- downloadHandler(
#'       filename = function() {
#'         # Use the selected dataset as the suggested file name
#'         paste0(input$dataset, ".csv")
#'       },
#'       content = function(file) {
#'         # Write the dataset to the `file` that will be downloaded
#'         write.csv(data(), file)
#'       }
#'     )
#'   }
#'
#'   shiny::shinyApp(ui, server)
#' }
download_link <- function(
  outputId, # nolint
  link_text,
  file_type = "CSV",
  file_size = NULL
) {
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

  # Check if link text ends in a full stop
  if (grepl("\\.$", link_text)) {
    stop("link_text should not end with a full stop")
  }

  # Give a console warning if link text is under 7 characters
  # Arbritary number that allows for R Shiny to be link text without a warning
  if (nchar(link_text) < 7) {
    warning(paste0(
      "the link_text: ",
      link_text,
      ", is shorter than 7 characters, this is",
      " unlikely to be descriptive for users, consider having more detailed",
      " link text"
    ))
  }

  # Assuming all else has passed, make the link text a nice accessible link
  # Note the file_size is manually assigned and optional right now. Ideally,
  # this would be updated dynamically when linking to a dynamically created
  # file, such as the CSV version of a table in an app.
  if (!is.null(file_size)) {
    if (!grepl("KB$|MB$|GB$| rows$", file_size)) {
      stop("File size should be a string ending in one of KB, MB, GB or rows.")
    }
    file_info <- paste0(file_type, ", ", file_size)
  } else {
    warning(
      paste0(
        outputId,
        ": download_link file_size is NULL. ",
        "Please add a file_size estimate or upper limit wherever possible."
      )
    )
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
