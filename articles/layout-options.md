# Layout options

## Overview

shinyGovstyle provides a set of layout functions that produce the HTML
structure GOV.UK Frontend CSS expects. This vignette covers all of the
layout functions available and explains how they fit together to build a
complete app.

The layout functions fall into two groups:

- **Page-level components** —
  [`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
  [`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
  [`banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/banner.md),
  [`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
  [`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md),
  and
  [`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
  — form the frame of the page that sits outside the main content area.
- **Content layout functions** —
  [`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
  [`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
  [`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
  and
  [`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md)
  — structure content within the main content area.

------------------------------------------------------------------------

## Page-level components

These components form the outer frame of every page. They sit outside
the main content area and are consistent across all pages of your app.

    +-------------------------------------------------------+
    |  skip_to_main()   [visually hidden, keyboard only]    |
    +-------------------------------------------------------+
    |  cookieBanner()   [optional]                          |
    +-------------------------------------------------------+
    |  header()                                             |
    +-------------------------------------------------------+
    |  service_navigation()   [optional, multi-page apps]   |
    +-------------------------------------------------------+
    |  banner()   [optional, e.g. Beta or Alpha]            |
    +-------------------------------------------------------+
    |                                                       |
    |  gov_main_layout()   ← id = "main"                    |
    |  +--------------------------------------------------+  |
    |  |  your content goes here                         |  |
    |  +--------------------------------------------------+  |
    |                                                       |
    +-------------------------------------------------------+
    |  footer()                                             |
    +-------------------------------------------------------+

### `skip_to_main()`

Provides a visually hidden “Skip to main content” link that becomes
visible when focused by a keyboard user. This is an accessibility
requirement and should always be the first element in your UI, before
the header.

``` r
skip_to_main()
```

By default it links to `#main`, which matches the `id` applied by
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md).
If you change the `inputID` argument of
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
pass the same value to
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md).

For more information, read the documentation for the [GOV.UK Skip link
component](https://design-system.service.gov.uk/components/skip-link/).

### `cookieBanner()`

Displays a GOV.UK-styled cookie consent banner. It requires
[`shinyjs::useShinyjs()`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html)
to be present in the UI. All element IDs within the banner are preset —
see
[`?cookieBanner`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md)
for the server-side `observeEvent` pattern needed to handle accept and
reject interactions.

``` r
shinyjs::useShinyjs()
cookieBanner("My service name")
```

For more information, including when this should be used, read the
documentation for the [GOV.UK Cookie banner
component](https://design-system.service.gov.uk/components/cookie-banner/).

### `header()`

Creates a GOV.UK styled header bar, optionally containing your
department logo, name and service name. This is not the official [GOV.UK
header](https://design-system.service.gov.uk/components/header/), as
that should only be used on GOV.UK domains. If you believe you have an R
Shiny app on a GOV.UK domain, please [raise an
issue](https://github.com/dfe-analytical-services/shinyGovstyle/issues/new/choose)
to request this as an addition to the package.

``` r
header(
  main_text = "Department for Education",
  secondary_text = "My dashboard"
)
```

### `banner()`

Displays a phase banner immediately below the header, used to indicate
the maturity of your service and give a clear route for users to provide
feedback.

``` r
banner(
  inputId = "phase-banner",
  type = "Beta",
  label = 'This is a new service — your <a class="govuk-link" href="#">feedback</a> will help us to improve it.'
)
```

For more information on when and how to use this, read the documentation
for the [GOV.UK Phase banner
component](https://design-system.service.gov.uk/components/phase-banner/).

### `footer()`

Creates a GOV.UK styled footer, though like the header, this is not an
offical version as that should only be used on a GOV.UK domain. Use
`full = TRUE` to include the OGL licence logo and Crown copyright
statement. You can add support links that point either to internal
hidden tab panels or to external URLs.

``` r
# Minimal footer
footer()

# Footer with support links
footer(
  links = c(
    `Accessibility statement` = "accessibility_footer_link",
    `Cookies` = "cookies_footer_link"
  )
)
```

Internal links use auto-generated inputIDs — the link text lowercased
with non-alphanumeric characters replaced by underscores — that you
handle with
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html) in
your server to switch the active tab panel.

------------------------------------------------------------------------

## The main content area

[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
produces a `<div class="govuk-width-container">` wrapping a
`<main class="govuk-main-wrapper">`. The outer `<div>` constrains
content width; the `<main>` element carries the responsive vertical
padding. Everything between the page-level components and the footer
lives inside it.

``` r
gov_main_layout(
  # your content here
)
```

The `id` (default `"main"`) is applied directly to the `<main>` element,
which is the correct target for
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md).
The `<main>` element also carries `role="main"` and `tabindex="-1"`, so
keyboard focus moves to it when the skip link is activated.

------------------------------------------------------------------------

## The primary layout system

Inside
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
content is structured using a three-function grid system:
[`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
[`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
and optionally
[`gov_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md).

    gov_main_layout()
    └── gov_row()
        ├── gov_box(size = "two-thirds")
        │   └── [your content]
        └── gov_box(size = "one-third")
            └── [your content]

### `gov_row()`

Creates a GOV.UK grid row. You can have multiple rows inside
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
each stacked vertically.

``` r
gov_main_layout(
  gov_row(
    # columns go here
  ),
  gov_row(
    # another row
  )
)
```

### `gov_box()`

Creates a column within a row. The `size` argument controls the column
width using GOV.UK Frontend’s grid classes:

| `size`             | Width |
|--------------------|-------|
| `"full"`           | 100%  |
| `"one-half"`       | 50%   |
| `"two-thirds"`     | 66%   |
| `"one-third"`      | 33%   |
| `"three-quarters"` | 75%   |
| `"one-quarter"`    | 25%   |

Sizes within a row should add up to a full width. For example,
`"two-thirds"` and `"one-third"` sit side by side:

``` r
gov_main_layout(
  gov_row(
    gov_box(
      size = "two-thirds",
      heading_text("Main content", size = "l"),
      # inputs, text, etc.
    ),
    gov_box(
      size = "one-third",
      heading_text("Sidebar", size = "m"),
      # supporting content
    )
  )
)
```

For a simple single-column layout, use `size = "full"`:

``` r
gov_main_layout(
  gov_row(
    gov_box(
      size = "full",
      heading_text("Page title", size = "l")
    )
  )
)
```

### `gov_text()`

A wrapper that produces a `<p class="govuk-body">` paragraph element.
For full guidance on
[`gov_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
and all other text functions, see the [Headings and
text](https://dfe-analytical-services.github.io/shinyGovstyle/articles/headings-and-text.md)
vignette.

------------------------------------------------------------------------

## `gov_layout()` — legacy alternative

> **Warning:**
> [`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md)
> is not recommended for new development and may be removed in a future
> release. Use
> [`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
> with
> [`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
> and
> [`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
> instead.

[`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md)
is a single-function alternative that combines a width container and a
column in one call:

``` r
gov_layout(
  size = "two-thirds",
  heading_text("Page title", size = "l"),
  # content
)
```

It is well suited to simple, single-column apps where you want a width
constraint without setting up the full
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
/
[`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
/
[`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
hierarchy.

**As soon as your app needs more than one column, multiple rows, or a
combination of widths, switch to the full system.** Nesting
[`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md)
inside
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
will produce doubled-up width container HTML and cause the content to
appear visually inset from the page-level components.

------------------------------------------------------------------------

## Multi-page dashboards

For apps with multiple sections, use
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
in combination with a hidden tab panel. The navigation bar renders as a
row of links below the header; clicking a link fires a Shiny input that
you use in your server to switch the visible panel.

### Setting up navigation links

Pass a named character vector to
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md).
The names are displayed as link text; the values become the inputIDs:

``` r
service_navigation(
  c(
    "Summary" = "nav_summary",
    "Detailed data" = "nav_detail",
    "User guide" = "nav_guide"
  )
)
```

If you pass an unnamed vector, inputIDs are auto-generated by
lowercasing the text and replacing non-alphanumeric characters with
underscores (e.g. `"Detailed data"` becomes `detailed_data`).

### Wiring navigation to panels

Use a hidden tab panel for the content area and
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html) in
your server to switch panels when a navigation link is clicked. When the
user clicks a service navigation link, the JavaScript binding updates
the active state automatically — you only need to switch the panel:

``` r
# ui.R — shiny tabsetPanel
shiny::tabsetPanel(
  type = "hidden",
  id = "main_panels",
  shiny::tabPanel("Summary",       value = "nav_summary",  "Content"),
  shiny::tabPanel("Detailed data", value = "nav_detail",   "Content"),
  shiny::tabPanel("User guide",    value = "nav_guide",    "Content")
)

# server.R — nav link click: JS handles the active state, just switch the panel
shiny::observeEvent(input$nav_summary, {
  shiny::updateTabsetPanel(session, "main_panels", selected = "nav_summary")
})
```

If you prefer bslib tab panels, use
[`bslib::navset_hidden()`](https://rstudio.github.io/bslib/reference/navset.html)
and
[`bslib::nav_select()`](https://rstudio.github.io/bslib/reference/nav_select.html)
instead:

``` r
# ui.R — bslib navset_hidden
bslib::navset_hidden(
  id = "main_panels",
  bslib::nav_panel("Summary",       value = "nav_summary",  "Content"),
  bslib::nav_panel("Detailed data", value = "nav_detail",   "Content"),
  bslib::nav_panel("User guide",    value = "nav_guide",    "Content")
)

# server.R
shiny::observeEvent(input$nav_summary, {
  bslib::nav_select("main_panels", "nav_summary")
})
```

Repeat the `observeEvent` block for each navigation link.

[`update_service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md)
is only needed when navigation is triggered **programmatically** — for
example, via a next / back button — because in that case the nav link
itself is not clicked and the active state does not update
automatically. See
[`?update_service_navigation`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md)
for full details and examples.

``` r
# server.R — programmatic navigation: must update both the panel and the nav
shiny::observeEvent(input$next_btn, {
  shiny::updateTabsetPanel(session, "main_panels", selected = "nav_detail")
  shinyGovstyle::update_service_navigation(session, "nav_detail")
})
```

### Footer-only pages

Some pages — such as an accessibility statement, privacy notice, or
cookies information page — should not appear in the service navigation
but still need to be reachable. The standard pattern is to add a link in
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md)
and a corresponding hidden tab panel, but to omit the link from
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md).

Because the user navigates to these pages outside of the service
navigation, there is no active nav item to highlight. You do not need to
call
[`update_service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md)
for these transitions. However, you should call it when navigating
*back* to a main page from a footer-linked page, so the correct nav item
becomes active again.

``` r
# ui.R — footer link, no entry in service_navigation()
footer(
  full = TRUE,
  links = c(`Accessibility statement` = "accessibility_footer_link")
)

# ui.R — tab panel exists in the hidden tabset but not in service_navigation()
shiny::tabsetPanel(
  type = "hidden",
  id = "main_panels",
  shiny::tabPanel("Summary",                 value = "nav_summary",         "Content"),
  shiny::tabPanel("Accessibility statement", value = "accessibility_panel", "Content")
)

# server.R — navigate to the footer page (no update_service_navigation needed)
shiny::observeEvent(input$accessibility_footer_link, {
  shiny::updateTabsetPanel(session, "main_panels", selected = "accessibility_panel")
})
```

### Modularising the code

Once an app has multiple pages, it is strongly recommended to use Shiny
modules to keep each page’s UI and server logic self-contained. The
`inst/example_app` bundled with this package demonstrates this pattern:
each page is a module in `inst/example_app/modules/`, with
`mod_<name>_ui()` and `mod_<name>_server()` functions called from the
top-level `ui.R` and `server.R`. This keeps individual files focused and
makes it straightforward to add or remove pages without touching the
overall app structure.

------------------------------------------------------------------------

## Complete example

The following is a minimal but complete multi-page app that uses all of
the layout components covered in this vignette:

``` r
library(shiny)
library(shinyGovstyle)

ui <- bslib::page_fluid(
  skip_to_main(),
  header(
    main_text = "My department",
    secondary_text = "My dashboard"
  ),
  service_navigation(
    c(
      "Summary"  = "nav_summary",
      "About"    = "nav_about"
    )
  ),
  banner(
    inputId = "phase",
    type = "Beta",
    label = "This is a new service."
  ),

  gov_main_layout(
    shiny::tabsetPanel(
      type = "hidden",
      id = "main_panels",

      shiny::tabPanel(
        "Summary", value = "nav_summary",
        gov_row(
          gov_box(
            size = "two-thirds",
            heading_text("Summary", size = "l"),
            gov_text("Welcome to the summary page.")
          ),
          gov_box(
            size = "one-third",
            heading_text("Quick facts", size = "m"),
            gov_text("Supporting information goes here.")
          )
        )
      ),

      shiny::tabPanel(
        "About", value = "nav_about",
        gov_row(
          gov_box(
            size = "full",
            heading_text("About this dashboard", size = "l"),
            gov_text("This page describes the dashboard.")
          )
        )
      ),

      shiny::tabPanel(
        "Accessibility statement", value = "accessibility_panel",
        gov_row(
          gov_box(
            size = "full",
            heading_text("Accessibility statement", size = "l"),
            gov_text("This page describes the accessibility of the dashboard.")
          )
        )
      )
    )
  ),

  footer(
    links = c(`Accessibility statement` = "accessibility_footer_link")
  )
)

server <- function(input, output, session) {
  shiny::observeEvent(input$nav_summary, {
    shiny::updateTabsetPanel(session, "main_panels", selected = "nav_summary")
  })
  shiny::observeEvent(input$nav_about, {
    shiny::updateTabsetPanel(session, "main_panels", selected = "nav_about")
  })
  shiny::observeEvent(input$accessibility_footer_link, {
    shiny::updateTabsetPanel(session, "main_panels", selected = "accessibility_panel")
  })
}

shiny::shinyApp(ui, server)
```
