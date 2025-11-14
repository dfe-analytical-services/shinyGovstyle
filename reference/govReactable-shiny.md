# Shiny bindings for govReactable Output and render functions for using govReactable within shiny apps

Shiny bindings for govReactable Output and render functions for using
govReactable within shiny apps

## Usage

``` r
govReactableOutput(
  output_table_name,
  caption,
  caption_size = "l",
  heading_level = "h2"
)

renderGovReactable(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- output_table_name:

  Output variable to read from

- caption:

  Adds a caption to the table as a header

- caption_size:

  Adjust the size of caption Options are s, m, l, xl, with l as the
  default

- heading_level:

  The HTML heading level for the caption (e.g., "h2", "h3", "h4", "h5").
  Default is "h2"

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

## Examples

``` r
ui <- shiny::fluidPage(
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
