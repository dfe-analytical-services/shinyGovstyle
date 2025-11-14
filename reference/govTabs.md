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

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
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
