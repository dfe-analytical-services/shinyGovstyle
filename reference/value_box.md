# Create a value text box with optional description and colour

This function generates a value text box with an optional description
and customisable colour.

## Usage

``` r
value_box(value = "your value goes here", text = NA, colour = "blue")
```

## Arguments

- value:

  Character. The primary value to display in the value box. Defaults to
  "your value goes here"

- text:

  Character or NA. An optional description to appear below the value. If
  not provided (default is NA), the description will not be displayed

- colour:

  Character. A colour to apply to the value box. Defaults to "blue".
  Choose from the following: "grey", "purple", "turquoise", "blue",
  "light-blue", "yellow", "orange", "red", "pink", or "green"

## Value

A Shiny `div` tag representing the value box, styled according to the
specified parameters

## Details

The text box can be used in Shiny applications to display highlighted
information, such as statistics or key metrics.

## Examples

``` r
value_box(
  value = "1,000,000",
  text = "This is the latest value for the selected inputs.",
  colour = "purple"
)
#> <div class="value-box-container govuk-tag--purple">
#>   <strong class="value-box-value">1,000,000</strong>
#>   <div>
#>     <br/>
#>     <strong class="value-box-description">This is the latest value for the selected inputs.</strong>
#>   </div>
#> </div>
```
