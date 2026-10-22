# Layout options

## Overview

shinyGovstyle provides a set of layout functions that produce the HTML
structure GOV.UK Frontend CSS expects. This vignette covers all of the
layout functions available and explains how they fit together to build a
complete app.

Every app starts with
**[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md)**,
the outer wrapper for the whole page. Inside it go:

- **Page-level components**
  ([`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
  [`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
  [`phase_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/phase_banner.md),
  [`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
  [`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md),
  and
  [`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md))
  form the frame of the page that sits outside the main content area.
- **Content layout functions**:
  [`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
  holds the main content area, and
  [`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
  and
  [`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
  add grid columns inside it when you need them.

------------------------------------------------------------------------

## `gov_page()`

[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md)
is a small wrapper around [bslib](https://rstudio.github.io/bslib/)’s
`page_fluid()`. `bslib` is now generally the recommended way to build R
Shiny UIs, in place of
[`shiny::fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html),
and other `bslib` components can be mixed freely into a shinyGovstyle
app. Use
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md)
as the very first thing your UI creates: everything else in this
vignette goes inside it.

``` r

ui <- gov_page(
  title = "My dashboard",
  # header(), footer(), and the rest of your page go here
)
```

Three arguments are worth knowing about:

- **`lang`**: the page’s language, `"en"` by default. Screen readers
  rely on this to pick the right pronunciation and voice, so it matters
  for accessibility even on a page you never plan to translate. Set it
  to `"cy"` for a Welsh-language service, for example.
- **`description`**: a short summary of the page, added as a
  `<meta name="description">` tag for search engines and some assistive
  technology. Optional; there’s no tag at all if you leave it out. Keep
  it to one concise sentence: search engines typically truncate meta
  descriptions at around 150-160 characters.
- **`width`** (see [Page width](#page-width) below): sets a default
  width for every shinyGovstyle component used inside it, so you don’t
  have to repeat `width =` on each one individually.

### Page width

By default,
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md)
lets shinyGovstyle components fill the browser window
(`width = "full"`), which suits most dashboard-style apps. For an
ordinary content page, where GOV.UK’s usual narrower reading width is
more appropriate, pass `width` to
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md):

``` r

gov_page(
  width = "standard", # or "three-quarters", or a CSS length like "1400px"
  # ...
)
```

- **`"full"`** (the default): no maximum width, so the page fills the
  browser window, and also removes the gaps between grid columns, so
  content can run edge to edge.
- **`"standard"`**: GOV.UK’s usual 960px content width, the better
  choice for an ordinary content-style page.
- **`"three-quarters"`**: three-quarters of the browser window’s width
  (never narrower than standard), keeping GOV.UK’s own left/right
  margins.
- **A CSS length**, e.g. `"1400px"` or `"90vw"`, for a specific maximum
  width instead of one of the presets above.

Every shinyGovstyle component that renders part of the page frame
([`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`phase_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/phase_banner.md),
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md),
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md))
also accepts its own `width` argument. Setting it on
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md)
sets the default for all of them at once. Setting it on an individual
component overrides that default just for that one component, which is
useful if, say, everything on your page should be wider except the
footer:

``` r

gov_page(
  width = "three-quarters",
  header(...),
  gov_main_layout(...),
  footer(..., width = "standard") # this one stays at the standard width
)
```

### Content width vs page width

`gov_page(width = ...)` only sets the *outer* ceiling: how wide the page
frame is allowed to get. It’s a separate thing from how wide any one
piece of *content* looks, which you control on the content itself.

**Recommended setup:** for a dashboard-style app, set
`gov_page(width = "full")` so wide tables, charts and value boxes get
the room they need. Then, for any text-heavy page or section within that
same app (a cookies page, a user guide, an accessibility statement),
wrap its content in a `div` with GOV.UK’s `govuk-!-width-two-thirds`
class, rather than letting it stretch the full width of the page. The
class works on its own, without the grid, and goes back to full width on
small screens.

