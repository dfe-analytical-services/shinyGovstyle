#' Heading Text Function
#'
#' This function create a heading text
#' @param text_input Text to display
#' @param size Text size using xl, l, m, s.  Defaults to xl.
#' @param id Custom header id
#' @return a heading text html shiny object
#' @keywords heading
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       shinyGovstyle::heading_text("This is great text", "m")
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }

heading_text <- function(text_input, size = "xl", id) {
  if (missing(id)) {
    id <- clean_heading_text(text_input)
  }

  govHeading <- shiny::tags$h1(
    shiny::HTML(text_input),
    class = paste0("govuk-heading-", size),
    id = id
  )
  attachDependency(govHeading)
}
