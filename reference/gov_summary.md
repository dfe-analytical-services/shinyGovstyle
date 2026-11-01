# Summary list

Creates a GOV.UK summary list: a set of key and value pairs. To show
several lists that need telling apart, wrap each in
[`gov_summary_card()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary_card.md).

## Usage

``` r
gov_summary(inputId, headers, info, border = TRUE)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- headers:

  Character vector of row headers (the keys).

- info:

  Summary information values for the table. Each value accepts a plain
  character string, or `shiny` tag objects such as
  `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).
  Pass a list rather than a character vector to mix tag and string
  values.

- border:

  Whether to show borders between rows. Default `TRUE`.

## Value

A `div` HTML shiny tag object holding the summary list `<dl>`, which has
`inputId` as its id. The `div` lets the list change layout based on its
own width.

## Details

The list switches between GOV.UK's stacked and side-by-side layouts
based on its own width rather than the screen's. It stays stacked until
it is as wide as a full-width GOV.UK list at GOV.UK's 641px breakpoint
(about 580px), so in a narrow column, such as
`gov_box(size = "two-thirds")`, the key column is never too narrow for
ordinary words. Browsers without CSS container queries use GOV.UK's
screen-width breakpoint instead.

## See also

Other Govstyle feedback types:
[`confirmation_panel()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/confirmation_panel.md),
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
[`gov_summary_card()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary_card.md),
[`gov_tag()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_tag.md),
[`inset_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/inset_text.md),
[`label_hint()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/label_hint.md),
[`noti_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/noti_banner.md),
[`value_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/value_box.md),
[`warning_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/warning_text.md)

## Examples

``` r
# Vector API
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

ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples"
  ),
  shinyGovstyle::gov_main_layout(
    shinyGovstyle::gov_summary("sumID", headers, info)
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