> **Avoid full-width body text.** GOV.UK’s own [Design System
> guidance](https://design-system.service.gov.uk/styles/layout/)
> recommends keeping body text to a two-thirds width even on a wide
> page, so lines don’t get so long they’re hard to read (aim for no more
> than about 75 characters per line). Paragraphs on a `"full"`-width
> page with no width set produce lines that stretch the entire screen:
> technically valid, but noticeably harder to read. Reserve full width
> for content that actually benefits from the extra room, like a wide
> table.

In practice this means: pick a page `width` for the *space you need*
(e.g. `"full"` for a dashboard with wide tables), then narrow the
sections that need it, independently of the page:

``` r

gov_page(
  width = "full",
  gov_main_layout(
    shiny::tags$div(
      class = "govuk-!-width-two-thirds",
      gov_text("Readable body text stays narrow, even on a wide page.")
    ),
    govTable(my_wide_data)
  )
)
```

The example showcase app applies the same idea: its Cookies tab sits in
a two-thirds column, so it reads as a normal, narrow text page even
though the app itself uses `gov_page(width = "full")`.

------------------------------------------------------------------------

## Page-level components

These components form the outer frame of every page, inside
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md).
They sit outside the main content area and are consistent across all
pages of your app.

    +-------------------------------------------------------+
    |  skip_to_main()   [visually hidden, keyboard only]    |
    +-------------------------------------------------------+
    |  cookieBanner()   [optional]                          |
    +-------------------------------------------------------+
    |  header()                                             |
    +-------------------------------------------------------+
    |  service_navigation()   [optional, multi-page apps]   |
    +-------------------------------------------------------+
    |  phase_banner()   [optional, e.g. Beta or Alpha]      |
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

