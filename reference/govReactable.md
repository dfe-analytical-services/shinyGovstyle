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
}
```
