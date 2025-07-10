#' Label with Hint Function
#'
#' This function inserts a label and optional hint
#' @param inputId The input slot that will be used to access the value.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param hint_input Display hint label for the control, or \code{NULL} for
#' no hint label.
#' @return a label hint html shiny object
#' @keywords label
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       label_hint(
#'         inputId = "label1",
#'         label = "This is a label",
#'         hint_input = "This is a hint")
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }

label_hint <- function(inputId, label, hint_input = NULL) {
  govLabel <- shiny::tags$div(
    class = "govuk-form-group",
    id = inputId,
    shiny::tags$label(shiny::HTML(label), class = "govuk-label"),
    shiny::tags$div(hint_input, class = "govuk-hint")
  )
  attachDependency(govLabel)
}
