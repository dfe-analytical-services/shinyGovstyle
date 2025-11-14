# Gov List function

Gov List function

## Usage

``` r
gov_list(list, style = "none")
```

## Arguments

- list:

  vector of list

- style:

  options: "none", "bullet", "number". defaults to "none"

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "beta", 'This is a new service'
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::heading_text("gov_list", size = "s"),
    shinyGovstyle::gov_text("List:"),
    gov_list(list = c("a", "b", "c")),
    shinyGovstyle::gov_text("Bulleted list:"),
    gov_list(list = c("a", "b", "c"), style = "bullet"),
    shinyGovstyle::gov_text("Numbered list:"),
    gov_list(list = c("one", "two", "three"), style = "number")
  )
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
