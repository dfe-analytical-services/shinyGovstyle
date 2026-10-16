# Contents link function

**\[deprecated\]**

This function creates an action link to nav between tabs and optionally
link to subcontents headers.

`contents_link()` was deprecated in shinyGovstyle 0.2.0 and will be
removed in shinyGovstyle 1.0.0. For multi-page layouts,
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
is the recommended approach: it gives users the GOV.UK service
navigation bar for moving between pages (tab panels), with
[`service_navigation_server()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation_server.md)
and
[`navigate_to()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/navigate_to.md)
to switch panels from the server.

[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
is not a drop-in replacement. It has no equivalent of the subcontents
links, and it does not create links to headings within a page. For
those, use ordinary links to heading ids, e.g.
`heading_text("Methodology", id = "methodology")` with
`shiny::tags$a(href = "#methodology", class = "govuk-link", "Methodology")`.

## Usage

``` r
contents_link(link_text, input_id, subcontents_text_list, subcontents_id_list)
```

## Arguments

- link_text:

  vector of link text for contents

- input_id:

  contents button Id

- subcontents_text_list:

  vector of link text for subcontents

- subcontents_id_list:

  vector of link Ids for subcontents. If missing automatically matches
  to Id in
  [`heading_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/heading_text.md)

## Value

an action button HTML shiny tag object

## Examples

``` r
# Multi-page layout: service_navigation() moves between tab panels
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(org_name = "Example", service_name = "My service"),
  shinyGovstyle::service_navigation(
    c("Summary" = "summary", "Methodology" = "methodology")
  ),
  shinyGovstyle::gov_main_layout(
    bslib::navset_hidden(
      id = "pages",
      bslib::nav_panel_hidden(
        "summary",
        shinyGovstyle::heading_text("Summary", size = "l"),
        # In-page anchor links are ordinary links to heading ids
        shiny::tags$a(
          href = "#key-findings",
          class = "govuk-link",
          "Key findings"
        ),
        shinyGovstyle::heading_text(
          "Key findings",
          size = "m",
          level = 2,
          id = "key-findings"
        )
      ),
      bslib::nav_panel_hidden(
        "methodology",
        shinyGovstyle::heading_text("Methodology", size = "l")
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {
  shinyGovstyle::service_navigation_server(
    session,
    tabset_id = "pages",
    link_to_panel = c("summary", "methodology")
  )
}

if (interactive()) shiny::shinyApp(ui = ui, server = server)
```
