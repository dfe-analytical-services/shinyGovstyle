# Banner Function

This function create a detail component that you can click for further
details.

## Usage

``` r
banner(inputId, type, label)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- type:

  Main type of label e.g. alpha or beta. Can be any word

- label:

  text to display

## Value

a banner HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "Beta", 'This is a new service'
  )
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
