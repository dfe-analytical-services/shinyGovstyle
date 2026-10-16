# Tag

This function creates the GOV.UK
[tag](https://design-system.service.gov.uk/components/tag/) component,
used to show users the status of something.

## Usage

``` r
gov_tag(inputId, text, colour = "navy")
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- text:

  The text in the tag

- colour:

  The colour of the tag. Default is navy. Other options are grey, green,
  teal, blue, purple, magenta, red, orange and yellow. Any other value
  gives a warning listing these options

## Value

a tag HTML shiny tag object

## See also

Other Govstyle feedback types:
[`confirmation_panel()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/confirmation_panel.md),
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
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
    shinyGovstyle::gov_tag("tag1", "Complete"),
    shinyGovstyle::gov_tag("tag2", "Incomplete", "red")
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
