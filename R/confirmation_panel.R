#' Confirmation panel
#'
#' This function creates the GOV.UK
#' [panel](https://design-system.service.gov.uk/components/panel/) component,
#' a visible container used on confirmation or results pages to highlight
#' important content.
#' @inheritParams id_arg
#' @param title The panel heading, rendered as the page's `<h1>`.
#' @param content The body of the panel. Accepts a plain character string, or
#' `shiny` tag objects such as `shiny::tags$b("Bold")` or a
#' `shiny::tagList()`.
#' @return a panel HTML shiny tag object
#' @family Govstyle feedback types
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::gov_row(
#'       shinyGovstyle::gov_box(
#'         size = "two-thirds",
#'         shinyGovstyle::confirmation_panel(
#'           inputId = "panel1",
#'           title = "Application complete",
#'           content = paste(
#'             "Thank you for submitting your application.",
#'             "Your reference is xvsiq"
#'           )
#'         )
#'       )
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
confirmation_panel <- function(
  inputId, # nolint
  title,
  content
) {
  gov_panel <- shiny::tags$div(
    class = "govuk-panel govuk-panel--confirmation",
    id = inputId,
    shiny::tags$h1(title, class = "govuk-panel__title"),
    shiny::tags$div(as_govuk_html(content), class = "govuk-panel__body")
  )
  attachDependency(gov_panel)
}
