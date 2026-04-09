#' Font Function
#'
#' Loads the GDS Transport font for use in your app. GDS Transport is a
#' restricted typeface that must only be used on GOV.UK domains. If your app
#' is not hosted on a GOV.UK domain, do not call this function — the GOV.UK
#' Frontend CSS will fall back to Helvetica or Arial automatically.
#'
#' See the
#' \href{https://design-system.service.gov.uk/styles/typeface/}{GOV.UK
#' typeface guidance} for full details on when GDS Transport is permitted.
#' @keywords font
#' @return no value returned. This loads the font CSS file
#' @export
#' @family Govstyle styling
#' @examples
#' ui <- shiny::fluidPage(
#'   font(),
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png")
#' )
#'
#' server <- function(input, output, session) {}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
font <- function() {
  version <- as.character(packageVersion("shinyGovstyle")[[1]])

  htmltools::htmlDependency(
    name = "font",
    version = version,
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "font.css"
  )
}
