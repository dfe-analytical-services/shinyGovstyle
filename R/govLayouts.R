#' Page Layout Functions
#'
#' These function loads the page layout in a gov layout. There is a selection
#' of components that can sit within each other. The gov_main_layout is the
#' overarching layout. The gov_row creates a each row and gov_box creates
#' a box within the row. The gov_text is a container for text bodies.
#' @name layouts
#' @param inputID ID of the main div. Defaults to "main"
#' @param size size of the box in the row. Optional are full, one-half,
#' two-thirds, one-third and one-quarter. Defaults to "full"
#' @param ... include the components of the UI that you want within the
#' main page. These components are made to flow through each other. See
#' example
#' @return a HTML shiny layout div
#' @keywords style
#' @examples
#' ui <- fluidPage(
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::gov_row(
#'       shinyGovstyle::gov_box(
#'         size = "full",
#'         shinyGovstyle::gov_text("govuk-grid-column-full")
#'       )
#'     ),
#'     shinyGovstyle::gov_row(
#'       shinyGovstyle::gov_box(
#'         size = "one-half",
#'         shinyGovstyle::gov_text("govuk-grid-column-one-half")
#'       ),
#'       shinyGovstyle::gov_box(
#'         size = "one-half",
#'         shinyGovstyle::gov_text("govuk-grid-column-one-half")
#'       )
#'     ),
#'     shinyGovstyle::gov_row(
#'       shinyGovstyle::gov_box(
#'         size = "one-third",
#'         shinyGovstyle::gov_text("govuk-grid-column-one-third")
#'       ),
#'       shinyGovstyle::gov_box(
#'         size = "two-third",
#'         shinyGovstyle::gov_text("govuk-grid-column-two-third")
#'       )
#'     ),
#'     shinyGovstyle::gov_row(
#'       shinyGovstyle::gov_box(
#'         size = "one-quarter",
#'         shinyGovstyle::gov_text("govuk-grid-column-one-quarter")
#'       ),
#'       shinyGovstyle::gov_box(
#'         size = "three-quarters",
#'         shinyGovstyle::gov_text("govuk-grid-column-three-quarters")
#'       )
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
NULL

#' @rdname layouts
#' @export
gov_main_layout <- function(
  ...,
  inputID = "main" # nolint
) {
  gov_main <- shiny::tags$div(
    id = inputID,
    class = "govuk-width-container",
    shiny::tags$main(
      class = "govuk-main-wrapper",
      ...
    )
  )
  attachDependency(gov_main)
}

#' @rdname layouts
#' @export
gov_row <- function(...) {
  gov_row <- shiny::tags$div(
    class = "govuk-grid-row",
    ...
  )
  attachDependency(gov_row)
}

#' @rdname layouts
#' @export
gov_box <- function(..., size = "full") {
  gov_box <- shiny::tags$div(
    class = paste0("govuk-grid-column-", size),
    ...
  )
  attachDependency(gov_box)
}

#' @rdname layouts
#' @export
gov_text <- function(...) {
  gov_text <- # nolint
    shiny::tags$p(
      class = "govuk-body",
      ...
    )
}
