# Auto-wire service navigation links to tabset panels

Sets up one observer per nav link that switches the corresponding tab
panel when the link is clicked. Eliminates the per-link `observeEvent()`
boilerplate that multi-page apps would otherwise need.

Call once in your server function, after
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
has been added to the UI. The active nav highlight and (when
`auto_page_title = TRUE`) the browser tab title are already handled
client-side, so no additional wiring is needed.

## Usage

``` r
service_navigation_server(session, tabset_id, link_to_panel)
```

## Arguments

- session:

  The Shiny session object

- tabset_id:

  The `id` of the
  [`shiny::tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html)
  or
  [`bslib::navset_hidden()`](https://rstudio.github.io/bslib/reference/navset.html)
  to switch

- link_to_panel:

  A character vector mapping nav link inputIds to tab panel values. Pass
  a **named** vector when inputIds differ from panel values (names =
  inputIds, values = panel values). Pass an **unnamed** vector as
  shorthand for the 1:1 case — each element is used as both the nav
  inputId and the panel value.

## Value

NULL, called for side effects

## See also

Other Govstyle navigation:
[`backlink_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/backlink_Input.md),
[`contents_link()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/contents_link.md),
[`navigate_to()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/navigate_to.md),
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md),
[`update_page_title()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_page_title.md),
[`update_service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::service_navigation(
    c(Summary = "sn_summary", Detail = "sn_detail")
  ),
  bslib::navset_hidden(
    id = "tabs",
    bslib::nav_panel("summary", "Summary content"),
    bslib::nav_panel("detailed_data", "Detail content")
  )
)

server <- function(input, output, session) {
  # Nav inputIds differ from panel values
  shinyGovstyle::service_navigation_server(
    session,
    tabset_id = "tabs",
    link_to_panel = c(
      sn_summary = "summary",
      sn_detail = "detailed_data"
    )
  )

  # Or, when inputIds match panel values exactly:
  # shinyGovstyle::service_navigation_server(
  #   session,
  #   tabset_id = "tabs",
  #   link_to_panel = c("summary", "detailed_data")
  # )
}

if (interactive()) shiny::shinyApp(ui = ui, server = server)
```
