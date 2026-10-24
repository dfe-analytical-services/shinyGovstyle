#' Date Input Function
#'
#' This function create a date input that follows GDS component
#' @inheritParams id_arg
#' @inheritParams control_label_params
#' @inheritParams error_args
#' @param day Select a default day on start up. Defaults to `NULL`
#' @param month Select a default month on start up. Defaults to `NULL`
#' @param year Select a default year on start up. Defaults to `NULL`
#' @param date_of_birth If `TRUE`, set the `autocomplete` attribute on the
#'   day, month and year fields to `bday-day`, `bday-month` and `bday-year`,
#'   so browsers can fill in the user's date of birth. Use this whenever you
#'   ask for the user's own date of birth, as the GOV.UK Design System
#'   recommends; it helps meet WCAG 2.2 success criterion 1.3.5 (Identify
#'   Input Purpose). Leave it `FALSE` for any other date, such as a start
#'   date or someone else's date of birth. Defaults to `FALSE`.
#' @inheritParams fieldset_args
#' @return a data input HTML shiny tag object
#' @family Govstyle text types
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   # Required for error handling function.
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::phase_banner(
#'     inputId = "banner", type = "beta", 'This is a new service'
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     # Simple date input, with autocomplete for a date of birth
#'     shinyGovstyle::date_Input(
#'       inputId = "dob_input",
#'       label = "Please enter your birthday",
#'       date_of_birth = TRUE
#'     ),
#'     # Error date input
#'     shinyGovstyle::date_Input(
#'       inputId = "dob_input2",
#'       label = "Please enter your birthday",
#'       hint_label = "For example, 12 11 2007",
#'       error = TRUE
#'     ),
#'     # Rich content: a link in the hint
#'     shinyGovstyle::date_Input(
#'       inputId = "dob_input3",
#'       label = "Please enter your birthday",
#'       hint_label = shiny::tagList(
#'         "Check the format in the ",
#'         shinyGovstyle::external_link(
#'           "https://www.gov.uk",
#'           "GOV.UK guidance"
#'         )
#'       )
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
    year = NULL,
    label_size = c("m", "s", "l", "xl"),
    heading_level = NULL,
    date_of_birth = FALSE
  ) {
    if (!isTRUE(date_of_birth) && !isFALSE(date_of_birth)) {
      stop("`date_of_birth` must be TRUE or FALSE.", call. = FALSE)
    }
    value <- shiny::restoreInput(id = inputId, default = FALSE) # nolint
    date_content <- shiny::tags$div(
      class = "govuk-date-input",
      id = inputId,
      shiny::tags$div(
        class = "govuk-date-input__item",
        shiny::tags$div(
          class = "govuk-form-group",
          shiny::tags$label(
            "Day",
            class = "govuk-label govuk-date-input__label",
            `for` = paste0(inputId, "_day")
          ),
          shiny::tags$input(
            class = paste(
              "govuk-input govuk-date-input__input",
              "govuk-input--width-2"
            ),
            id = paste0(inputId, "_day"),
            name = inputId,
            type = "text",
            inputmode = "numeric",
            autocomplete = if (date_of_birth) "bday-day",
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
            class = "govuk-label govuk-date-input__label",
            `for` = paste0(inputId, "_month")
          ),
          shiny::tags$input(
            class = paste(
              "govuk-input govuk-date-input__input",
              "govuk-input--width-2"
            ),
            id = paste0(inputId, "_month"),
            name = inputId,
            type = "text",
            inputmode = "numeric",
            autocomplete = if (date_of_birth) "bday-month",
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
            class = "govuk-label govuk-date-input__label",
            `for` = paste0(inputId, "_year")
          ),
          shiny::tags$input(
            class = paste(
              "govuk-input govuk-date-input__input",
              "govuk-input--width-4"
            ),
            id = paste0(inputId, "_year"),
            name = inputId,
            type = "text",
            inputmode = "numeric",
            autocomplete = if (date_of_birth) "bday-year",
            value = year
          )
        )
      )
    )
    gov_date <- shiny::tags$div(
      class = "govuk-form-group",
      id = paste0(inputId, "div"),
      govFieldset(
        inputId = inputId,
        label = label,
        content = date_content,
        hint_label = hint_label,
        error = error,
        error_message = error_message,
        label_size = label_size,
        heading_level = heading_level
      )
    )
    attachDependency(gov_date, "date")
  }
