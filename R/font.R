#' Font Function
#'
#' This function adds rge nta fonts to the app. See
#' https://design-system.service.gov.uk/styles/typography/ for when they
#' are allowed.
#' @keywords font
#' @return no value returned. This loads the font CSS file
#' @export
#' @examples
#' ui <- fluidPage(
#'   font(),
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
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
