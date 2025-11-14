# Insert Text Function

This function loads the insert text component to display additional
information in a special format.

## Usage

``` r
insert_text(inputId, text)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- text:

  Text that you want to display on the insert

## Value

a insert text HTML shiny tag object

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
    shinyGovstyle::insert_text(
      inputId = "note",
      text = paste(
        "It can take up to 8 weeks to register a lasting power of",
        "attorney if there are no mistakes in the application."
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
