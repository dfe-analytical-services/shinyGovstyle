#' Checkbox Function
#'
#' This function inserts a checkbox group
#' @inheritParams id_arg
#' @param cb_labels Add the names of the options that will appear
#' @param checkboxIds Add the values for each checkbox
#' @param label Insert the text for the checkbox group
#' @inheritParams hint_error_args
#' @param small change the sizing to a small version of the checkbox. Defaults
#' to `FALSE`
#' @inheritParams fieldset_args
#' @return a checkbox HTML shiny tag object
#' @family Govstyle select inputs
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   # Required for error handling function
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"),
#'   shinyGovstyle::banner(
#'     inputId = "banner", type = "beta", 'This is a new service'),
#'   shinyGovstyle::gov_layout(size = "two-thirds",
#'     # Simple checkbox
#'     shinyGovstyle::checkbox_Input(
#'       inputId = "check1",
#'       cb_labels = c("Option 1", "Option 2", "Option 3"),
#'       checkboxIds = c("op1", "op2", "op3"),
#'       label = "Choice option"
#'     ),
#'     # Error checkbox
#'     shinyGovstyle::checkbox_Input(
#'       inputId = "check2",
#'       cb_labels = c("Option 1", "Option 2", "Option 3"),
#'       checkboxIds = c("op1", "op2", "op3"),
#'       label = "Choice option",
#'       hint_label = "Select the best fit",
#'       error = TRUE,
#'       error_message = "Select one"
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
#'     if (is.null(input$check2)){
#'       shinyGovstyle::error_on(inputId = "check2")
#'     } else {
#'       shinyGovstyle::error_off(inputId = "check2")
#'     }
#'   })
#' }
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
checkbox_Input <- # nolint
  function(
    inputId, # nolint
    cb_labels,
    checkboxIds, # nolint
    label,
    hint_label = NULL,
    small = FALSE,
    error = FALSE,
    error_message = NULL,
    label_size = c("m", "s", "l", "xl"),
    heading_level = NULL
  ) {
    if (small) {
      class_build <- "govuk-checkboxes govuk-checkboxes--small"
    } else {
      class_build <- "govuk-checkboxes"
    }

    options <- shiny::tags$div(
      class = class_build,
      Map(
        function(x, y) {
          value <- shiny::restoreInput(id = y, default = FALSE) # nolint
          shiny::tags$div(
            class = "govuk-checkboxes__item",
            id = paste0("div_", y),
            shiny::tags$input(
              class = "govuk-checkboxes__input",
              id = y,
              name = inputId,
              type = "checkbox",
              value = y
            ),
            shiny::tags$label(
              x,
              `for` = y,
              class = "govuk-label govuk-checkboxes__label"
            )
          )
        },
        x = cb_labels,
        y = checkboxIds
      )
    )

    gov_checkboxes <- shiny::tags$div(
      class = "shiny-input-checkboxgroup",
      id = inputId,
      shiny::tags$div(
        class = "govuk-form-group",
        id = paste0(inputId, "div"),
        govFieldset(
          inputId = inputId,
          label = label,
          content = options,
          hint_label = hint_label,
          error = error,
          error_message = error_message,
          label_size = label_size,
          heading_level = heading_level
        )
      )
    )
    attachDependency(gov_checkboxes)
  }
