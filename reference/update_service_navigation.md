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

  The inputId of the service navigation link to set as active

## Value

NULL, called for side effects

## See also

Other Govstyle navigation:
[`backlink_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/backlink_Input.md),
[`contents_link()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/contents_link.md),
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)

## Examples

``` r
# Nav link clicked — JS handles active state, just switch the panel.
# Works the same whether you use shiny or bslib tab panels.
if (interactive()) {
  server <- function(input, output, session) {
    # shiny tabsetPanel
    shiny::observeEvent(input$page_two, {
      shiny::updateTabsetPanel(session, "tabs", selected = "page_two")
    })

    # bslib navset
    shiny::observeEvent(input$page_two, {
      bslib::nav_select("tabs", "page_two")
    })
  }
}

# Programmatic navigation (e.g. a next / back button) — the nav link is not
# clicked, so you must also call update_service_navigation() explicitly.
if (interactive()) {
  server <- function(input, output, session) {
    # shiny tabsetPanel
    shiny::observeEvent(input$next_btn, {
      shiny::updateTabsetPanel(session, "tabs", selected = "page_two")
      shinyGovstyle::update_service_navigation(session, "page_two")
    })

    # bslib navset
    shiny::observeEvent(input$next_btn, {
      bslib::nav_select("tabs", "page_two")
      shinyGovstyle::update_service_navigation(session, "page_two")
    })
  }
}
```
