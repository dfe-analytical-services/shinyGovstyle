#' Banner Function
#'
#' This function create a detail component that you can click for further
#' details.
#' @inheritParams id_arg
#' @param type Main type of label e.g. alpha or beta. Can be any word
#' @param label Text to display. Accepts a plain character string, or `shiny`
#' tag objects such as `shiny::tags$b("Bold")` or a `shiny::tagList()`.
#' @param width Width of the banner. One of `"standard"` (the default,
#' GOV.UK's usual 960px content width), `"wide"` (no max-width, so the
#' container fills the viewport instead of centring at 960px), `"full"`
#' (same as `"wide"`, with grid gutters also removed), or a CSS length
#' (e.g. `"1400px"`, `"90vw"`) for a custom max-width.
#' @return a banner HTML shiny tag object
#' @family Govstyle page structure
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::banner(
#'     inputId = "banner", type = "Beta", 'This is a new service'
#'   )
#' )
#'
#' server <- function(input, output, session) {}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
banner <- function(
  inputId, # nolint
  type,
  label,
  width = "standard"
) {
  wc <- gov_width_container(width, is_default = missing(width))

  gov_banner <- shiny::tags$div(
    class = "govuk-phase-banner",
    id = inputId,
    shiny::tags$div(
      class = wc$class,
      style = wc$style,
      shiny::tags$p(
        class = "govuk-phase-banner__content",
        shiny::tags$strong(
          class = "govuk-tag govuk-phase-banner__content__tag",
          type
        ),
        shiny::tags$span(
          class = "govuk-phase-banner__text",
          as_govuk_html(label)
        )
      )
    )
  )
  attachDependency(gov_banner)
}