Creates a page-level header based on the [Generic
header](https://design-system.service.gov.uk/components/generic-header/).
The organisation name and optional logo link to your homepage. The
separate, optional service title remains part of
[`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md):
it is a shinyGovstyle extension, centred on wide screens and stacked
below the organisation on smaller screens. Long names wrap; the
organisation wraps before the service title where possible. Use one
[`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md)
per page.

``` r

# Text-only identity, without a service title
header("Example organisation")

# The existing positional call remains supported
header("Example organisation", "My dashboard")

# Custom logo alongside the organisation name
header(
  "Ministry of Justice", "My dashboard",
  logo = "shinyGovstyle/images/moj_logo.png",
  logo_alt_text = "",
  logo_width = 66, logo_height = 34,
  homepage_url = "/my-app/"
)

# Image-only identity: alternative text names the homepage link
header(
  org_name = NULL,
  logo = "shinyGovstyle/images/moj_logo.png",
  logo_alt_text = "Ministry of Justice",
  homepage_url = "/my-app/"
)
```

The default `homepage_url = "/"` goes to the domain root. If your app is
hosted at `https://example.org/my-app/`, set
`homepage_url = "/my-app/"`. The showcase uses `"./"` to return to its
current app directory. Choose the URL explicitly if your hosting
arrangement uses deeper paths.

Use `logo_alt_text = ""` when the adjacent organisation name already
identifies the logo. For an image-only identity, supply meaningful
alternative text. Image dimensions apply to each image, so one header
cannot change another image’s size.

#### Migrating to the v1.0.0 header

The header appearance and CSS selectors have changed. The default is now
text only: pass `logo` explicitly if your app needs an image. The
`"crown"` shortcut now raises an error because Generic header guidance
excludes the GOV.UK crown. Replace `logo = "crown"` with `logo = NULL`
or your own organisation’s logo path and appropriate alternative text.

`service_name` remains supported. The six deprecated arguments keep
their existing behaviour until their scheduled v1.0.0 removal: replace
`main_text` with `org_name` and `secondary_text` with `service_name`;
remove `main_link`, `secondary_link`, `main_alt_text` and
`secondary_alt_text`, which have no effect. Use `homepage_url` for the
new organisation link.

Update any custom selectors:

| Previous selector | Replacement |
|----|----|
| `.govuk-header` | `.govuk-generic-header` or `.shinygovstyle-header` |
| `.govuk-header__container` | `.govuk-generic-header__container` |
| `.govuk-header__logo` | `.govuk-generic-header__logo` |
| `.govuk-header__product-name` | `.shinygovstyle-header__organisation` |
| `.govuk-header__content`, `.govuk-header__service-name` | `.shinygovstyle-header__service-name` |
| `.govuk-header__logotype-crown-fallback-image` | `.shinygovstyle-header__image` |
| `.govuk-header__logo--mirror` | Removed; no duplicated identity is needed |

The homepage link uses `.govuk-generic-header__homepage-link`. Add your
own outer-header hooks with `classes = "my-header"` and
`attributes = list(id = "site-header")`. The header retains its banner
landmark.

The header uses a system sans-serif font. Replacing it does **not**
remove GOV.UK branding elsewhere: review your fonts, colours, favicons
and footer imagery against [Using Frontend without GOV.UK
branding](https://frontend.design-system.service.gov.uk/using-govuk-frontend-without-govuk-branding/).
Generic header is intended for government services outside the GOV.UK
website; services covered by GOV.UK’s branded-header requirements need
the appropriate branded component.

### `phase_banner()`

Displays a phase banner immediately below the header, used to indicate
the maturity of your service and give a clear route for users to provide
feedback.

The `feedback_url` argument is the recommended shortcut for the standard
GOV.UK feedback wording: pass a URL (or a `mailto:` link for
contact-style text) and the text is generated for you:

``` r

phase_banner(
  inputId = "phase-banner",
  type = "Beta",
  feedback_url = "https://example.com/feedback"
)
```

For custom wording, use `label` instead (exactly one of `label` or
`feedback_url` should be supplied):

``` r

phase_banner(
  inputId = "phase-banner",
  type = "Beta",
  label = shiny::tagList(
    "This is a new service \u2014 your ",
    shiny::tags$a(class = "govuk-link", href = "#", "feedback"),
    " will help us to improve it."
  )
)
```

`label` also accepts a plain character string or raw HTML
(e.g. `"...<a class=\"govuk-link\" href=\"#\">feedback</a>..."`); the
[`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
form above is preferred for readability and to avoid hand-written HTML.

For more information on when and how to use this, read the documentation
for the [GOV.UK Phase banner
component](https://design-system.service.gov.uk/components/phase-banner/).

### `footer()`

Creates a GOV.UK styled footer. Review its branding separately from the
Generic header. Use `full = TRUE` to include the OGL licence logo and
Crown copyright statement. You can add support links that point either
to internal hidden tab panels or to external URLs.

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

## Laying out content

Content goes straight into
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md).
Items stack one below the other, so a page that is just a heading, some
text and a table needs no extra layout functions:

``` r

gov_main_layout(
  heading_text("Page title", size = "l"),
  gov_text("Some introductory text."),
  govTable(my_data)
)
```

### A simple text page

For a page that is mostly text, use the standard page width and keep the
text to two-thirds of it, as the [GOV.UK layout
guidance](https://design-system.service.gov.uk/styles/layout/)
recommends for readable line lengths. GOV.UK’s
`govuk-!-width-two-thirds` class does this without the grid, and goes
back to full width on small screens:

``` r

gov_page(
  width = "standard",
  gov_main_layout(
    shiny::tags$div(
      class = "govuk-!-width-two-thirds",
      heading_text("Cookies", size = "l"),
      gov_text("This page explains how we use cookies.")
    )
  )
)
```

### Columns with `gov_row()` and `gov_box()`

Reach for the grid only when you need **side-by-side columns**, or a
section that should sit in a grid column of a set width. It’s a
two-function system:
[`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
holds the columns, and
[`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
is each column.

    gov_main_layout()
    └── gov_row()
        ├── gov_box(size = "two-thirds")
        │   └── [your content]
        └── gov_box(size = "one-third")
            └── [your content]

#### `gov_row()`

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

#### `gov_box()`

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

A single full-width box adds nothing over putting the content directly
in
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
so leave the grid out in that case.

### `gov_text()`

A wrapper that produces a `<p class="govuk-body">` paragraph element.
For full guidance on
[`gov_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
and all other text functions, see the [Headings and
text](https://dfe-analytical-services.github.io/shinyGovstyle/articles/headings-and-text.md)
vignette.

------------------------------------------------------------------------

## `gov_layout()` (deprecated)

[`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md)
is deprecated as of shinyGovstyle 0.3.0 and will be removed in
shinyGovstyle 1.0.0. Use
[`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
with
[`gov_row()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
and
[`gov_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)
instead; the deprecation warning shows how each argument maps across.

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
The names are displayed as link text and the values become the inputIDs:

``` r

service_navigation(
  c(
    "Summary" = "nav_summary",
    "Detailed data" = "nav_detail",
    "User guide" = "nav_guide"
  )
)
```

If you pass an unnamed vector, the link text is used to make the
inputIDs instead.

Either way, every inputID is cleaned up by lowercasing it and replacing
non-alphanumeric characters with underscores, so `"Detailed data"`
becomes `detailed_data` and `"Nav-Summary"` becomes `nav_summary`. Each
link must end up with a unique inputID.
[`service_navigation_server()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation_server.md),
[`navigate_to()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/navigate_to.md),
and
[`update_service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md)
clean up the ids you pass them in the same way, so you can use either
form there.

Put
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
in your app’s top-level UI and wire it up from the top-level server
function, not inside a Shiny module. Because of the clean-up, an id
wrapped in `ns()` (e.g. `NS("mod", "summary")`) becomes `mod_summary`,
which no longer matches the module’s namespaced input.

### Wiring navigation to panels

Use a hidden tab panel for the content area.
[`service_navigation_server()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation_server.md)
then wires every nav link to its panel in a single call — no per-link
`observeEvent` boilerplate:

``` r

# ui.R — shiny tabsetPanel
shiny::tabsetPanel(
  type = "hidden",
  id = "main_panels",
  shiny::tabPanel("Summary",       value = "summary",       "Content"),
  shiny::tabPanel("Detailed data", value = "detailed_data", "Content"),
  shiny::tabPanel("User guide",    value = "user_guide",    "Content")
)

# server.R — auto-wire the nav links to the panels
shinyGovstyle::service_navigation_server(
  session,
  tabset_id = "main_panels",
  link_to_panel = c(
    nav_summary  = "summary",
    nav_detail   = "detailed_data",
    nav_guide    = "user_guide"
  )
)
```

`link_to_panel` is a named character vector — names are nav link
inputIds, values are panel values. If your inputIds already match your
panel values, pass an unnamed vector instead.

[`bslib::navset_hidden()`](https://rstudio.github.io/bslib/reference/navset.html)
also responds to
[`updateTabsetPanel()`](https://rdrr.io/pkg/shiny/man/updateTabsetPanel.html),
so the same call works whether your tab panel is shiny or bslib.

For navigation that can’t be wired declaratively — next / back buttons,
modal links, footer shortcuts — use
[`navigate_to()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/navigate_to.md)
to combine the panel switch and the nav-active update in one call:

``` r

# server.R — programmatic navigation in one call
shiny::observeEvent(input$next_btn, {
  shinyGovstyle::navigate_to(
    session, "main_panels",
    inputId = "nav_detail", panel = "detailed_data"
  )
})
```

[`navigate_to()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/navigate_to.md)
defaults to using the nav link `inputId` as the target panel value. Here
`nav_detail`’s panel value is `detailed_data` (per the `link_to_panel`
mapping above), so pass `panel` explicitly whenever the inputId and
panel value differ. See
[`?navigate_to`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/navigate_to.md)
for full details.

### Keeping the page title in sync

[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
syncs the browser tab title with the active nav link by default, both
for link clicks and for programmatic navigation via
[`update_service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md).
Pass `page_title_suffix` to get the recommended `"<page> | <service>"`
format, or `auto_page_title = FALSE` to opt out. For pages where the
heading differs from the nav label (or for pages not in the nav), call
[`update_page_title()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_page_title.md)
explicitly. See the [Page titles section of the Headings and text
vignette](https://dfe-analytical-services.github.io/shinyGovstyle/articles/headings-and-text.html#page-titles)
for the full rationale and examples.

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

Footer-only pages also fall outside the
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md)
auto page-title sync — there is no nav link for the JavaScript binding
to read. Call
[`update_page_title()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_page_title.md)
so the browser tab title reflects the new page:

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
  shiny::tabPanel("Summary", value = "nav_summary", "Content"),
  shiny::tabPanel("Accessibility statement", value = "accessibility_panel",
                  "Content")
)

# server.R — navigate to the footer page (no update_service_navigation needed)
shiny::observeEvent(input$accessibility_footer_link, {
  shiny::updateTabsetPanel(session, "main_panels",
                           selected = "accessibility_panel")
  shinyGovstyle::update_page_title(
    session,
    page_title = "Accessibility statement",
    service_name = "My dashboard"
  )
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

ui <- gov_page(
  title = "Summary | My dashboard",
  skip_to_main(),
  header(
    org_name = "My department",
    service_name = "My dashboard"
  ),
  service_navigation(
    c(
      "Summary"  = "nav_summary",
      "About"    = "nav_about"
    ),
    page_title_suffix = "My dashboard"
  ),
  phase_banner(
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
        # Text-only page: two-thirds keeps it readable even though the
        # app itself uses gov_page(width = "full"). See "Content width
        # vs page width" above.
        shiny::tags$div(
          class = "govuk-!-width-two-thirds",
          heading_text("About this dashboard", size = "l"),
          gov_text("This page describes the dashboard.")
        )
      ),

      shiny::tabPanel(
        "Accessibility statement", value = "accessibility_panel",
        shiny::tags$div(
          class = "govuk-!-width-two-thirds",
          heading_text("Accessibility statement", size = "l"),
          gov_text("This page describes the accessibility of the dashboard.")
        )
      )
    )
  ),

  footer(
    links = c(`Accessibility statement` = "accessibility_footer_link")
  )
)

server <- function(input, output, session) {
  service_navigation_server(
    session,
    tabset_id = "main_panels",
    link_to_panel = c("nav_summary", "nav_about")
  )

  shiny::observeEvent(input$accessibility_footer_link, {
    shiny::updateTabsetPanel(session, "main_panels",
                             selected = "accessibility_panel")
    update_page_title(
      session,
      page_title = "Accessibility statement",
      service_name = "My dashboard"
    )
  })
}

shiny::shinyApp(ui, server)
```
