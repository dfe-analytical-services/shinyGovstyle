# Details Function

This function create a detail component that you can click for further
details.

## Usage

``` r
details(inputId, label, help_text)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- label:

  Main label text

- help_text:

  Additional help information in the component

## Value

a details box HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::details(
      inputId = "help_div",
      label = "Help with form",
      help_text = "To complete the form you need to fill it in..."
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
