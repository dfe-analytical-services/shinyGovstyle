#' Skip to main content link
#'
#' This function generates a 'Skip to main content' link, which is
#' typically used by keyboard users to bypass content and
#' navigate directly to the main content of a page.
#'
#' @param id An optional parameter to specify the Id of the main content
#' section, will be automatically preceeded by a hash '#'. Default is
#' "main" to match the "#main" Id within `gov_main()`.
#'
#' @return A Shiny tag representing the 'Skip to main content' link
#' @export
#' @family Govstyle page structure
#' @examples
#' ui <- shiny::fluidPage(
#'   skip_to_main(),
#'   header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   gov_main_layout(
#'     heading_text("Example heading"),
#'   )
#' )
#'
#' server <- function(input, output, session){}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
skip_to_main <- function(id = "main") {
  shiny::tags$a(
    href = paste0("#", id),
    class = "govuk-skip govuk-link",
    "Skip to main content"
  )
}
