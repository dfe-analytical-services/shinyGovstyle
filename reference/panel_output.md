# Panel output (deprecated)

**\[deprecated\]**

`panel_output()` was renamed to
[`confirmation_panel()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/confirmation_panel.md)
in shinyGovstyle 0.3.0, with `main_text` becoming `title` and `sub_text`
becoming `content`. The output is unchanged. `panel_output()` will be
removed in shinyGovstyle 1.0.0.

## Usage

``` r
panel_output(inputId, main_text, sub_text)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- main_text:

  Use `confirmation_panel(title)` instead.

- sub_text:

  Use `confirmation_panel(content)` instead.

## Value

a panel HTML shiny tag object

## Examples

``` r
# Before
# panel_output("panel1", main_text = "Application complete",
#   sub_text = "Your reference is xvsiq")

# After
confirmation_panel(
  "panel1",
  title = "Application complete",
  content = "Your reference is xvsiq"
)
#> <div class="govuk-panel govuk-panel--confirmation" id="panel1">
#>   <h1 class="govuk-panel__title">Application complete</h1>
#>   <div class="govuk-panel__body">Your reference is xvsiq</div>
#> </div>
```
