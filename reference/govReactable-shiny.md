# Shiny bindings for govReactable Output and render functions for using govReactable within shiny apps

Shiny bindings for govReactable Output and render functions for using
govReactable within shiny apps

## Usage

``` r
govReactableOutput(
  output_table_name,
  caption,
  caption_size = "l",
  heading_level = 2L,
  subtitle = NULL
)

renderGovReactable(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- output_table_name:

  Output variable to read from

- caption:

  Adds a caption heading that screen readers link to the table. Plain
  text is escaped and shown as written; use
  [`shiny::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  or tags for markup. The heading's id is `output_table_name` plus
  `-caption`, and the subtitle's is `-subtitle`. To change either from
  the server, use
  [`update_reactable_caption()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_reactable_caption.md)

- caption_size:

  Size of the caption: `"s"`, `"m"`, `"l"` (default) or `"xl"`. Any
  other value is an error.

- heading_level:

  The caption's heading level, an integer from `1L` to `5L`. Defaults to
  `2L`. Use `1L` when the table is the main content of the page. Strings
  such as `"h3"` are **\[deprecated\]** as of shinyGovstyle 0.3.0 and
  will stop working in 1.0.0; use an integer (for example `3L`) instead.

- subtitle:

  Optional line under the caption, in smaller, lighter text: what the
  data is, where and when it covers, and the units if every value shares
  them (e.g. `"Cost of bikes (£), England, 2025"`). It becomes part of
  the table's accessible name, with the caption. Needs a `caption`.
  Plain text is escaped and shown as written; use
  [`shiny::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  or tags for markup. `NULL` (default) shows no subtitle

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
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md),
[`govTabs()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTabs.md),
[`update_reactable_caption()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_reactable_caption.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  govReactableOutput(
    "table",
    caption = "Virginica flowers have the longest petals",
    subtitle = "Petal and sepal measurements (cm) for three iris species"
  )
)

server <- function(input, output, session) {
  output$table <- renderGovReactable({
    # Longest petals first, so the top rows show what the caption says
    govReactable(iris[order(iris$Petal.Length, decreasing = TRUE), ])
  })
}

if (interactive()) shinyApp(ui, server)

# A caption that changes with a filter. The starting caption matches the
# dropdown's default.
species <- levels(iris$Species)

ui <- shinyGovstyle::gov_page(
  shinyGovstyle::select_Input(
    inputId = "species",
    label = "Species",
    select_text = species,
    select_value = species
  ),
  govReactableOutput(
    "table",
    caption = paste(species[1], "measurements")
  )
)

server <- function(input, output, session) {
  output$table <- renderGovReactable({
    govReactable(iris[iris$Species == input$species, ])
  })

  shiny::observe({
    update_reactable_caption(
      session,
      "table",
      paste(input$species, "measurements")
    )
  })
}

if (interactive()) shinyApp(ui, server)
```
