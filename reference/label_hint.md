# Label with Hint Function

This function inserts a label and optional hint.

## Usage

``` r
label_hint(inputId, label, hint_input = NULL)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- label:

  Display label for the control, or `NULL` for no label

- hint_input:

  Display hint label for the control, or `NULL` for no hint label

## Value

a label hint HTML shiny tag object

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
    label_hint(
      inputId = "label1",
      label = "This is a label",
      hint_input = "This is a hint"
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
