#' Error off Function
#'
#' This function turns off the the error o the component, once issues have
#' been sorted.
#' @param inputId The inputId to turn error handling iff for on for.
#' @return no return value.  This toggles off error css
#' @keywords error
#' @export
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#'   ui <- fluidPage(
#'     # Required for error handling function
#'     shinyjs::useShinyjs(),
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::banner(
#'       inputId = "banner", type = "beta", 'This is a new service'),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       # Error text box
#'       shinyGovstyle::text_Input(
#'         inputId = "eventId",
#'         label = "Event Name",
#'         error = TRUE),
#'       # Button to trigger error
#'       shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'
#'   server <- function(input, output, session) {
#'     #Trigger error on blank submit of eventId2
#'     observeEvent(input$submit, {
#'       if (input$eventId != ""){
#'         shinyGovstyle::error_off(inputId = "eventId")
#'       } else {
#'         shinyGovstyle::error_on(
#'           inputId = "eventId",
#'           error_message = "Please complete")
#'       }
#'     })
#'   }
#'
#'   # Run the application
#'   shinyApp(ui = ui, server = server)
#' }
error_off <- function(
  inputId # nolint
) {
  shinyjs::removeClass(paste0(inputId, "div"), "govuk-form-group--error")
  shinyjs::hide(paste0(inputId, "error"))
  shinyjs::removeClass(
    selector = paste0("#", inputId, "div :input"),
    class = "govuk-input--error"
  )
  shinyjs::removeClass(
    selector = paste0("#", inputId, "file_div"),
    class = "govuk-input--error"
  )
}
