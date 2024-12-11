#' Example Function
#'
#' This function runs a shiny example showcasing different parts of the package.
#'
#' Code for the app can be found in the inst/example_app folder in the source code.
#'
#' @return a shiny app with examples in
#' @keywords example
#' @export
#' @examples
#' if (interactive()) {
#'   run_example()
#' }
run_example <- function() {
  appdir <- system.file(package = "shinyGovstyle", "example_app")
  shiny::runApp(appdir)
}
