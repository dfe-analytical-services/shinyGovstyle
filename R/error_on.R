#' Error on Function
#'
#' This function turns on the error for the component. Can be used to
#' validate inputs.
#' @param inputId The input id that you to to turn the error on for
#' @param error_message if you want to add an additional error message
#' Defaults to NULL, showing the original designed error message
#' @return no return value.  This toggles on error CSS
#' @keywords error
#' @export
#' @examples
#' ui <- fluidPage(
#'   # Required for error handling function
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::banner(
#'     inputId = "banner", type = "beta", 'This is a new service'
#'   ),
#'   shinyGovstyle::gov_layout(size = "two-thirds",
#'     # Error text box
#'     shinyGovstyle::text_Input(
#'       inputId = "eventId",
#'       label = "Event Name",
#'       error = TRUE),
#'     # Button to trigger error
#'     shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   # Trigger error on blank submit of eventId2
#'   observeEvent(input$submit, {
#'     if (input$eventId != ""){
#'       shinyGovstyle::error_off(inputId = "eventId")
#'     } else {
#'       shinyGovstyle::error_on(
#'         inputId = "eventId",
#'         error_message = "Please complete"
#'       )
#'     }
#'   })
#' }
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
error_on <- function(
  inputId, # nolint
  error_message = NULL
) {
  shinyjs::addClass(paste0(inputId, "div"), "govuk-form-group--error")
  if (!is.null(error_message)) {
    shinyjs::html(paste0(inputId, "error"), error_message)
  }
  shinyjs::show(paste0(inputId, "error"))
  shinyjs::addClass(
    selector = paste0("#", inputId, "div :input"),
    class = "govuk-input--error"
  )
  shinyjs::addClass(
    selector = paste0("#", inputId, "file_div"),
    class = "govuk-input--error"
  )
}
