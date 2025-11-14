# Font Function

This function adds rge nta fonts to the app. See
https://design-system.service.gov.uk/styles/typography/ for when they
are allowed.

## Usage

``` r
font()
```

## Value

no value returned. This loads the font CSS file

## Examples

``` r
ui <- shiny::fluidPage(
  font(),
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png")
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
