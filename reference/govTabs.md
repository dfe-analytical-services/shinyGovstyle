# Tabs Function

This function creates a tabs based table. It requires a single dataframe
with a grouping variable.

## Usage

``` r
govTabs(inputId, df, group_col)
```

## Arguments

- inputId:

  The Id to access the tag

- df:

  A single dataframe with all data. See example for structure

- group_col:

  The column name with the groups to be used as tabs

## Value

a tab table HTML shiny tag object

## See also

Other Govstyle tables tabs and accordions:
[`accordion()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/accordion.md),
[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md),
[`govReactable-shiny`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png",
    logo_alt_text = "Ministry of Justice logo"
  ),
  shinyGovstyle::gov_main_layout(
    size = "two-thirds",
    shinyGovstyle::govTabs("tabs", shinyGovstyle::case_data, "tabs")
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
