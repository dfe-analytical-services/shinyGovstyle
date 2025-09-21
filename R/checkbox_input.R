#' Checkbox Function
#'
#' This function inserts a checkbox group
#' @param inputId Input id for the group of checkboxes
#' @param cb_labels Add the names of the options that will appear
#' @param checkboxIds Add the values for each checkbox
#' @param label Insert the text for the checkbox group.
#' @param hint_label Insert optional hint/secondary text.  Defaults to NULL
#' @param small change the sizing to a small version of the checkbox.  Defaults
#' to \code{FALSE}
#' @param error  Whenever you want to include error handle on the component.
#' @param error_message  If you want a default error message.
#' @return a checkbox html shiny object
#' @keywords checkbox
#' @export
#' @examples
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
#'       # Simple checkbox
#'       shinyGovstyle::checkbox_Input(
#'         inputId = "check1",
#'         cb_labels = c("Option 1", "Option 2", "Option 3"),
#'         checkboxIds = c("op1", "op2", "op3"),
#'         label = "Choice option"),
#'        # Error checkbox
#'       shinyGovstyle::checkbox_Input(
#'         inputId = "check2",
#'         cb_labels = c("Option 1", "Option 2", "Option 3"),
#'         checkboxIds = c("op1", "op2", "op3"),
#'         label = "Choice option",
#'         hint_label = "Select the best fit",
#'         error = TRUE,
#'         error_message = "Select one"),
#'       # Button to trigger error
#'       shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {
#'     #'Trigger error on blank submit of eventId2
#'     observeEvent(input$submit, {
#'       if (is.null(input$check2)){
#'         shinyGovstyle::error_on(inputId = "check2")
#'       } else {
#'         shinyGovstyle::error_off(inputId = "check2")
#'       }
#'     })
#'   }
#'
#'   shinyApp(ui = ui, server = server)
#' }
checkbox_Input <- # nolint
  function(
    inputId, # nolint
    cb_labels,
    checkboxIds, # nolint
    label,
    hint_label = NULL,
    small = FALSE,
    error = FALSE,
    error_message = NULL
  ) {
    if (small) {
      class_build <- "govuk-checkboxes govuk-checkboxes--small"
    } else {
      class_build <- "govuk-checkboxes"
    }

    gov_checkboxes <- shiny::tags$div(
      class = "shiny-input-checkboxgroup",
      id = inputId,
      shiny::tags$div(
        class = "govuk-form-group",
        id = paste0(inputId, "div"),
        shiny::tags$fieldset(
          class = "govuk-fieldset",
          shiny::tags$label(label, class = "govuk-label"),
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
          shiny::tags$div(
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
                    class = "govuk-label govuk-checkboxes__label"
                  )
                )
              },
              x = cb_labels,
              y = checkboxIds
            )
          )
        )
      )
    )
    attachDependency(gov_checkboxes)
  }
