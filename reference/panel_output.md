# Panel output

This function inserts a panel. Normally used for confirmation screens

## Usage

``` r
panel_output(inputId, main_text, sub_text)
```

## Arguments

- inputId:

  The input slot that will be used to access the value.

- main_text:

  Add the header for the panel

- sub_text:

  Add the main body of text for the panel

## Value

a panel HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(size = "full",
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
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
