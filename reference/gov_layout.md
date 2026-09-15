# Page Layout Function

This function loads the page layout, This doesn't work as well as the
`gov_main_layout` and associated functions. This is being kept for now
as a simpler version where grids are not needed.

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

## See also

Other Govstyle page structure:
[`banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/banner.md),
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md),
[`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
[`layouts`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(
    size = "full",
    shinyGovstyle::panel_output(
      inputId = "panel1",
      main_text = "Application Complete",
      sub_text = paste(
        "Thank you for submitting your application.",
        "Your reference is xvsiq"
      )
    ),
    shinyGovstyle::footer(full = TRUE)
  )
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
