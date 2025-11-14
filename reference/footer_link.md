# Create a footer link for use in `footer()` function

Create a footer link for use in
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md)
function

## Usage

``` r
footer_link(link, link_name = NULL)
```

## Arguments

- link:

  Character string containing either link text or url

- link_name:

  Name of a link where a URL has been provided in link_text

## Value

HTML tag list item

## Examples

``` r
# Internal (i.e. within dashboard) link
shinyGovstyle:::footer_link("Cookie statement")
#> <li class="govuk-footer__inline-list-item">
#>   <a class="action-button govuk-link govuk-footer__link" href="#" id="cookie_statement">Cookie statement</a>
#> </li>
# Named internal link
shinyGovstyle:::footer_link("cookie_statement", "Cookies")
#> <li class="govuk-footer__inline-list-item">
#>   <a class="action-button govuk-link govuk-footer__link" href="#" id="cookie_statement">Cookies</a>
#> </li>
# External link
shinyGovstyle:::footer_link(
  "https://www.gov.uk/government/organisations/government-digital-service",
  "Government Digital Service"
)
#> <li class="govuk-footer__inline-list-item"><a href="https://www.gov.uk/government/organisations/government-digital-service" class="govuk-link govuk-footer__link" target="_blank" rel="noopener noreferrer">Government Digital Service<span class="sr-only"> (opens in new tab)</span></a></li>
```
