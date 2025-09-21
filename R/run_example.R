#' Run examples
#'
#' This function runs an example R Shiny app showcasing different parts of the
#' package. Code for the app can be found in the inst/example_app folder in the
#' source code.
#'
#' The app is also deployed at the following URL:
#' https://department-for-education.shinyapps.io/shinygovstyle-example-app/
#'
#' @return runs an R Shiny app with examples in
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
