# Details Function

This function create a detail component that you can click for further
details.

## Usage

``` r
details(inputId, label, help_text)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- label:

  Main label text

- help_text:

  Additional help information in the component. Accepts a plain
  character string, or `shiny` tag objects such as
  `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

## Value

a details box HTML shiny tag object

## See also

Other Govstyle feedback types:
[`confirmation_panel()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/confirmation_panel.md),
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
[`gov_tag()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_tag.md),
[`inset_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/inset_text.md),
[`label_hint()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/label_hint.md),
[`noti_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/noti_banner.md),
[`value_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/value_box.md),
[`warning_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/warning_text.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_main_layout(
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
