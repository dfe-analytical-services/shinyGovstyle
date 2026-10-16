# Tag input (deprecated)

**\[deprecated\]**

`tag_Input()` was renamed to
[`gov_tag()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_tag.md)
in shinyGovstyle 0.3.0. The tag is a display component rather than a
Shiny input, so the `_Input` suffix was misleading. The arguments and
output are unchanged. `tag_Input()` will be removed in shinyGovstyle
1.0.0.

## Usage

``` r
tag_Input(inputId, text, colour = "navy")
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- text:

  The text in the tag

- colour:

  The colour of the tag. Default is navy. Other options are grey, green,
  teal, blue, purple, magenta, red, orange and yellow. Any other value
  gives a warning listing these options

## Value

a tag HTML shiny tag object

## Examples

``` r
# Before
# tag_Input("tag1", "Complete")

# After
gov_tag("tag1", "Complete")
#> <strong id="tag1" class="govuk-tag">Complete</strong>
```
