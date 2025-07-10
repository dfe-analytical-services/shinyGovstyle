#' Tag Function
#'
#' This function creates a tag
#' @param inputId The id to access the tag
#' @param text The text in the tag
#' @param colour The colour of the tag.  Default is navy.  Other options are
#' grey, green, turquoise, blue, purple, pink, red, orange and yellow
#' @return a tag html shiny object.
#' @keywords tag
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       shinyGovstyle::tag_Input("tag1", "Complete"),
#'       shinyGovstyle::tag_Input("tag2", "Incomplete", "red")),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }

tag_Input <- function(inputId, text, colour = "navy") {
  class_colour <- "govuk-tag"
  if (colour != "navy") {
    class_colour <- paste0("govuk-tag govuk-tag--", colour)
  }

  govTag <- shiny::tags$strong(
    id = inputId,
    class = class_colour,
    text
  )
  attachDependency(govTag)
}
