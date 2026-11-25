#' Run examples
#'
#' This function runs an example R Shiny app showcasing different parts of the
#' package. Code for the app can be found in the inst/example_app folder in the
#' source code.
#'
#' The app uses the [bslib package](https://rstudio.github.io/bslib/) as is
#' generally recommended for Shiny apps.
#'
#' Online showcases are hosted on Posit Connect:
#' CRAN release: TODO_CONNECT_CRAN_URL;
#' development version: TODO_CONNECT_DEV_URL.
#'
#' @return runs an R Shiny app with examples in
#' @export
#' @examples
#' if (interactive()) run_example()
run_example <- function() {
  appdir <- system.file(package = "shinyGovstyle", "example_app")
  shiny::runApp(appdir)
}
