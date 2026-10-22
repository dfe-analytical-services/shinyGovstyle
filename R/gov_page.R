#' GOV.UK styled page wrapper
#'
#' `gov_page()` wraps `bslib::page_fluid()` so a shinyGovstyle app starts
#' from GOV.UK-friendly defaults instead of a blank page. `bslib` is now
#' generally the recommended way to build R Shiny UIs (rather than
#' `shiny::fluidPage()`), so shinyGovstyle builds on it too; you can mix
#' other `bslib` components into a shinyGovstyle app freely. `gov_page()`
#' sets the page language (important for screen readers), lets you add a
#' page description, and lets you set a default width for every
#' shinyGovstyle component in the page in one place, instead of repeating
#' `width = ` on each of them.
#'
#' @param ... The rest of your page: `header()`, `phase_banner()`,
#' `service_navigation()`, `gov_main_layout()`, `footer()`, and so on.
#' @param title Browser tab title, passed straight to
#' `bslib::page_fluid()`.
#' @param lang The page's language, as an
#' [ISO language code](https://www.w3docs.com/learn-html/html-language-codes.html) # nolint
#' (e.g. `"en"`, `"cy"` for Welsh). Screen readers use this to choose the
#' right pronunciation and voice, so it should always be set correctly.
#' Defaults to `"en"`.
#' @param description Short summary of the page, added as a
#' `<meta name="description">` tag. Used by search engines and some
#' assistive technology. Defaults to `NULL` (no description tag). Keep it to
#' one concise sentence: search engines typically truncate meta descriptions
#' at around 150-160 characters.
#' @param width Default width for every shinyGovstyle component used inside
#' `...` that doesn't set its own `width`. One of `"full"` (the default, no
#' max-width, so the page fills the viewport, with grid gutters also
#' removed), `"standard"` (GOV.UK's usual 960px content width, the better
#' choice for an ordinary content-style page), `"three-quarters"`
#' (three-quarters of the viewport, never narrower than standard), or a CSS
#' length (e.g. `"1400px"`, `"90vw"`) for a custom max-width. A component
#' that sets its own `width` always overrides this default.
#' @param theme A `bslib::bs_theme()` object, passed straight to
#' `bslib::page_fluid()`.
#' @param favicon Which browser tab icon (favicon) and theme colour to add.
#' One of:
#' * `"default"` (the default): a plain GOV.UK blue square with no crown, so
#'   every app gets a tidy icon instead of the browser's blank page, without
#'   using GOV.UK branding.
#' * `"govuk"`: the GOV.UK crown icon set from the GOV.UK page template. Only
#'   use this if your service is on GOV.UK: GOV.UK asks that its crown
#'   branding isn't used elsewhere.
#' * `"none"`: no icon tags, for when you add your own with
#'   `shiny::tags$head()`.
#' @return a page HTML shiny tag object
#' @family Govstyle page structure
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   title = "My dashboard",
#'   description = "A dashboard showing my department's latest statistics",
#'   width = "three-quarters",
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "My dashboard"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::heading_text("Welcome", size = "l", level = 1)
#'   ),
#'   shinyGovstyle::footer()
#' )
#'
#' server <- function(input, output, session) {}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
gov_page <- function(
  ...,
  title = NULL,
  lang = "en",
  description = NULL,
  width = "full",
  theme = bslib::bs_theme(),
  favicon = c("default", "govuk", "none")
) {
  favicon <- match.arg(favicon)

  page_width <- validate_width_tier(width)
  page_style <- if (page_width == "custom") {
    paste0("--govuk-page-max-width: ", width, ";")
  } else {
    NULL
  }

  page <- bslib::page_fluid(
    title = title,
    lang = lang,
    theme = theme,
    if (!is.null(description)) {
      shiny::tags$head(
        shiny::tags$meta(name = "description", content = description)
      )
    },
    favicon_tags(favicon),
    shiny::tags$div(
      `data-govuk-page-width` = page_width,
      style = page_style,
      ...
    )
  )

  attachDependency(page)
}

# Icon tags for gov_page(favicon = ). "govuk" is the icon set from the GOV.UK
# Frontend page template; "default" is a crown-free version for apps that
# aren't on GOV.UK. All files are shipped in inst/www/images/ and served under
# the shinyGovstyle/ resource path.
favicon_tags <- function(favicon) {
  if (favicon == "none") {
    return(NULL)
  }
  img <- function(file) paste0("shinyGovstyle/images/", file)
  theme_color <- "#1d70b8"

  icons <- if (favicon == "govuk") {
    shiny::tagList(
      shiny::tags$link(
        rel = "icon",
        sizes = "48x48",
        href = img("favicon.ico")
      ),
      shiny::tags$link(
        rel = "icon",
        sizes = "any",
        href = img("favicon.svg"),
        type = "image/svg+xml"
      ),
      shiny::tags$link(
        rel = "mask-icon",
        href = img("govuk-icon-mask.svg"),
        color = theme_color
      ),
      shiny::tags$link(
        rel = "apple-touch-icon",
        href = img("govuk-icon-180.png")
      )
    )
  } else {
    shiny::tagList(
      shiny::tags$link(
        rel = "icon",
        sizes = "48x48",
        href = img("favicon-default.ico")
      ),
      shiny::tags$link(
        rel = "icon",
        sizes = "any",
        href = img("favicon-default.svg"),
        type = "image/svg+xml"
      ),
      shiny::tags$link(
        rel = "apple-touch-icon",
        href = img("favicon-default-180.png")
      )
    )
  }

  shiny::tags$head(
    icons,
    shiny::tags$meta(name = "theme-color", content = theme_color)
  )
}
