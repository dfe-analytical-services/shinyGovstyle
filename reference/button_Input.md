# Button Function

This function create a gov style button

## Usage

``` r
button_Input(inputId, label, type = "default")
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- label:

  Display label for the control, or `NULL` for no label

- type:

  The type of button. Options are default, start, secondary and warning.
  Defaults to "default"

## Value

a HTML button shiny tag object

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
    shinyGovstyle::button_Input(
      inputId = "btn1",
      label = "Continue",
      type = "default"
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
