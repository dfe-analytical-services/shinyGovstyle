# Page layout (deprecated)

**\[deprecated\]**

`gov_layout()` was deprecated in shinyGovstyle 0.3.0 and will be removed
in shinyGovstyle 1.0.0. Use
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
with
[`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
and
[`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
instead, which also gives the page its `<main>` landmark:

    # Before
    gov_layout(..., inputID = "main", size = "two-thirds", width = "standard")

    # After
    gov_main_layout(
      gov_row(gov_box(..., size = "two-thirds")),
      inputID = "main",
      width = "standard"
    )

`inputID` moves to `gov_main_layout(inputID = )`, `size` to
`gov_box(size = )` and `width` to `gov_main_layout(width = )`. The inner
`<inputID>_sub` element is not recreated, so wrap the content in
`shiny::tags$div(id = ...)` if your own CSS or JavaScript targets it.
With the default `size = "full"` you don't need
[`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
or
[`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
at all: put the content straight into `gov_main_layout(...)`. Use one
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
per page; where `gov_layout()` was repeated inside tab panels, put the
content directly inside each panel instead (wrapped in
`gov_row(gov_box(..., size = ))` only if you set a narrower `size`).

## Usage

``` r
gov_layout(..., inputID = "main", size = "full", width = "standard")
```

## Arguments

- ...:

  include the components of the UI that you want within the main page.

- inputID:

  ID of the main div. Defaults to "main"

- size:

  Layout of the page. Optional are full, one-half, two-thirds, one-third
  and one-quarter. Defaults to "full"

- width:

  Width of the component. One of `"standard"` (the default, GOV.UK's
  usual 960px content width), `"three-quarters"` (three-quarters of the
  viewport, never narrower than standard), `"full"` (no max-width, so
  the container fills the viewport, with grid gutters also removed), or
  a CSS length (e.g. `"1400px"`, `"90vw"`) for a custom max-width.

## Value

a HTML shiny layout div

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_main_layout(
    shinyGovstyle::heading_text("Page heading", size = "l")
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
