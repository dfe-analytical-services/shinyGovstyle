# Navigate to a page in one call

Switches the visible tab panel and updates the active service navigation
link in a single call. Use this for programmatic navigation — next /
back buttons, modal links, footer shortcuts to a main page — where the
user has not clicked a nav link directly.

When
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
is used with `auto_page_title = TRUE` (the default), the browser tab
title is updated automatically too, because
[`update_service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md)
triggers the title sync via the JavaScript binding.

By default the nav link `inputId` is also used as the target tab panel
`value`. When they differ — for example when nav inputIds carry a prefix
like `sn_` to disambiguate from panel values — pass `panel` explicitly.

## Usage

``` r
navigate_to(session, tabset_id, inputId, panel = inputId)
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

- inputId:

  The nav link inputId to set as the active item in the service
  navigation

- panel:

  The `value` of the tab panel to switch to. Defaults to `inputId` for
  the common case where the two are the same. When your nav inputIds and
  panel values differ (e.g. nav id `sn_cookies`, panel value
  `panel-cookies`), pass `panel` explicitly. If you omit it when the
  values differ, only the nav highlight moves, the visible tab stays
  put.

## Value

NULL, called for side effects

## See also

Other Govstyle navigation:
[`backlink_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/backlink_Input.md),
[`contents_link()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/contents_link.md),
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md),
[`service_navigation_server()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation_server.md),
[`update_page_title()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_page_title.md),
[`update_service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md)

## Examples

``` r
# Next / back buttons that cross page boundaries — inputId and panel
# value match, so a single id is enough.
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::service_navigation(c("Page one", "Page two")),
  bslib::navset_hidden(
    id = "tabs",
    bslib::nav_panel("page_one", shiny::actionButton("next_btn", "Next")),
    bslib::nav_panel("page_two", "Page two content")
  )
)

server <- function(input, output, session) {
  shiny::observeEvent(input$next_btn, {
    shinyGovstyle::navigate_to(session, "tabs", "page_two")
  })
}

if (interactive()) shiny::shinyApp(ui = ui, server = server)

# Mismatched inputId and panel value — name the panel explicitly.
# The nav links use an `sn_` prefix on their inputIds so they don't clash
# with any other inputs in the app. The panel values are unrelated names.
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::service_navigation(
    # names = link text shown to the user, values = nav inputIds
    c(Home = "sn_home", Cookies = "sn_cookies")
  ),
  bslib::navset_hidden(
    id = "tabs",
    # first arg of nav_panel() is the panel value
    bslib::nav_panel("start", shiny::actionButton("cookies_btn", "Cookies")),
    bslib::nav_panel("policy", "Cookies content")
  )
)

server <- function(input, output, session) {
  shiny::observeEvent(input$cookies_btn, {
    # inputId = nav link to highlight; panel = tab panel to show
    shinyGovstyle::navigate_to(
      session, "tabs", inputId = "sn_cookies", panel = "policy"
    )
  })
}

if (interactive()) shiny::shinyApp(ui = ui, server = server)
```
