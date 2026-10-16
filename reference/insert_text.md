# Insert text (deprecated)

**\[deprecated\]**

`insert_text()` was renamed to
[`inset_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/inset_text.md)
in shinyGovstyle 0.3.0 to match the name of the GOV.UK Design System
component. It will be removed in shinyGovstyle 1.0.0.

## Usage

``` r
insert_text(inputId, content, text = lifecycle::deprecated())
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- content:

  Content to display in the inset. Accepts a plain character string, or
  `shiny` tag objects such as `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

- text:

  **\[deprecated\]** Use `inset_text(content)` instead.

## Value

an inset text HTML shiny tag object

## Examples

``` r
# Before
# insert_text(inputId = "note", content = "Some supporting text")

# After
inset_text(inputId = "note", content = "Some supporting text")
#> <div id="note" class="govuk-inset-text">Some supporting text</div>
```
