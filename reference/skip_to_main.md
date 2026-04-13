# Skip to main content link

This function generates a 'Skip to main content' link, which is
typically used by keyboard users to bypass content and navigate directly
to the main content of a page.

## Usage

``` r
skip_to_main(id = "main")
```

## Arguments

- id:

  An optional parameter to specify the Id of the main content section,
  will be automatically preceeded by a hash '#'. Default is "main" to
  match the "#main" Id within `gov_main()`.

## Value

A Shiny tag representing the 'Skip to main content' link

## See also

Other Govstyle page structure:
[`banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/banner.md),
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md),
[`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
[`layouts`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)

## Examples

``` r
ui <- shiny::fluidPage(
  skip_to_main(),
  header(
    org_name = "Example",
    service_name = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  gov_main_layout(
    heading_text("Example heading"),
  )
)

server <- function(input, output, session){}

if (interactive()) shinyApp(ui = ui, server = server)
```
