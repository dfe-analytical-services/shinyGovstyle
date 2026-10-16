# Inset text

This function creates the GOV.UK [inset
text](https://design-system.service.gov.uk/components/inset-text/)
component, used to differentiate a block of text from the content that
surrounds it, for example a quote, example, or additional information
about the page.

## Usage

``` r
inset_text(inputId, content)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- content:

  Content to display in the inset. Accepts a plain character string, or
  `shiny` tag objects such as `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

## Value

an inset text HTML shiny tag object

## See also

Other Govstyle feedback types:
[`confirmation_panel()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/confirmation_panel.md),
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
[`gov_tag()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_tag.md),
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
    shinyGovstyle::inset_text(
      inputId = "note",
      content = paste(
        "It can take up to 8 weeks to register a lasting power of",
        "attorney if there are no mistakes in the application."
      )
    ),
    shinyGovstyle::inset_text(
      inputId = "note-rich",
      content = shiny::tagList(
        shiny::tags$b("Important: "),
        "you can also pass tag objects."
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
