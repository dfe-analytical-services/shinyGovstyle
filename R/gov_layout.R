#' Page layout (deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `gov_layout()` was deprecated in shinyGovstyle 0.3.0 and will be removed in
#' shinyGovstyle 1.0.0. Use [gov_main_layout()] with [gov_row()] and
#' [gov_box()] instead, which also gives the page its `<main>` landmark:
#'
#' ```r
#' # Before
#' gov_layout(..., inputID = "main", size = "two-thirds", width = "standard")
#'
#' # After
#' gov_main_layout(
#'   gov_row(gov_box(..., size = "two-thirds")),
#'   inputID = "main",
#'   width = "standard"
#' )
#' ```
#'
#' `inputID` moves to `gov_main_layout(inputID = )`, `size` to
#' `gov_box(size = )` and `width` to `gov_main_layout(width = )`. The inner
#' `<inputID>_sub` element is not recreated, so wrap the content in
#' `shiny::tags$div(id = ...)` if your own CSS or JavaScript targets it. With
#' the default `size = "full"` you don't need `gov_row()` or `gov_box()` at
#' all: put the content straight into `gov_main_layout(...)`. Use one
#' `gov_main_layout()` per page; where `gov_layout()` was repeated inside tab
#' panels, put the content directly inside each panel instead (wrapped in
#' `gov_row(gov_box(..., size = ))` only if you set a narrower `size`).
#'
#' @param inputID ID of the main div. Defaults to "main"
#' @param size Layout of the page. Optional are full, one-half, two-thirds,
#' one-third and one-quarter. Defaults to "full"
#' @inheritParams width_arg
#' @param ... include the components of the UI that you want within the
#' main page.
#' @return a HTML shiny layout div
#' @keywords internal
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::heading_text("Page heading", size = "l")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
gov_layout <- function(
  ...,
  inputID = "main", # nolint
  size = "full",
  width = "standard"
) {
  lifecycle::deprecate_warn(
    when = "0.3.0",
    what = "gov_layout()",
    with = "gov_main_layout()",
    details = c(
      i = paste(
        "Replace `gov_layout(...)` with",
        "`gov_main_layout(gov_row(gov_box(..., size = size)),",
        "inputID = inputID, width = width)`."
      ),
      i = paste(
        "Pass `size` to `gov_box()`, and `inputID` and `width` to",
        "`gov_main_layout()`. With `size = \"full\"` (the default) you can",
        "drop `gov_row()` and `gov_box()` and pass the content directly.",
        "The inner `<inputID>_sub` element is not recreated."
      ),
      i = paste(
        "Use one `gov_main_layout()` per page; inside tab panels put the",
        "content directly in each panel."
      ),
      i = "`gov_layout()` will be removed in shinyGovstyle 1.0.0."
    )
  )

  wc <- gov_width_container(width, is_default = missing(width))

  gov_layout <- shiny::tags$div(
    id = inputID,
    class = paste0(wc$class, " govuk-main-wrapper"),
    style = wc$style,
    shiny::tags$div(
      id = paste0(inputID, "_sub"),
      class = paste0("govuk-grid-column-", size),
      ...
    )
  )
  attachDependency(gov_layout)
}
