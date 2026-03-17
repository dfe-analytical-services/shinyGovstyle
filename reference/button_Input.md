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

## See also

Other Govstyle select inputs:
[`checkbox_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/checkbox_Input.md),
[`file_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/file_Input.md),
[`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md),
[`select_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/select_Input.md)

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

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
