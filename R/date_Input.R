#' Date Input Function
#'
#' This function create a date input that follows GDS component
#' @param inputId The input slot that will be used to access the value
#' @param label Display label for the control, or `NULL` for no label
#' @param hint_label Display hint label for the control, or `NULL` for no
#' hint label
#' @param error Whenever to include error components.Defaults to `FALSE`
#' @param error_message Error handling message? Defaults to `NULL`
#' @param day Select a default day on start up. Defaults to `NULL`
#' @param month Select a default month on start up. Defaults to `NULL`
#' @param year Select a default year on start up. Defaults to `NULL`
#' @return a data input HTML shiny tag object
#' @keywords date
#' @family Govstyle text types
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   # Required for error handling function.
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
#'     # Simple date input
#'     shinyGovstyle::date_Input(
#'       inputId = "dob_input",
#'       label = "Please enter your birthday"
#'     ),
#'     # Error date input
#'     shinyGovstyle::date_Input(
#'       inputId = "dob_input2",
#'       label = "Please enter your birthday",
#'       hint_label = "For example, 12 11 2007",
#'       error = TRUE
#'     ),
#'     # Button to trigger error
#'     shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   # Trigger error on blank submit of dob_input2
#'   observeEvent(input$submit, {
#'     if (input$dob_input2 == "//") {
#'       shinyGovstyle::error_on(inputId = "dob_input2")
#'     } else {
#'       shinyGovstyle::error_off(inputId = "dob_input2")
#'     }
#'   })
#' }
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
date_Input <- # nolint
  function(
    inputId, # nolint
    label,
    hint_label = NULL,
    error = FALSE,
    error_message = NULL,
    day = NULL,
    month = NULL,
    year = NULL
  ) {
    value <- shiny::restoreInput(id = inputId, default = FALSE) # nolint
    gov_date <- shiny::tags$div(
      class = "govuk-form-group",
      id = paste0(inputId, "div"),
      shiny::tags$fieldset(
        class = "govuk-fieldset",
        shiny::tags$label(shiny::HTML(label), class = "govuk-label"),
        if (error == TRUE) {
          shinyjs::hidden(
            shiny::tags$p(
              error_message,
              id = paste0(inputId, "error"),
              class = "govuk-error-message",
              shiny::tags$span("Error:", class = "govuk-visually-hidden")
            )
          )
        },
        shiny::tags$div(hint_label, class = "govuk-hint"),
        shiny::tags$div(
          class = "govuk-date-input",
          id = inputId,
          shiny::tags$div(
            class = "govuk-date-input__item",
            shiny::tags$div(
              class = "govuk-form-group",
              shiny::tags$label(
                "Day",
                class = "govuk-label govuk-date-input__label"
              ),
              shiny::tags$input(
                class = paste(
                  "govuk-input govuk-date-input__input",
                  "
                            govuk-input--width-2"
                ),
                id = paste0(inputId, "_day"),
                name = inputId,
                type = "number",
                pattern = "[0-9]*",
                value = day
              )
            )
          ),
          shiny::tags$div(
            class = "govuk-date-input__item",
            shiny::tags$div(
              class = "govuk-form-group",
              shiny::tags$label(
                "Month",
                class = "govuk-label govuk-date-input__label"
              ),
              shiny::tags$input(
                class = paste(
                  "govuk-input govuk-date-input__input",
                  "govuk-input--width-2"
                ),
                id = paste0(inputId, "_month"),
                name = inputId,
                type = "number",
                pattern = "[0-9]*",
                value = month
              )
            )
          ),
          shiny::tags$div(
            class = "govuk-date-input__item",
            shiny::tags$div(
              class = "govuk-form-group",
              shiny::tags$label(
                "Year",
                class = "govuk-label govuk-date-input__label"
              ),
              shiny::tags$input(
                class = paste(
                  "govuk-input govuk-date-input__input",
                  "govuk-input--width-4"
                ),
                id = paste0(inputId, "_year"),
                name = inputId,
                type = "number",
                pattern = "[0-9]*",
                value = year
              )
            )
          )
        )
      )
    )
    attachDependency(gov_date, "date")
  }
