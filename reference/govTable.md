# Table Function

This function inserts a gov styled table. Format is with header looking
rows and columns

## Usage

``` r
govTable(
  inputId,
  df,
  caption,
  caption_size = "l",
  num_col = NULL,
  width_overwrite = NULL,
  subtitle = NULL
)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- df:

  expects a dataframe to create a table

- caption:

  The table's title, shown as its caption. Plain text is escaped and
  shown as written; use
  [`shiny::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  or tags for markup

- caption_size:

  adjust the size of caption. One of `"s"`, `"m"`, `"l"`, `"xl"`, with
  `"l"` as the default. Any other value throws an error.

- num_col:

  adds numeric class format to these columns

- width_overwrite:

  change width. Need to include width for every column. Columns must add
  up to 1. Options are three-quarters, two-thirds, one-half, one-third,
  one-quarter. Default is `NULL`

- subtitle:

  Optional line under the caption, in smaller, lighter text: what the
  data is, where and when it covers, and the units if every value shares
  them (e.g. `"Cost of bikes (£), England, 2025"`). It becomes part of
  the table's accessible name, with the caption. Needs a `caption`.
  Plain text is escaped and shown as written; use
  [`shiny::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  or tags for markup. `NULL` (default) shows no subtitle

## Value

A `div` shiny tag holding the table, which has `inputId` as its id. Wide
tables scroll sideways inside the `div`, not the whole page.

## Details

For very large or interactive tables, consider
[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md)
instead. `govTable()` renders a static HTML table, which becomes slow to
render and harder to navigate as the number of rows grows. A warning is
emitted when `df` has more than 50 rows.

## Table titles

Every table needs a title. The [Analysis Function guidance on
tables](https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-tables/)
suggests two parts, which match two arguments:

- `caption`: a short headline stating the message, e.g.
  `"Costs peaked in March"`.

- `subtitle`: what the data is, where and when, e.g.
  `"Cost of bikes, vans and buses (£), England, January to May 2025"`.
  Include the units if every value shares them.

A headline is optional. Without one, put the what, where and when in
`caption` and leave out `subtitle`.

Put the source of the data under the table (for example with
[`gov_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)),
not in the title.

Screen reader users hear the caption and subtitle together when they
reach the table, so keep them short and don't repeat information. See
also the [GOV.UK Design System table
component](https://design-system.service.gov.uk/components/table/).

## See also

Other Govstyle tables tabs and accordions:
[`accordion()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/accordion.md),
[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md),
[`govReactable-shiny`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
[`govTabs()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTabs.md),
[`update_reactable_caption()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_reactable_caption.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::gov_main_layout(
    shinyGovstyle::govTable(
      "tab1",
      shinyGovstyle::transport_data_small,
      "Bike and car costs were highest in March",
      "l",
      num_col = c(2,3),
      width_overwrite = c("one-half", "one-quarter", "one-quarter"),
      subtitle = "Cost of bikes and cars, January to March"
    )
  )
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
