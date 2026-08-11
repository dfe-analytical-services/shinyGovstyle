#' Label with Hint Function
#'
#' This function inserts a label and optional hint.
#' @param inputId The input slot that will be used to access the value
#' @inheritParams control_label_params
#' @return a label hint HTML shiny tag object
#' @family Govstyle feedback types
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     label_hint(
#'       inputId = "label1",
#'       label = "This is a label",
#'       hint_input = "This is a hint"
#'     ),
#'     # Rich content: a link in the hint
#'     label_hint(
#'       inputId = "label2",
#'       label = "Bold label",
#'       hint_input = shiny::tagList(
#'         "See the ",
#'         shinyGovstyle::external_link("https://www.gov.uk", "GOV.UK guidance")
#'       )
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
    shiny::tags$label(as_govuk_html(label), class = "govuk-label"),
    shiny::tags$div(as_govuk_html(hint_input), class = "govuk-hint")
  )
  attachDependency(gov_label)
}
