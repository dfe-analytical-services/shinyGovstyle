# Tabs Function

This function creates a tabs based table. It requires a single dataframe
with a grouping variable.

## Usage

``` r
gov_summary(inputId, headers, info, action = FALSE, border = TRUE)
```

## Arguments

- inputId:

  The Id to access the summary list

- headers:

  input for the row headers value

- info:

  summary information values for the table

- action:

  whenever a change link is needed. Sets input to the value of the
  headers using lowercase and with underscore to replace gaps. Default
  set to `FALSE`

- border:

  set if the table should have borders. Default set to `TRUE`

## Value

a summary list table HTML shiny tag object

## Examples

``` r
# Create an example dataset
headers <- c(
  "Name",
  "Date of birth",
  "Contact information",
  "Contact details"
)
info <- c(
  "Sarah Philips",
  "5 January 1978",
  "72 Guild Street <br> London <br> SE23 6FH",
  "07700 900457 <br> sarah.phillips@example.com"
)

ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::gov_summary("sumID", headers, info, action = FALSE)
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
