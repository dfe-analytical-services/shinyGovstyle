#' Download with extension radios
#'
#' @param id Shiny element Id. Default is "download_radios", but must be
#' customised to be unique if multiple instances of this module are being
#' used in a single app. Must match up to the ID
#' of a `download_radios_helper()` instance in server code
#' @param download_type Element being downloaded. Expected to be along the
#' lines of "underlying data", "table", "current data view". Default is "table"
#' @param file_types File formats to offer, can be any combination of
#' "CSV", "XLSX", "ODS". Default is a vector of all 3
#' @param file_sizes Estimated file sizes for each file format. This needs to
#' be a vector of the same length as file_types
#' @param small Set radio buttons to small size (logical, default: FALSE)
#'
#' @returns UI containing radio selection and download button
#' @family Govstyle actions
#' @export
#'
#' @examples
#' ui <- shiny::fluidPage(
#'   download_radios("download_file",
#'     file_types = c("CSV", "ODS"),
#'     file_sizes = c("2 KB", "5 KB")
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   output$download_file <- download_radios_handler(
#'     "download_file",
#'     file_name = "simple_data_frame",
#'     file_contents = mtcars
#'   )
#' }
#'
#' if (interactive()) shinyApp(ui, server)
download_radios <- function(
  id = "download_radios",
  download_type = "table",
  file_types = c("CSV", "ODS", "XLSX"),
  file_sizes = c("< 1 GB", "< 1 GB", "< 1 GB"),
  small = FALSE
) {
  allowed_extensions <- c("CSV", "ODS", "XLSX")
  if (is.null(file_types)) {
    file_types <- allowed_extensions
  }
  if (any(!(toupper(file_types) %in% allowed_extensions))) {
    stop(
      "File types must one of \"CSV\", \"ODS\", \"XLSX\".\nValue provided: ",
      setdiff(file_types, allowed_extensions) |> paste(collapse = ", ")
    )
  }
  shiny::tags$div(
    radio_button_Input(
      inputId = shiny::NS(id, "file_extension"),
      choiceNames = paste0(file_types, " (", file_sizes, ")"),
      choiceValues = file_types,
      selected = file_types[1],
      label = "Select file format for download:",
      small = small
    ),
    gov_text(
      htmltools::tags$a(
        id = shiny::NS(id, "download_file"),
        class = "shiny-download-link govuk-button",
        href = "",
        target = "_blank",
        download = NA,
        paste("Download", download_type)
      )
    )
  )
}

#' Download with extension radios handler
#'
#' @param id Shiny element Id. Default is "download_radios", but must be
#' customised to be unique if multiple instances of this module are being
#' used in a single app. Must match up to the ID of a `download_radios()`
#' instance in UI code
#' @param file_name Name of the file to be downloaded
#' @param file_contents Contents to write to the download file
#' @family Govstyle actions
#' @returns Output for use with `download_radios()`
#' @export
#'
#' @inherit download_radios examples
download_radios_handler <- function(
  id = "download_radios",
  file_name,
  file_contents
) {
  if (!(is.character(file_name) && length(file_name) == 1)) {
    stop("The provided file_name must be a single string variable.")
  }
  if (!is.data.frame(file_contents)) {
    stop("The provided file_contents need to be a data frame.")
  }
  shiny::moduleServer(
    id,
    module = function(input, output, session) {
      output$download_file <- shiny::downloadHandler(
        filename = function() {
          # Use the selected dataset as the suggested file name
          paste0(file_name, ".", tolower(input$file_extension))
        },
        content = function(file) {
          # Write the dataset to the `file` that will be downloaded
          if (input$file_extension == "CSV") {
            readr::write_csv(file_contents, file)
          } else if (input$file_extension == "XLSX") {
            writexl::write_xlsx(file_contents, file)
          } else if (input$file_extension == "ODS") {
            readODS::write_ods(file_contents, file, row_names = FALSE)
          } else {
            warning(
              "Unrecognised file format provided: ",
              input$file_extension
            )
          }
        }
      )
    }
  )
}
#
