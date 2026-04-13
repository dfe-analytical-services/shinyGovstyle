# Insert Text Function

This function loads the insert text component to display additional
information in a special format.

## Usage

``` r
insert_text(inputId, text)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- text:

  Text that you want to display on the insert

## Value

a insert text HTML shiny tag object

## See also

Other Govstyle feedback types:
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
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
    org_name = "Example",
    service_name = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::insert_text(
      inputId = "note",
      text = paste(
        "It can take up to 8 weeks to register a lasting power of",
        "attorney if there are no mistakes in the application."
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
