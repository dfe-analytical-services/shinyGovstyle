# Confirmation panel

This function creates the GOV.UK
[panel](https://design-system.service.gov.uk/components/panel/)
component, a visible container used on confirmation or results pages to
highlight important content.

## Usage

``` r
confirmation_panel(inputId, title, content)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- title:

  The panel heading, rendered as the page's `<h1>`.

- content:

  The body of the panel. Accepts a plain character string, or `shiny`
  tag objects such as `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

## Value

a panel HTML shiny tag object

## See also

Other Govstyle feedback types:
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
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
    shinyGovstyle::confirmation_panel(
      inputId = "panel1",
      title = "Application complete",
      content = paste(
        "Thank you for submitting your application.",
        "Your reference is xvsiq"
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
