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

  Add the main text for the accordion

## Value

an accordion HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
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
      c(
        "This is the content for Writing well for the web.",
        "This is the content for Writing well for specialists.",
        "This is the content for Know your audience.",
        "This is the content for How people read."
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}

if (interactive()) shiny::shinyApp(ui = ui, server = server)
```
