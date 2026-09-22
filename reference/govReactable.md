# Interactive govTable

This function is opinionated and sets table defaults that are in keeping
with the wider GOV.UK design system. Some defaults are overrideable,
such as `highlight=TRUE` and `borderless=TRUE`, however some are fixed,
such as `showSortIcon=FALSE` as the default sort icon is inaccessible.
Additional arguments from
[`reactable::reactable`](https://glin.github.io/reactable/reference/reactable.html)
can be passed to customise the table.

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
  ...
)
```

## Arguments

- df:

  A dataframe used to generate the table

- right_col:

  A vector of column names that should be right-aligned. By default,
  numeric data is right-aligned, and character data is left-aligned

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

  Customise individual columns, for example to fix the number of decimal
  places shown. Give a named list, where each name matches a column in
  `df` and each value is built with
  [`reactable::colDef()`](https://glin.github.io/reactable/reference/colDef.html)
  (see examples). Any column left out of this list is unaffected, and
  keeps govReactable's usual GOV.UK look. For a column you do include,
  anything you don't set on it, such as sorting or alignment, also keeps
  that same default. Names that don't match a column in `df` are
  ignored.

- ...:

  Additional arguments passed to
  [`reactable::reactable`](https://glin.github.io/reactable/reference/reactable.html)

## Value

A `reactable` HTML widget styled with GOV.UK classes

## Details

This function inserts a government-styled table using `reactable`. You
can use this in R markdown or Quarto documents, or use
renderGovReactable() and govReactableOutput() for tables in R Shiny.
govReactableOutput() gives the ability to add a caption, for static
tables made using just govReactable(), use heading_text() to add
captions to tables.

## See also

Other Govstyle tables tabs and accordions:
[`accordion()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/accordion.md),
[`govReactable-shiny`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md),
[`govTabs()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTabs.md)

## Examples

``` r
# Example static table using govReactable
if (interactive()) {
  govReactable(
    iris,
    right_col = c(
      "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"
    )
  )

  govReactable(
    iris,
    right_col = c(
      "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"
    ),
    highlight = FALSE,
    page_size = 5,
    min_widths = list(
      Sepal.Length = 75,
      Sepal.Width = 75,
      Petal.Length = 75,
      Petal.Width = 75
    )
  )

  # Show one column to a fixed number of decimal places, leaving every
  # other column and style (sorting, alignment, etc.) untouched
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

  # A more involved example: only `percent` is customised, so `region`
  # and `count` keep the normal GOV.UK defaults untouched
  # (counts shown as whole numbers alongside a percentage column fixed
  # to 1 decimal place)
  count_pct_data <- data.frame(
    region = c("North", "South", "East"),
    count = c(1234, 56, 789),
    percent = c(4, 4.7, 12.34)
  )
  govReactable(
    count_pct_data,
    right_col = c("count", "percent"),
    columns = list(
      percent = reactable::colDef(
        format = reactable::colFormat(digits = 1)
      )
    )
  )
}
```
