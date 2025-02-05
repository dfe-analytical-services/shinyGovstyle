#' Button Function
#'
#' This function create a gov style button
#' @param inputId The input slot that will be used to access the value.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param type The type of button.  Options are default, start, secondary and
#' warning.  Defaults to default.
#' @return a html button shiny object
#' @keywords button
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       shinyGovstyle::button_Input(
#'         inputId = "btn1",
#'         label = "Continue",
#'         type = "default")
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }

button_Input <- function(inputId, label, type = "default"){

  class_input <- "govuk-button"
  if (type == "start")
    class_input <- "govuk-button govuk-button--start"
  else if (type == "secondary")
    class_input <- "govuk-button govuk-button--secondary"
  else if (type == "warning")
    class_input <- "govuk-button govuk-button--warning"

  value <- shiny::restoreInput(id = inputId, default = NULL)

  if (type == "start")
    govButton <- shiny::tags$button(
      label,
      id = inputId,
      class = paste0(class_input, " action-button"),
      `data-val` = value,
      shiny::tag(
        "svg",
        list(class="govuk-button__start-icon",
             xmlns="http://www.w3.org/2000/svg",
             width="17.5",
             height="19",
             viewBox="0 0 33 40",
             `aria-hidden`="true",
             focusable="false",
             shiny::tag(
               "path",
               list(fill="currentColor", d="M0 0h13l20 20-20 20H0l20-20z")
             )
        )
      )
  )
  else
    govButton <- shiny::tags$button(label,
                                    id = inputId,
                                    class = paste0(class_input,
                                                   " action-button"),
                                    `data-val` = value)


  attachDependency(govButton)
}
