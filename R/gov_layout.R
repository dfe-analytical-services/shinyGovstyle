#' Page Layout Function
#'
#' This function loads the page layout, This doesn't work as well as
#' the `gov_main_layout` and associated functions. This is being kept for now
#' as a simpler version where grids are not needed.
#' @param inputID ID of the main div. Defaults to "main"
#' @param size Layout of the page. Optional are full, one-half, two-thirds,
#' one-third and one-quarter. Defaults to "full"
#' @param width Width of the page container. One of `"standard"` (the
#' default, GOV.UK's usual 960px content width), `"wide"` (no max-width, so
#' the container fills the viewport instead of centring at 960px), `"full"`
#' (same as `"wide"`, with grid gutters also removed), or a CSS length
#' (e.g. `"1400px"`, `"90vw"`) for a custom max-width.
#' @param ... include the components of the UI that you want within the
#' main page.
#' @return a HTML shiny layout div
#' @family Govstyle page structure
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "full",
#'     shinyGovstyle::panel_output(
#'       inputId = "panel1",
#'       main_text = "Application Complete",
#'       sub_text = paste(
#'         "Thank you for submitting your application.",
#'         "Your reference is xvsiq"
#'       )
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
gov_layout <- function(
  ...,
  inputID = "main", # nolint
  size = "full",
  width = "standard"
) {
  wc <- gov_width_container(width, is_default = missing(width))

  gov_layout <- shiny::tags$div(
    id = inputID,
    class = paste0(wc$class, " govuk-main-wrapper"),
    style = wc$style,
    shiny::tags$div(
      id = paste0(inputID, "_sub"),
      class = paste0("govuk-grid-column-", size),
      ...
    )
  )
  attachDependency(gov_layout)
}
