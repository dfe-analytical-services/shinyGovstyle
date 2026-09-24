#' Error on Function
#'
#' This function turns on the error for the component. Can be used to
#' validate inputs.
#' @inheritParams id_arg
#' @param error_message if you want to add an additional error message
#' Defaults to NULL, showing the original designed error message. Plain
#' character strings are escaped and render as literal text; pass a `shiny`
#' tag, `shiny::tagList()`, or `shiny::HTML()` to render markup.
#' @return no return value.  This toggles on error CSS
#' @family Govstyle errors
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   # Required for error handling function
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::phase_banner(
#'     inputId = "banner", type = "beta", 'This is a new service'
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::gov_row(
#'       shinyGovstyle::gov_box(
#'         size = "two-thirds",
#'         # Error text box
#'         shinyGovstyle::text_Input(
#'           inputId = "eventId",
#'           label = "Event Name",
#'           error = TRUE),
#'         # Button to trigger error
#'         shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'       )
#'     )
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
    # Rebuild the full inner HTML: shinyjs::html() replaces the paragraph's
    # contents, so the visually hidden "Error:" prefix has to be sent with it.
    shinyjs::html(govuk_error_id(inputId), govuk_error_html(error_message))
  }
  shinyjs::show(govuk_error_id(inputId))
  shinyjs::addClass(
    selector = paste0("#", inputId, "div :input"),
    class = "govuk-input--error"
  )
  shinyjs::addClass(
    selector = paste0("#", inputId, "file_div"),
    class = "govuk-input--error"
  )
}
