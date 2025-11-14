# Warning Text Function

This function create warning text.

## Usage

``` r
warning_text(inputId, text)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- text:

  Text that goes in the main

## Value

a warning box HTML shiny tag object

## Examples

``` r
shinyGovstyle::warning_text(
  inputId = "warn1",
  text = "You can be fined up to £5,000 if you do not register."
)
#> <div class="govuk-warning-text" id="warn1">
#>   <span class="govuk-warning-text__icon" aria-hidden="true">!</span>
#>   <strong class="govuk-warning-text__text">
#>     You can be fined up to £5,000 if you do not register.
#>     <span class="govuk-visually-hidden">Warning</span>
#>   </strong>
#> </div>
```
