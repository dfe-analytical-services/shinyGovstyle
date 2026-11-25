# Tables

## Before you add a table

Use a table when users need to compare values across rows and columns.
Do not use one to lay out a page. Use
[`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md)
or
[`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
for that instead.

If your data is a handful of numbers, a sentence or a
[`value_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/value_box.md)
is often clearer than a table. The [GOV.UK guidance on
tables](https://guidance.publishing.service.gov.uk/formatting-content/text-formatting/tables/)
has more on when a table helps and how to keep one simple.

## Choosing a table function

shinyGovstyle has three ways to show a table:

- [`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md)
  for small tables that do not change
- [`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md)
  for bigger tables, or when users need to sort or page through the data
- [`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
  with
  [`renderGovReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
  for tables in a Shiny app that change as users pick options

[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md)
builds a plain HTML table in the GOV.UK style. It is the simplest option
and works well up to a few dozen rows. It warns you if you give it more
than 50 rows, because a long static table is slow to load and hard to
read.

[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md)
uses the [reactable](https://glin.github.io/reactable/) package, so
users can sort columns and move between pages. Put it straight into your
app’s UI when the data does not change.

## Giving a table a title

Every table needs a title, and users of screen readers hear it when they
reach the table. All three functions take a `caption` for the title and
an optional `subtitle` for the line underneath.

The [Analysis Function guidance on
tables](https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-tables/)
suggests a title in two parts. The first is a short headline that says
what the data shows. The second says what the data is, where it covers
and when. Put the headline in `caption` and the rest in `subtitle`:

``` r

govTable(
  "costs_table",
  transport_data_small,
  caption = "Bike and car costs were highest in March",
  subtitle = "Cost of bikes and cars (£), England, January to March 2025"
)
```

If every value in the table uses the same unit, put the unit in the
subtitle, as with “(£)” above. If units differ, put them in the column
headings.

A headline is optional. If you do not want one, put the what, where and
when in `caption` and leave out `subtitle`.

Put the source of the data under the table, for example with
[`gov_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
rather than in the title.

## Small tables with govTable()

[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md)
needs an id, a data frame and a caption.

``` r

govTable(
  "costs_table",
  transport_data_small,
  caption = "Bike and car costs were highest in March",
  subtitle = "Cost of bikes and cars (£), England, January to March 2025",
  num_col = c(2, 3)
)
```

`num_col` right-aligns the numeric columns, given by position. GOV.UK
tables right-align numbers so they are easier to compare down a column.

To set column widths, give `width_overwrite` one width for each column,
such as `c("one-half", "one-quarter", "one-quarter")`.

## Larger tables with govReactable()

``` r

govReactable(
  transport_data,
  caption = "Costs peaked in March for every vehicle type",
  subtitle = "Cost of bikes, vans and buses (£), England, January to May 2025",
  page_size = 5
)
```

Numeric columns are right-aligned for you, so numbers line up for
comparison. If a column holds numbers as text, such as “£85”, name it in
`right_col` to right-align it too. `page_size` sets how many rows show
on each page.

To change how a single column looks, for example to round numbers, pass
`columns` a list of
[`reactable::colDef()`](https://glin.github.io/reactable/reference/colDef.html)
settings. Columns you do not mention keep the GOV.UK styling.

``` r

govReactable(
  transport_data,
  caption = "Costs peaked in March for every vehicle type",
  columns = list(
    bikes = reactable::colDef(format = reactable::colFormat(prefix = "£"))
  )
)
```

Each sortable column heading is a button that sorts the table, with an
arrow showing it can be sorted. This replaces reactable’s own sort
icons, which are not accessible, and means voice control users can sort
by saying the heading’s name.

## Tables in a Shiny app

In a Shiny app, put
[`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
in the UI and build the table in the server with
[`renderGovReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md).
The title goes on
[`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
because it stays on the page while the table data changes.

``` r

ui <- gov_page(
  govReactableOutput(
    "costs_table",
    caption = "Costs peaked in March for every vehicle type",
    subtitle = "Cost of bikes, vans and buses (£), England, January to May 2025"
  )
)

server <- function(input, output, session) {
  output$costs_table <- renderGovReactable({
    govReactable(transport_data)
  })
}
```

### Changing the title when the data changes

If users can filter the table, the title should describe what they are
looking at. Use
[`update_reactable_caption()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_reactable_caption.md)
in the server to change the caption, the subtitle, or both.

``` r

colours <- sort(unique(transport_data$colours))

ui <- gov_page(
  select_Input(
    inputId = "colour",
    label = "Colour",
    select_text = colours,
    select_value = colours
  ),
  govReactableOutput(
    "costs_table",
    caption = paste(colours[1], "vehicle costs peaked in March"),
    subtitle = paste(colours[1], "vehicle costs (£), January to May")
  )
)

server <- function(input, output, session) {
  output$costs_table <- renderGovReactable({
    govReactable(subset(transport_data, colours == input$colour))
  })

  shiny::observe({
    update_reactable_caption(
      session,
      "costs_table",
      caption = paste(input$colour, "vehicle costs peaked in March"),
      subtitle = paste(input$colour, "vehicle costs (£), January to May")
    )
  })
}
```

Start the caption in the UI with the text for the default choice, so the
title is right before the server runs.

A subtitle can only be updated if
[`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md)
was given one to start with.

The new title is not read out when it changes. Users hear it when they
next reach the table. This avoids an announcement every time they change
a filter.

## Further guidance

- [GOV.UK Design System table
  component](https://design-system.service.gov.uk/components/table/)
- [GOV.UK guidance on using
  tables](https://guidance.publishing.service.gov.uk/formatting-content/text-formatting/tables/)
- [Analysis Function guidance on
  tables](https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-tables/)
