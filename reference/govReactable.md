# Interactive govTable

This function sets table defaults that follow the GOV.UK design system.
Some can be changed, such as `highlight` and `borderless`. Others are
fixed, such as `showSortIcon = FALSE`, because the default sort icon is
not accessible. Each sortable heading is a button, so screen readers
announce it and voice control can select it by its visible text. Other
arguments for
[`reactable::reactable`](https://glin.github.io/reactable/reference/reactable.html)
can be passed in `...`.

## Usage

``` r
govReactable(
  df,
  right_col = NULL,
  page_size = 10,
  highlight = TRUE,
  borderless = TRUE,
  min_widths = list(),
  columns = list(),
  caption = NULL,
  subtitle = NULL,
  caption_size = "l",
  heading_level = 2L,
  caption_id = NULL,
  language = getOption("reactable.language"),
  ...
)
```

## Arguments

- df:

  A dataframe used to generate the table

- right_col:

  A vector of extra column names to right-align. Numeric columns are
  right-aligned automatically, as GOV.UK guidance says numbers should be
  right-aligned. Use this for numbers stored as text, such as `"£85"`.
  To left-align a numeric column, set
  `reactable::colDef(align = "left")` for it in `columns`

- page_size:

  The default number of rows displayed per page (default: 10)

- highlight:

  Highlight table rows on hover

- borderless:

  Remove inner borders from table

- min_widths:

  Customise minimum column width using a list of columns and minimum
  width in pixels

- columns:

  Change individual columns, for example to set the number of decimal
  places. Give a named list where each name is a column in `df` and each
  value is made with
  [`reactable::colDef()`](https://glin.github.io/reactable/reference/colDef.html)
  (see examples). Columns you leave out keep the GOV.UK defaults, and so
  does anything you don't set on a column you include. Names that don't
  match a column are ignored. A `headerClass` is added to the GOV.UK
  sort header styling, not swapped for it. Columns with
  `sortable = FALSE` show no sort arrow. A custom `header` on a sortable
  column goes inside the sort button, so it must not contain links or
  other interactive content. It must be a string, a tag or an R
  function. A `JS()` header on a sortable column is an error. Screen
  readers name a sortable heading from the column's `name`, not its
  `header`, so if you set a `header`, set `name` to the same text, e.g.
  `reactable::colDef(name = "Average cost", header = "Average cost")`.

- caption:

  Adds a caption heading that screen readers link to the table (using
  `aria-labelledby`). Plain text is escaped and shown as written; use
  [`shiny::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  or tags for markup. `NULL` (default) means no caption. For a table
  built in the server, set the caption on
  [`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
  instead, as
  [`renderGovReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
  gives an error for a captioned table

- subtitle:

  Optional line under the caption, in smaller, lighter text: what the
  data is, where and when it covers, and the units if every value shares
  them (e.g. `"Cost of bikes (£), England, 2025"`). It becomes part of
  the table's accessible name, with the caption. Needs a `caption`.
  Plain text is escaped and shown as written; use
  [`shiny::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  or tags for markup. `NULL` (default) shows no subtitle

- caption_size:

  Size of the caption: `"s"`, `"m"`, `"l"` (default) or `"xl"`. Any
  other value is an error.

- heading_level:

  The caption's heading level, an integer from `1L` to `5L`. Defaults to
  `2L`. Use `1L` when the table is the main content of the page

- caption_id:

  The id of the caption heading, which the table links to. It must be
  unique on the page and have no spaces. `NULL` (default) makes a unique
  id, so you only need this to link to or style the caption yourself.
  Setting it without a `caption` is an error

- language:

  Language options from
  [`reactable::reactableLang()`](https://glin.github.io/reactable/reference/reactableLang.html),
  for example to translate the pagination text. Defaults to the
  `reactable.language` option. `sortLabel` is always `"{name}"` so each
  heading's accessible name matches its visible text, and setting it
  gives a warning.

- ...:

  Additional arguments passed to
  [`reactable::reactable`](https://glin.github.io/reactable/reference/reactable.html)

## Value

A `reactable` widget with GOV.UK classes, or, if `caption` is given,
that widget with a caption heading

## Details

Adds a GOV.UK styled table to a Shiny app using `reactable`. Put it
straight into the UI for data that doesn't change, or use
[`renderGovReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
and
[`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
for data that does. Pass `caption` to add a heading that screen readers
link to the table.

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
[`govReactable-shiny`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md),
[`govTabs()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTabs.md),
[`update_reactable_caption()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_reactable_caption.md)

## Examples

``` r
# Tables whose data doesn't change, to put straight into a Shiny app's UI
if (interactive()) {
  # Numeric columns are right-aligned automatically
  govReactable(iris)

  # Use right_col for numbers stored as text, such as "£85"
  govReactable(
    shinyGovstyle::transport_data_small,
    right_col = c("bikes", "cars")
  )

  govReactable(
    iris,
    highlight = FALSE,
    page_size = 5,
    min_widths = list(
      Sepal.Length = 75,
      Sepal.Width = 75,
      Petal.Length = 75,
      Petal.Width = 75
    )
  )

  # Add a caption and subtitle that screen readers link to the table
  govReactable(
    shinyGovstyle::transport_data,
    caption = "Costs peaked in March for every vehicle type",
    subtitle = "Cost of bikes, vans and buses (£), January to May"
  )

  # Show one column to 1 decimal place
  sales_data <- data.frame(
    shop = c("Shop A", "Shop B", "Shop C"),
    growth = c(4, 4.7, 12.34)
  )
  govReactable(
    sales_data,
    columns = list(
      growth = reactable::colDef(
        format = reactable::colFormat(digits = 1)
      )
    )
  )

  # Only `percent` is changed, so `region` and `count` keep the defaults
  count_pct_data <- data.frame(
    region = c("North", "South", "East"),
    count = c(1234, 56, 789),
    percent = c(4, 4.7, 12.34)
  )
  govReactable(
    count_pct_data,
    columns = list(
      percent = reactable::colDef(
        format = reactable::colFormat(digits = 1)
      )
    )
  )
}
```
