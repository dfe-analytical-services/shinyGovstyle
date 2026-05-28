# Insert Text Function

This function loads the insert text component to display additional
information in a special format.

## Usage

``` r
insert_text(inputId, content, text = lifecycle::deprecated())
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- content:

  Content to display on the insert. Accepts a plain character string, or
  `shiny` tag objects such as `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

- text:

  **\[deprecated\]** Use `content` instead

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
      content = paste(
        "It can take up to 8 weeks to register a lasting power of",
        "attorney if there are no mistakes in the application."
      )
    ),
    shinyGovstyle::insert_text(
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
