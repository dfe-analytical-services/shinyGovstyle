#' Details Function
#'
#' This function create a detail component that you can click for further
#' details.
#' @param inputId The input slot that will be used to access the value.
#' @param label Main label text
#' @param help_text Additional help information in the component.
#' @return a details box html shiny object
#' @keywords details box
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       shinyGovstyle::details(
#'         inputId = "help_div",
#'         label = "Help with form",
#'         help_text = "To complete the form you need to fill it in...")
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }
details <- function(
  inputId, # nolint
  label,
  help_text
) {
  gov_details <- shiny::tags$details(
    class = "govuk-details",
    id = inputId,
    shiny::tags$summary(
      class = "govuk-details__summary",
      shiny::tags$span(
        class = "govuk-details__summary-text",
        shiny::HTML(label)
      )
    ),
    shiny::tags$div(class = "govuk-details__text", help_text)
  )
  attachDependency(gov_details)
}
