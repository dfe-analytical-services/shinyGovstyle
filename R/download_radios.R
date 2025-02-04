#' Download with extension radios
#'
#' @param id
#' @param download_type
#' @param file_types
#'
#' @returns
#' @export
#'
#' @examples
download_radios <- function(
    id = "download_radios",
    download_type = "table",
    file_types = c("CSV", "ODS", "XLSX")
    ) {
  shiny::tagList(
    radio_button_Input(
      inputId = shiny::NS(id, "file_extension"),
      choices = file_types,
      selected = file_types[1],
      label = "Select file format:"
    ),
    gov_text(
      download_button(
        outputId = shiny::NS(id, "download_file"),
        button_label = paste("Download", download_type)
      )
    )
  )
}

#' Download with extension radios handler
#'
#' @param id
#' @param file_name
#' @param file_contents
#'
#' @returns
#' @export
#'
#' @examples
download_radios_handler <- function(
    id = "download_radios",
    file_name,
    file_contents
    ) {
  shiny::moduleServer(
    id,
    module = function(input, output, session) {
      output$download_file <- downloadHandler(
        filename = function() {
          # Use the selected dataset as the suggested file name
          paste0(file_name, ".", tolower(input$file_extension))
        },
        content = function(file) {
          # Write the dataset to the `file` that will be downloaded
          if(input$file_extension == "CSV"){
          write.csv(file_contents, file)
          } else if(input$file_extension == "XLSX") {
              writexl::write_xlsx(file_contents, file)
            }
        }
      )
    }
  )
}
