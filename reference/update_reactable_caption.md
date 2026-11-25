# Update a govReactable caption or subtitle from the server

Changes the caption, the subtitle, or both, of a
[`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
table while the app is running, for example so the title still describes
the data after a filter changes it.

The caption and subtitle are the table's accessible name, so keeping
them accurate matters for screen reader users as well as sighted users.

The new text isn't announced when it changes, because it follows
something the user just did, such as picking a filter. Screen readers
read the new title when the user reaches the table.

Works inside Shiny modules without extra namespacing: pass the same
`output_table_name` you used in
[`renderGovReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md).

## Usage

``` r
update_reactable_caption(
  session,
  output_table_name,
  caption = NULL,
  subtitle = NULL
)
```

## Arguments

- session:

  The Shiny session object

- output_table_name:

  The id of the table, as given to
  [`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
  and `output$<id>` (without the module namespace)

- caption:

  The new caption, or `NULL` (default) to leave it as it is. Plain text
  is escaped and shown as written; use
  [`shiny::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  or tags for markup

- subtitle:

  The new subtitle, or `NULL` (default) to leave it as it is. Escaped in
  the same way as `caption`. Only works if
  [`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
  was given a `subtitle` to start with

## Value

`NULL` (invisibly), called for side effects

## See also

Other Govstyle tables tabs and accordions:
[`accordion()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/accordion.md),
[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md),
[`govReactable-shiny`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md),
[`govTabs()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTabs.md)

## Examples

``` r
colours <- sort(unique(shinyGovstyle::transport_data$colours))

ui <- shinyGovstyle::gov_page(
  shinyGovstyle::select_Input(
    inputId = "colour",
    label = "Colour",
    select_text = colours,
    select_value = colours
  ),
  shinyGovstyle::govReactableOutput(
    "table",
    # Start with the title for the dropdown's default choice
    caption = paste(colours[1], "vehicle costs peaked in March"),
    subtitle = paste(colours[1], "vehicle costs (£), January to May")
  )
)

server <- function(input, output, session) {
  output$table <- shinyGovstyle::renderGovReactable({
    shinyGovstyle::govReactable(
      subset(shinyGovstyle::transport_data, colours == input$colour)
    )
  })

  shiny::observe({
    shinyGovstyle::update_reactable_caption(
      session,
      "table",
      caption = paste(input$colour, "vehicle costs peaked in March"),
      subtitle = paste(input$colour, "vehicle costs (£), January to May")
    )
  })
}

if (interactive()) shiny::shinyApp(ui = ui, server = server)
```
