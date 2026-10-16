# Shiny bindings for govReactable Output and render functions for using govReactable within shiny apps

Shiny bindings for govReactable Output and render functions for using
govReactable within shiny apps

## Usage

``` r
govReactableOutput(
  output_table_name,
  caption,
  caption_size = "l",
  heading_level = 2L
)

renderGovReactable(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- output_table_name:

  Output variable to read from

- caption:

  Adds a caption to the table as a header

- caption_size:

  Adjust the size of caption. One of `"s"`, `"m"`, `"l"`, `"xl"`, with
  `"l"` as the default. Any other value throws an error.

- heading_level:

  The HTML heading level for the caption, an integer from `2L` to `5L`.
  Defaults to `2L` (`<h2>`). Strings such as `"h3"` are
  **\[deprecated\]** as of shinyGovstyle 0.3.0 and will stop working in
  shinyGovstyle 1.0.0; use the integer form (e.g. `3L`) instead.

- expr:

  An expression that generates a `reactable` widget

- env:

  The environment in which to evaluate `expr`

- quoted:

  Is `expr` a quoted expression (with
  [`quote()`](https://rdrr.io/r/base/substitute.html))? This is useful
  if you want to save an expression in a variable

## Value

`govReactableOutput()` returns a `reactable` output element that can be
included in a Shiny UI

`renderGovReactable()` returns a `reactable` render function that can be
assigned to a Shiny output slot

## See also

Other Govstyle tables tabs and accordions:
[`accordion()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/accordion.md),
[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md),
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md),
[`govTabs()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTabs.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  govReactableOutput(
    "table",
    caption = "Example table"
  )
)

server <- function(input, output, session) {
  output$table <- renderGovReactable({
    govReactable(iris)
  })
}

if (interactive()) shinyApp(ui, server)
```
