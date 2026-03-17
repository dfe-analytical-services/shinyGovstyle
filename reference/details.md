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

## See also

Other Govstyle feedback types:
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
[`insert_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/insert_text.md),
[`label_hint()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/label_hint.md),
[`noti_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/noti_banner.md),
[`panel_output()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/panel_output.md),
[`tag_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/tag_Input.md),
[`value_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/value_box.md),
[`warning_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/warning_text.md)

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

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
