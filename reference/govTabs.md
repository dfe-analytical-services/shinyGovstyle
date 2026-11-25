# Tabs Function

This function creates a tabs based table. It requires a single dataframe
with a grouping variable.

## Usage

``` r
govTabs(inputId, df, group_col, heading_level = 2L, heading_size = "l")
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- df:

  A single dataframe with all data. See example for structure

- group_col:

  The column name with the groups to be used as tabs

- heading_level:

  The heading level, an integer from `1L` to `6L`, for each panel's
  heading and the "Contents" title shown on small screens. Defaults to
  `2L`, as in the GOV.UK Design System. Use one level below the heading
  the tabs sit under, for example `3L` under an `<h2>`, so screen reader
  users can follow the page structure.

- heading_size:

  Size of each panel's heading: `"s"`, `"m"`, `"l"` (default) or `"xl"`.
  Keep it no bigger than the heading the tabs sit under.

## Value

a tab table HTML shiny tag object

## Details

Every tab and panel id starts with `inputId`, so several `govTabs()` on
one page work independently, even with the same group values. The first
tab is selected when the page loads.

As in the GOV.UK Design System, on small screens the tabs become a
"Contents" list of links with every table shown. `govTabs()` does the
same when its tabs don't fit on one row, for example in a narrow column,
rather than squashing them.

## See also

Other Govstyle tables tabs and accordions:
[`accordion()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/accordion.md),
[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md),
[`govReactable-shiny`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md),
[`update_reactable_caption()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_reactable_caption.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png",
    logo_alt_text = "Ministry of Justice logo"
  ),
  shinyGovstyle::gov_main_layout(
    shinyGovstyle::govTabs("tabs", shinyGovstyle::case_data, "tabs")
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
