# Banner (deprecated)

**\[deprecated\]**

`banner()` was renamed to
[`phase_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/phase_banner.md)
in shinyGovstyle 0.3.0 to match the name of the GOV.UK Design System
component. The arguments and output are unchanged. `banner()` will be
removed in shinyGovstyle 1.0.0.

## Usage

``` r
banner(inputId, type, label = NULL, feedback_url = NULL, width = "standard")
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- type:

  Main type of label e.g. alpha or beta. Can be any word

- label:

  Text to display. Accepts a plain character string, or `shiny` tag
  objects such as `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).
  Not required if `feedback_url` is supplied instead.

- feedback_url:

  Optional URL used to auto-generate the standard GOV.UK phase banner
  feedback text, e.g. "This is a new service - your feedback (opens in
  new tab) will help us to improve it.", with `feedback` linking to
  `feedback_url`. If `feedback_url` starts with `mailto:` the text
  instead reads "This is a new service - please contact \[email
  address\] if you have any questions or feedback.". Exactly one of
  `label` or `feedback_url` must be supplied.

- width:

  Width of the component. One of `"standard"` (the default, GOV.UK's
  usual 960px content width), `"three-quarters"` (three-quarters of the
  viewport, never narrower than standard), `"full"` (no max-width, so
  the container fills the viewport, with grid gutters also removed), or
  a CSS length (e.g. `"1400px"`, `"90vw"`) for a custom max-width.

## Value

a phase banner HTML shiny tag object

## Examples

``` r
# Before
# banner("banner", "Beta", "This is a new service")

# After
phase_banner("banner", "Beta", "This is a new service")
#> <div class="govuk-phase-banner" id="banner">
#>   <div class="govuk-width-container">
#>     <p class="govuk-phase-banner__content">
#>       <strong class="govuk-tag govuk-phase-banner__content__tag">Beta</strong>
#>       <span class="govuk-phase-banner__text">This is a new service</span>
#>     </p>
#>   </div>
#> </div>
```
