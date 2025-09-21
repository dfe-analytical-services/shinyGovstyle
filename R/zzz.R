#' Adds the content of www to shinyGovstyle/
#'
#' @importFrom shiny addResourcePath
#'
#' @noRd
#'
.onLoad <- function(...) {
  shiny::addResourcePath(
    "shinyGovstyle",
    system.file("www", package = "shinyGovstyle")
  )
}
