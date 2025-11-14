# Tag Function

This function creates a tag.

## Usage

``` r
tag_Input(inputId, text, colour = "navy")
```

## Arguments

- inputId:

  The Id to access the tag

- text:

  The text in the tag

- colour:

  The colour of the tag. Default is navy. Other options are grey, green,
  turquoise, blue, purple, pink, red, orange and yellow

## Value

a tag HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::tag_Input("tag1", "Complete"),
    shinyGovstyle::tag_Input("tag2", "Incomplete", "red")
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
