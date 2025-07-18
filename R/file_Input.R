#' File Input Function
#'
#' This function create a file upload component.  It uses the basis of the
#' shiny fileInput function, but restyles the label and adds error onto it.
#' It doesn't look like the www.gov.uk/ style one, although this www.gov.uk/
#' doesn't seem to have a settle style as, for example it changes between
#' Firefox and Chrome
#' @param inputId The input slot that will be used to access the value.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param multiple Whether the user should be allowed to select and upload
#' multiple files at once. Does not work on older browsers, including Internet
#' Explorer 9 and earlier.
#' @param accept A character vector of MIME types; gives the browser a hint of
#' what kind of files the server is expecting.
#' @param width	The width of the input,  e.g. \code{'400px'}, or \code{'100\%'}
#' @param buttonLabel The label used on the button. Can be text or an HTML tag
#' object.
#' @param placeholder	The text to show before a file has been uploaded.
#' @param error Whenever to icnlud error handling  Defaults to FALSE.
#' @param error_message Message to display on error.  Defaults to NULL
#' @return a file input html shiny object
#' @keywords file input
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     # Required for error handling function
#'     shinyjs::useShinyjs(),
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::banner(
#'     inputId = "banner", type = "beta", 'This is a new service'),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       # Simple file input
#'       shinyGovstyle::file_Input(inputId = "file1", label = "Upload a file"),
#'       # Error file
#'       shinyGovstyle::file_Input(
#'         inputId = "file2",
#'         label = "Upload a file",
#'         error = TRUE),
#'       # Button to trigger error
#'       shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {
#'     #'Trigger error on blank submit of file2
#'     observeEvent(input$submit, {
#'       if (is.null(input$file2)){
#'         shinyGovstyle::error_on(inputId = "file2")
#'       } else {
#'         shinyGovstyle::error_off(
#'           inputId = "file2")
#'       }
#'     })
#'   }
#'   shinyApp(ui = ui, server = server)
#' }

file_Input <- function(
  inputId,
  label,
  multiple = FALSE,
  accept = NULL,
  width = NULL,
  buttonLabel = "Choose file",
  placeholder = "No file chosen",
  error = FALSE,
  error_message = NULL
) {
  restoredValue <- shiny::restoreInput(id = inputId, default = NULL)

  # Catch potential edge case - ensure that it's either NULL or a data frame.
  if (!is.null(restoredValue) && !is.data.frame(restoredValue)) {
    warning("Restored value for ", inputId, " has incorrect format.")
    restoredValue <- NULL
  }

  if (!is.null(restoredValue)) {
    restoredValue <- jsonlite::toJSON(restoredValue, strict_atomic = FALSE)
  }

  inputTag <- shiny::tags$input(
    id = inputId,
    name = inputId,
    type = "file",
    style = "display: none;",
    `data-restore` = restoredValue
  )

  if (multiple) {
    inputTag$attribs$multiple <- "multiple"
  }
  if (length(accept) > 0) {
    inputTag$attribs$accept <- paste(accept, collapse = ',')
  }

  govFile <- shiny::div(
    id = paste0(inputId, "div"),
    class = "govuk-form-group",

    style = if (!is.null(width)) {
      paste0("width: ", shiny::validateCssUnit(width), ";")
    },
    shiny::tags$label(label, class = "govuk-label"),
    if (error == TRUE) {
      shinyjs::hidden(
        shiny::tags$p(
          error_message,
          class = "govuk-error-message",
          id = paste0(inputId, "error"),
          shiny::tags$span("Error:", class = "govuk-visually-hidden")
        )
      )
    },

    shiny::div(
      id = paste0(inputId, "file_div"),
      class = "input-group",
      shiny::tags$label(
        class = "input-group-btn",
        shiny::span(class = "btn btn-default btn-file", buttonLabel, inputTag)
      ),
      shiny::tags$input(
        type = "text",
        class = "form-control",
        placeholder = placeholder,
        readonly = "readonly"
      )
    )
  )
  attachDependency(govFile)
}
