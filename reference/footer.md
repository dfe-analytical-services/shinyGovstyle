# Footer Function

This function create a gov style footer for your page

## Usage

``` r
footer(full = FALSE, links = NULL)
```

## Arguments

- full:

  Whenever you want to have blank footer or official gov version.
  Defaults to `FALSE`

- links:

  A vector of actionLinks to be added to the footer, inputIDs are
  auto-generated and are the snake case version of the link text, e.g.
  "Accessibility Statement" will have an inputID of
  accessibility_statement

## Value

a footer HTML shiny tag object

## Details

You can add links in the footer to content either within the dashboard
or content external to the dashboard using the links_list argument.

Links in the footer should be used sparingly and are usually for
supporting information pages such as the accessibility statement,
privacy notice, cookies information or link to a statement of voluntary
adoption of the statistics code of practice.

If adding a link to an internal page, generally you will be controlling
a hidden tabset so to the end user it looks like it is a new page.

## See also

Other Govstyle page structure:
[`banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/banner.md),
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
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
    logo = "shinyGovstyle/images/moj_logo.png",
    logo_alt_text = "Ministry of Justice logo"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "beta", "This is a new service"
  ),
  shiny::tags$br(),
  shiny::tags$br(),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)

# Add links
footer(links = c("Accessibility statement", "Cookies"))
#> <footer class="govuk-footer " role="contentinfo">
#>   <div class="govuk-width-container ">
#>     <div class="govuk-footer__meta">
#>       <div class="govuk-footer__meta-item govuk-footer__meta-item--grow">
#>         <div>
#>           <h2 class="govuk-visually-hidden">Support links</h2>
#>           <ul class="govuk-footer__inline-list">
#>             <li class="govuk-footer__inline-list-item">
#>               <a class="action-button action-link govuk-link govuk-footer__link" href="#" id="accessibility_statement"><span class="action-label">Accessibility statement</span></a>
#>             </li>
#>             <li class="govuk-footer__inline-list-item">
#>               <a class="action-button action-link govuk-link govuk-footer__link" href="#" id="cookies"><span class="action-label">Cookies</span></a>
#>             </li>
#>           </ul>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </footer>

# Add links, internal and external
footer(
  links = c(
    "Accessibility statement",
    "Cookies",
    `Government Digital Service` =
    "https://www.gov.uk/government/organisations/government-digital-service"
  )
)
#> <footer class="govuk-footer " role="contentinfo">
#>   <div class="govuk-width-container ">
#>     <div class="govuk-footer__meta">
#>       <div class="govuk-footer__meta-item govuk-footer__meta-item--grow">
#>         <div>
#>           <h2 class="govuk-visually-hidden">Support links</h2>
#>           <ul class="govuk-footer__inline-list">
#>             <li class="govuk-footer__inline-list-item">
#>               <a class="action-button action-link govuk-link govuk-footer__link" href="#" id="accessibility_statement"><span class="action-label">Accessibility statement</span></a>
#>             </li>
#>             <li class="govuk-footer__inline-list-item">
#>               <a class="action-button action-link govuk-link govuk-footer__link" href="#" id="cookies"><span class="action-label">Cookies</span></a>
#>             </li>
#>             <li class="govuk-footer__inline-list-item"><a href="https://www.gov.uk/government/organisations/government-digital-service" class="govuk-link govuk-footer__link" target="_blank" rel="noopener noreferrer">Government Digital Service<span class="sr-only"> (opens in new tab)</span></a></li>
#>           </ul>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </footer>

# Full app with link controlling a hidden tab and a link to an external page
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png",
    logo_alt_text = "Ministry of Justice logo"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "beta", "This is a new service"
  ),
  shiny::tabsetPanel(
    type = "hidden",
    id = "tabs",
    shiny::tabPanel(
      "Main content",
      value = "main",
      heading_text("Hello world!")
    ),
    shiny::tabPanel(
      "Accessibility statement",
      value = "accessibility-panel",
      heading_text("Accessibility statement")
    ),
    shiny::tabPanel(
      "Cookies",
      value = "cookies-panel",
      heading_text("Cookies")
    ),
  ),
  shinyGovstyle::footer(
    full = TRUE,
    links = c(
      `Accessibility statement` = "accessibility_footer_link",
      `Cookies` = "cookies_footer_link",
      `Government Digital Service` =
       paste0(
         "https://www.gov.uk/government/",
         "organisations/government-digital-service"
       )
    )
  )
)

server <- function(input, output, session) {
  shiny::observeEvent(input$accessibility_footer_link, {
    shiny::updateTabsetPanel(
      session,
      "tabs",
      selected = "accessibility-panel"
    )
  })
  shiny::observeEvent(input$cookies_footer_link, {
    shiny::updateTabsetPanel(
      session,
      "tabs",
      selected = "cookies-panel"
    )
  })
}

if (interactive()) shinyApp(ui = ui, server = server)
```
