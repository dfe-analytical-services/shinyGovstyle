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

## See also

Other Govstyle feedback types:
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
[`insert_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/insert_text.md),
[`label_hint()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/label_hint.md),
[`noti_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/noti_banner.md),
[`panel_output()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/panel_output.md),
[`tag_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/tag_Input.md),
[`value_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/value_box.md)

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
