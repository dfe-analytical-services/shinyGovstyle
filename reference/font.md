# Font Function

Loads the GDS Transport font for use in your app. GDS Transport is a
restricted typeface that must only be used on GOV.UK domains. If your
app is not hosted on a GOV.UK domain, do not call this function — the
GOV.UK Frontend CSS will fall back to Helvetica or Arial automatically.

## Usage

``` r
font()
```

## Value

no value returned. This loads the font CSS file

## Details

See the [GOV.UK typeface
guidance](https://design-system.service.gov.uk/styles/typeface/) for
full details on when GDS Transport is permitted.

## See also

Other Govstyle styling:
[`full_width_overrides()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/full_width_overrides.md)

## Examples

``` r
ui <- shiny::fluidPage(
  font(),
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png")
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
