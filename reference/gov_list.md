# Gov List function

Gov List function

## Usage

``` r
gov_list(list, style = "none")
```

## Arguments

- list:

  vector or list of items. Each item accepts a plain character string,
  or `shiny` tag objects such as `shiny::tags$a()` (e.g. to add a link
  to a bullet) or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

- style:

  options: "none", "bullet", "number". defaults to "none"

## See also

Other Govstyle text types:
[`date_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/date_Input.md),
[`heading_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/heading_text.md),
[`input_field()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/input_field.md),
[`text_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/text_Input.md),
[`text_area_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/text_area_Input.md),
[`word_count()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/word_count.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "beta", 'This is a new service'
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::heading_text("gov_list", size = "s"),
    shinyGovstyle::gov_text("List:"),
    gov_list(list = c("a", "b", "c")),
    shinyGovstyle::gov_text("Bulleted list:"),
    gov_list(list = c("a", "b", "c"), style = "bullet"),
    shinyGovstyle::gov_text("Numbered list:"),
    gov_list(list = c("one", "two", "three"), style = "number"),
    shinyGovstyle::gov_text("List with a link:"),
    gov_list(
      list = list(
        "Plain item",
        shiny::tags$a(href = "https://www.gov.uk", "A link"),
        shiny::tagList("Item with ", shiny::tags$b("bold"), " text")
      ),
      style = "bullet"
    )
  )
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
