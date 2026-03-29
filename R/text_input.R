#' Text Input Function
#'
#' This function create a text input.
#' @param inputId The input slot that will be used to access the value
#' @param label Display label for the control, or `NULL` for no label
#' @param hint_label Display hint label for the control, or `NULL` for
#' no hint label
#' @param type Type of text input to accept. Defaults to text
#' @param width control the size of the box based on number of characters
#' required.  Options are 30, 20, 10, 5, 4, 3, 2.  NULL will not limit the size
#' @param error Whenever to include error handling. Defaults to FALSE
#' @param error_message Message to display on error. Defaults to NULL
#' @param prefix Add a prefix to the box. Defaults to NULL
#' @param suffix Add a suffix to the box. Defaults to NULL
#' @return a text input HTML shiny tag object
#' @keywords text input
#' @family Govstyle text types
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   # Required for error handling function
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::banner(
#'     inputId = "banner", type = "beta", 'This is a new service'
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     # Simple text box
#'     shinyGovstyle::text_Input(inputId = "eventId", label = "Event Name"),
#'     # Error text box
#'     shinyGovstyle::text_Input(
#'       inputId = "eventId2",
#'       label = "Event Name",
#'       hint_label = "This can be found on the letter",
#'       error = TRUE
#'     ),
#'     # Button to trigger error
#'     shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   # Trigger error on blank submit of eventId2
#'   observeEvent(input$submit, {
#'     if (input$eventId2 != "") {
#'       shinyGovstyle::error_off(inputId = "eventId2")
#'     } else {
#'       shinyGovstyle::error_on(
#'         inputId = "eventId2",
#'         error_message = "Please complete"
#'       )
#'     }
#'   })
#' }
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
text_Input <- # nolint
  function(
    inputId, # nolint
    label,
    hint_label = NULL,
    type = "text",
    width = NULL,
    error = FALSE,
    error_message = NULL,
    prefix = NULL,
    suffix = NULL
  ) {
    if (is.null(width)) {
      width_class <- "govuk-input"
    } else {
      width_class <- paste0("govuk-input govuk-input--width-", width)
    }
    gov_text <- shiny::tags$div(
      class = "govuk-form-group",
      id = paste0(inputId, "div"),
      shiny::tags$label(shiny::HTML(label), class = "govuk-label"),
      shiny::tags$div(hint_label, class = "govuk-hint"),
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
      if (is.null(prefix) & is.null(suffix)) {
        shiny::tags$input(id = inputId, class = width_class, type = type)
      } else if (is.null(suffix)) {
        shiny::tags$div(
          class = "govuk-input__wrapper",
          shiny::tags$div(
            prefix,
            class = "govuk-input__prefix",
            `aria-hidden` = "true"
          ),
          shiny::tags$input(id = inputId, class = width_class, type = type)
        )
      } else if (is.null(prefix)) {
        shiny::tags$div(
          class = "govuk-input__wrapper",
          shiny::tags$input(id = inputId, class = width_class, type = type),
          shiny::tags$div(
            suffix,
            class = "govuk-input__suffix",
            `aria-hidden` = "true"
          )
        )
      } else {
        shiny::tags$div(
          class = "govuk-input__wrapper",
          shiny::tags$div(
            prefix,
            class = "govuk-input__prefix",
            `aria-hidden` = "true"
          ),
          shiny::tags$input(id = inputId, class = width_class, type = type),
          shiny::tags$div(
            suffix,
            class = "govuk-input__suffix",
            `aria-hidden` = "true"
          )
        )
      }
    )
    attachDependency(gov_text)
  }
