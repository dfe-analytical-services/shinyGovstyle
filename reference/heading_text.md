# Heading Text Function

This function createS heading text

## Usage

``` r
heading_text(text_input, size = "xl", id, level = 1)
```

## Arguments

- text_input:

  Text to display

- size:

  Text size using xl, l, m, s. Defaults to xl

- id:

  Custom header id

- level:

  Heading level, integer between 1 and 6. Defaults to 1

## Value

a heading text HTML shiny tag object

## Examples

``` r
shinyGovstyle::heading_text("This is great text")
#> <h1 class="govuk-heading-xl" id="this_is_great_text">This is great text</h1>
shinyGovstyle::heading_text("This is great text", size = "l", level = 2)
#> <h2 class="govuk-heading-l" id="this_is_great_text">This is great text</h2>
```
