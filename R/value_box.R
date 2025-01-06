#' Create a value text box with optional description and colour
#'
#' This function generates a value text box with an optional description and customisable colour.
#' The text box can be used in Shiny applications to display highlighted information, such as statistics or key metrics.
#'
#' @param inputId Character. A unique identifier for the value box element.
#' @param value Character. The primary value to display in the value box. Defaults to "your value goes here".
#' @param text Character or NA. An optional description to appear below the value. If not provided (default is NA), the description will not be displayed..
#' @param colour Character. A colour to apply to the value box. Defaults to "blue". Choose from the following: "grey", "purple", "turquoise", "blue", "light-blue", "yellow", "orange", "red", "pink", or "green".
#'
#' @return A Shiny `div` tag representing the value box, styled according to the specified parameters.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     value_text(
#'       inputId = "value1",
#'       value = "1,000,000",
#'       text = "This is the latest value for the selected inputs.",
#'       colour = "purple"
#'     )
#'   )
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }
value_box <- function(inputId, value = "your value goes here", text = NA, colour = "blue") {

  # Use the govuk-tag--<colour> class for coloring
  class_colour <- paste0("govuk-tag--", colour)

  # Conditional rendering of text only if it's provided
  text_tag <- if (!is.na(text)) {
    shiny::tags$div(
      shiny::tags$br(),
      shiny::tags$strong(
        text,
        class = "value-box-description"
      )
    )
  } else {
    NULL
  }

  # Define the value box with the value and optional text
  govValue <- shiny::tags$div(
    class = paste("value-box-container", class_colour),
    id = inputId,
    shiny::tags$strong(
      value,
      class = "value-box-value"
    ),
    text_tag
  )

  attachDependency(govValue)
}
