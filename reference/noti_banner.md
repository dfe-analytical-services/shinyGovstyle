# Notification Banner Function

This function creates a notification banner.

## Usage

``` r
noti_banner(
  inputId,
  title_txt = "Important",
  body_txt = NULL,
  type = "standard"
)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- title_txt:

  The wording that appears in the title

- body_txt:

  The wording that appears in the banner body. Accepts a plain character
  string, or `shiny` tag objects such as `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

- type:

  The type of banner. Options are standard and success. Standard is
  default

## Value

a notification HTML shiny tag object

## See also

Other Govstyle feedback types:
[`confirmation_panel()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/confirmation_panel.md),
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
[`gov_tag()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_tag.md),
[`inset_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/inset_text.md),
[`label_hint()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/label_hint.md),
[`value_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/value_box.md),
[`warning_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/warning_text.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::noti_banner(
    inputId = "banner", title_txt = "Important", body_txt = "Example text"
  )
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
