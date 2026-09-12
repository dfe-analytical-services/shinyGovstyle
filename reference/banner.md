# Banner Function

This function create a detail component that you can click for further
details.

## Usage

``` r
banner(inputId, type, label = NULL, feedback_url = NULL)
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

## Value

a banner HTML shiny tag object

## See also

Other Govstyle page structure:
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md),
[`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
[`layouts`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "Beta", 'This is a new service'
  )
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)

# Auto-generate the standard feedback text from a URL
shinyGovstyle::banner(
  inputId = "banner",
  type = "Beta",
  feedback_url = "https://example.com/feedback"
)
#> <div class="govuk-phase-banner" id="banner">
#>   <div class="govuk-width-container">
#>     <p class="govuk-phase-banner__content">
#>       <strong class="govuk-tag govuk-phase-banner__content__tag">Beta</strong>
#>       <span class="govuk-phase-banner__text">
#>         This is a new service - your <a href="https://example.com/feedback" class="govuk-link" target="_blank" rel="noopener noreferrer">feedback (opens in new tab)</a> will help us to improve it.
#>       </span>
#>     </p>
#>   </div>
#> </div>

# Auto-generate contact text from a mailto: link
shinyGovstyle::banner(
  inputId = "banner",
  type = "Beta",
  feedback_url = "mailto:feedback@example.com"
)
#> <div class="govuk-phase-banner" id="banner">
#>   <div class="govuk-width-container">
#>     <p class="govuk-phase-banner__content">
#>       <strong class="govuk-tag govuk-phase-banner__content__tag">Beta</strong>
#>       <span class="govuk-phase-banner__text">
#>         This is a new service - please contact <a href="mailto:feedback@example.com" class="govuk-link">feedback@example.com</a> if you have any questions or feedback.
#>       </span>
#>     </p>
#>   </div>
#> </div>
```
