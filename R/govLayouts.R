#' Page Layout Functions
#'
#' Build the main content area of a GOV.UK page. `gov_main_layout()` creates
#' the page's `<main>` landmark, and content can go straight inside it: items
#' simply stack one below the other. Use `gov_row()` and `gov_box()` only when
#' you need GOV.UK grid columns, such as two boxes side by side or a section
#' with a set column width. `gov_text()` is a container for body text.
#' @name layouts
#' @param inputID ID of the main div. Defaults to "main"
#' @param size size of the box in the row. Optional are full, one-half,
#' two-thirds, one-third, three-quarters and one-quarter. Defaults to "full"
#' @param width Width of the container. One of `"standard"` (GOV.UK's usual
#'   960px content width), `"three-quarters"` (three-quarters of the
#'   viewport, never narrower than standard), `"full"` (no max-width, so the
#'   container fills the viewport, with grid gutters also removed), or a CSS
#'   length (e.g. `"1400px"`, `"90vw"`) for a custom max-width.
#'   If you leave `width` unset, `gov_main_layout()` takes its width from
#'   [gov_page()] (`"full"` unless you set `gov_page(width = ...)`), or is
#'   `"standard"` outside a `gov_page()`; set it to fix the main content's
#'   own width whatever the page's. `gov_row()` defaults to
#'   `NULL`, a plain grid row with no container of its own; give it a width
#'   to centre the row in its own container, for example `"standard"` so a
#'   text page such as a cookies page reads like a normal GOV.UK page inside
#'   a full-width `gov_page()`. A `gov_row(width = "full")` inside a page
#'   lines up with the rows around it, without adding a second side gutter.
#' @param ... include the components of the UI that you want within the
#' main page. These components are made to flow through each other. See
#' example
#' @return a HTML shiny layout div
#' @family Govstyle page structure
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"),
#'   shinyGovstyle::gov_main_layout(
#'     # Content with no columns goes straight into gov_main_layout()
#'     shinyGovstyle::heading_text("Page heading", size = "l"),
#'     shinyGovstyle::gov_text("Items stack one below the other."),
#'     # Use gov_row() and gov_box() for side-by-side columns
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
#'         size = "two-thirds",
#'         shinyGovstyle::gov_text("govuk-grid-column-two-thirds")
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
#'     ),
#'     # Give a row a width to centre it in its own container, e.g. a
#'     # standard-width text section on a wider page
#'     shinyGovstyle::gov_row(
#'       width = "standard",
#'       shinyGovstyle::gov_box(
#'         size = "two-thirds",
#'         shinyGovstyle::gov_text("Centred, like a normal GOV.UK page")
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
  inputID = "main", # nolint
  width = "standard"
) {
  wc <- gov_width_container(width, is_default = missing(width))

  gov_main <- shiny::tags$div(
    class = wc$class,
    style = wc$style,
    shiny::tags$main(
      id = inputID,
      role = "main",
      tabindex = "-1",
      class = "govuk-main-wrapper",
      ...
    )
  )
  attachDependency(gov_main)
}

#' @rdname layouts
#' @export
gov_row <- function(..., width = NULL) {
  gov_row <- shiny::tags$div(
    class = "govuk-grid-row",
    ...
  )
  if (!is.null(width)) {
    # An explicit width always gets its modifier class, so the row keeps its
    # own width inside a wider gov_page() instead of inheriting the page's.
    # The extra class lets width-overrides.css centre it and keep GOV.UK's
    # grid gutters without touching other nested width containers.
    wc <- gov_width_container(width)
    gov_row <- shiny::tags$div(
      class = paste(wc$class, "shinygovstyle-row-container"),
      style = wc$style,
      gov_row
    )
  }
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
