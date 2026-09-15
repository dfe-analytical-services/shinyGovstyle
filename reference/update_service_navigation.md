# Update the active item in a service navigation component

Sends a message to the browser to update the highlighted active item in
the service navigation bar.

**When you need this function:** when navigation is triggered
programmatically — for example, via a next / back button or a footer
link that points to a main page. In those cases the nav link itself is
not clicked, so the JavaScript binding does not fire and the active
state does not update automatically. Call `update_service_navigation()`
alongside your tab-switching call to keep them in sync.

**When you don't need this function:** when the user clicks a service
navigation link directly. The JavaScript binding updates the active
state automatically, so you only need to switch the tab panel in your
`observeEvent()`.

## Usage

``` r
update_service_navigation(session, inputId)
```

## Arguments

- session:

  The Shiny session object

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

## Value

NULL, called for side effects

## See also

Other Govstyle navigation:
[`backlink_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/backlink_Input.md),
[`contents_link()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/contents_link.md),
[`navigate_to()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/navigate_to.md),
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md),
[`service_navigation_server()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation_server.md),
[`update_page_title()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_page_title.md)

## Examples

``` r
# Works the same with shiny::tabsetPanel() + shiny::updateTabsetPanel().
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::service_navigation(c("Page one", "Page two")),
  bslib::navset_hidden(
    id = "tabs",
    bslib::nav_panel("page_one", shiny::actionButton("next_btn", "Next")),
    bslib::nav_panel("page_two", "Page two content")
  )
)

server <- function(input, output, session) {
  # Nav link clicked — JS handles the active state, just switch the panel.
  shiny::observeEvent(input$page_two, {
    bslib::nav_select("tabs", "page_two")
  })

  # Programmatic navigation — the nav link is not clicked, so call
  # update_service_navigation() explicitly.
  shiny::observeEvent(input$next_btn, {
    bslib::nav_select("tabs", "page_two")
    shinyGovstyle::update_service_navigation(session, "page_two")
  })
}

if (interactive()) shiny::shinyApp(ui = ui, server = server)
```
