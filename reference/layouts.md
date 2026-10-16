# Page Layout Functions

Build the main content area of a GOV.UK page. `gov_main_layout()`
creates the page's `<main>` landmark, and content can go straight inside
it: items simply stack one below the other. Use `gov_row()` and
`gov_box()` only when you need GOV.UK grid columns, such as two boxes
side by side or a section with a set column width. `gov_text()` is a
container for body text.

## Usage

``` r
gov_main_layout(..., inputID = "main", width = "standard")

gov_row(...)

gov_box(..., size = "full")

gov_text(...)
```

## Arguments

- ...:

  include the components of the UI that you want within the main page.
  These components are made to flow through each other. See example

- inputID:

  ID of the main div. Defaults to "main"

- width:

  Width of the component. One of `"standard"` (the default, GOV.UK's
  usual 960px content width), `"three-quarters"` (three-quarters of the
  viewport, never narrower than standard), `"full"` (no max-width, so
  the container fills the viewport, with grid gutters also removed), or
  a CSS length (e.g. `"1400px"`, `"90vw"`) for a custom max-width.

- size:

  size of the box in the row. Optional are full, one-half, two-thirds,
  one-third, three-quarters and one-quarter. Defaults to "full"

## Value

a HTML shiny layout div

## See also

Other Govstyle page structure:
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md),
[`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
[`phase_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/phase_banner.md),
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"),
  shinyGovstyle::gov_main_layout(
    # Content with no columns goes straight into gov_main_layout()
    shinyGovstyle::heading_text("Page heading", size = "l"),
    shinyGovstyle::gov_text("Items stack one below the other."),
    # Use gov_row() and gov_box() for side-by-side columns
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "one-half",
        shinyGovstyle::gov_text("govuk-grid-column-one-half")
      ),
      shinyGovstyle::gov_box(
        size = "one-half",
        shinyGovstyle::gov_text("govuk-grid-column-one-half")
      )
    ),
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "one-third",
        shinyGovstyle::gov_text("govuk-grid-column-one-third")
      ),
      shinyGovstyle::gov_box(
        size = "two-thirds",
        shinyGovstyle::gov_text("govuk-grid-column-two-thirds")
      )
    ),
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "one-quarter",
        shinyGovstyle::gov_text("govuk-grid-column-one-quarter")
      ),
      shinyGovstyle::gov_box(
        size = "three-quarters",
        shinyGovstyle::gov_text("govuk-grid-column-three-quarters")
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
