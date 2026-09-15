# GOV.UK styled page wrapper

`gov_page()` wraps
[`bslib::page_fluid()`](https://rstudio.github.io/bslib/reference/page.html)
so a shinyGovstyle app starts from GOV.UK-friendly defaults instead of a
blank page. `bslib` is now generally the recommended way to build R
Shiny UIs (rather than
[`shiny::fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html)),
so shinyGovstyle builds on it too; you can mix other `bslib` components
into a shinyGovstyle app freely. `gov_page()` sets the page language
(important for screen readers), lets you add a page description, and
lets you set a default width for every shinyGovstyle component in the
page in one place, instead of repeating `width = ` on each of them.

## Usage

``` r
gov_page(
  ...,
  title = NULL,
  lang = "en",
  description = NULL,
  width = "full",
  theme = bslib::bs_theme()
)
```

## Arguments

- ...:

  The rest of your page:
  [`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
  [`banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/banner.md),
  [`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md),
  [`gov_main_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
  [`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
  and so on.

- title:

  Browser tab title, passed straight to
  [`bslib::page_fluid()`](https://rstudio.github.io/bslib/reference/page.html).

- lang:

  The page's language, as an [ISO language
  code](https://www.w3docs.com/learn-html/html-language-codes.html) \#
  nolint (e.g. `"en"`, `"cy"` for Welsh). Screen readers use this to
  choose the right pronunciation and voice, so it should always be set
  correctly. Defaults to `"en"`.

- description:

  Short summary of the page, added as a `<meta name="description">` tag.
  Used by search engines and some assistive technology. Defaults to
  `NULL` (no description tag). Keep it to one concise sentence: search
  engines typically truncate meta descriptions at around 150-160
  characters.

- width:

  Default width for every shinyGovstyle component used inside `...` that
  doesn't set its own `width`. One of `"full"` (the default, no
  max-width, so the page fills the viewport, with grid gutters also
  removed), `"standard"` (GOV.UK's usual 960px content width, the better
  choice for an ordinary content-style page), `"three-quarters"`
  (three-quarters of the viewport, never narrower than standard), or a
  CSS length (e.g. `"1400px"`, `"90vw"`) for a custom max-width. A
  component that sets its own `width` always overrides this default.

- theme:

  A
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
  object, passed straight to
  [`bslib::page_fluid()`](https://rstudio.github.io/bslib/reference/page.html).

## Value

a page HTML shiny tag object

## See also

Other Govstyle page structure:
[`banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/banner.md),
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md),
[`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
[`layouts`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  title = "My dashboard",
  description = "A dashboard showing my department's latest statistics",
  width = "three-quarters",
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "My dashboard"
  ),
  shinyGovstyle::gov_main_layout(
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        shinyGovstyle::heading_text("Welcome", size = "l", level = 1)
      )
    )
  ),
  shinyGovstyle::footer()
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
