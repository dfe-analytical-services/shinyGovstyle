# Accordion Function

This function inserts a accordion

## Usage

``` r
accordion(inputId, titles, descriptions)
```

## Arguments

- inputId:

  Input Id for the accordion

- titles:

  Add the titles for the accordion

- descriptions:

  Add the main content for each accordion section. Each item accepts a
  plain character string (rendered as a `govuk-body` paragraph), or
  `shiny` tag objects and
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
  values for richer block content such as multiple paragraphs, lists, or
  links. Tag content is inserted as-is and is *not* wrapped in a
  `govuk-body` paragraph, so build rich content from the styled helpers,
  [`shinyGovstyle::gov_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
  for paragraphs and
  [`shinyGovstyle::gov_list()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_list.md)
  for lists, to keep GOV.UK styling. A bare tag or string passed without
  those helpers will render without `govuk-body` styling.

## Value

an accordion HTML shiny tag object

## See also

Other Govstyle tables tabs and accordions:
[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md),
[`govReactable-shiny`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md),
[`govTabs()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTabs.md)

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
    inputId = "banner", type = "beta", 'This is a new service'
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    accordion(
      "acc1",
      c(
        "Writing well for the web",
        "Writing well for specialists",
        "Know your audience",
        "How people read"
      ),
      list(
        "This is the content for Writing well for the web.",
        "This is the content for Writing well for specialists.",
        "This is the content for Know your audience.",
        # Rich content: a paragraph followed by a bulleted list with a link
        shiny::tagList(
          shinyGovstyle::gov_text(
            "People read in different ways, including:"
          ),
          shinyGovstyle::gov_list(
            list(
              "scanning for key words",
              shiny::tags$a(href = "https://www.gov.uk", "following links")
            ),
            style = "bullet"
          )
        )
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}

if (interactive()) shiny::shinyApp(ui = ui, server = server)
```
