#' Label with Hint Function
#'
#' This function inserts a label and optional hint.
#' @param inputId The input slot that will be used to access the value
#' @param label Display label for the control, or `NULL` for no label
#' @param hint_input Display hint label for the control, or `NULL` for
#' no hint label
#' @return a label hint HTML shiny tag object
#' @family Govstyle feedback types
#' @keywords label
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     label_hint(
#'       inputId = "label1",
#'       label = "This is a label",
#'       hint_input = "This is a hint"
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
label_hint <- function(
  inputId, # nolint
  label,
  hint_input = NULL
) {
  gov_label <- shiny::tags$div(
    class = "govuk-form-group",
    id = inputId,
    shiny::tags$label(shiny::HTML(label), class = "govuk-label"),
    shiny::tags$div(hint_input, class = "govuk-hint")
  )
  attachDependency(gov_label)
}
