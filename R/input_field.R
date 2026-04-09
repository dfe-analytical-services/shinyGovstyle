#' Input Field Function
#'
#' This function inserts number of text inputs. Useful for addresses.
#' @param legend Legend that goes above the fieldset
#' @param labels A list of labels for the text inputs
#' @param inputIds A list input slots that will be used to access the value
#' @param widths control the size of the box based on number of characters
#' required.  Options are 30, 20, 10, 5, 4, 3, 2. NULL will not limit the size
#' @param types text box types. Will default to text
#' @param error Whenever to icnlud error handling. Defaults to FALSE
#' @param error_message Message to display on error. Defaults to NULL
#' @return a input field of HTML as a shiny tag object
#' @keywords input field
#' @family Govstyle text types
#' @export
#' @examples
#' ui <- shiny::fluidPage(
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
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     shinyGovstyle::input_field(
#'       legend ="List of three text boxes in a field",
#'       labels = c("Field 1", "Field 2", "Field 3"),
#'       inputIds = c("field1", "field2", "field3"),
#'       widths = c(30,20,10),
#'       error = TRUE
#'     ),
#'    # Button to trigger error
#'    shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   # Trigger error on blank submit of field2
#'   observeEvent(input$submit, {
#'     if (input$field2 == ""){
#'       shinyGovstyle::error_on(
#'         inputId = "field2",
#'         error_message = "Please complete"
#'       )
#'     } else {
#'       shinyGovstyle::error_off(
#'         inputId = "field2"
#'       )
#'     }
#'   })
#' }
#' if (interactive()) shinyApp(ui = ui, server = server)
input_field <- function(
  legend,
  labels,
  inputIds, # nolint
  widths = NULL,
  types = "text",
  error = FALSE,
  error_message = NULL
) {
  if (is.null(widths)) {
    widths <- rep_len(0, length(inputIds))
  }
  gov_input_field <- shiny::tags$fieldset(
    class = "govuk-fieldset",
    shiny::tags$legend(
      legend,
      class = "govuk-fieldset__legend govuk-fieldset__legend--xl"
    ),
    Map(
      function(x, y, z, a) {
        if (z == 0) {
          width_class <- "govuk-input"
        } else {
          width_class <- paste0("govuk-input govuk-input--width-", z)
        }
        shiny::tags$div(
          class = "govuk-form-group",
          id = paste0(y, "div"),
          shiny::tags$label(shiny::HTML(x), class = "govuk-label"),
          if (error) {
            shinyjs::hidden(
              shiny::tags$p(
                error_message,
                class = "govuk-error-message",
                id = paste0(y, "error"),
                shiny::tags$span("Error:", class = "govuk-visually-hidden")
              )
            )
          },
          shiny::tags$input(id = y, class = width_class, type = a)
        )
      },
      x = labels,
      y = inputIds,
      z = widths,
      a = types
    )
  )
  attachDependency(gov_input_field)
}
