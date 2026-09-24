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
#'     shinyGovstyle::gov_row(
#'       shinyGovstyle::gov_box(
#'         shinyGovstyle::heading_text("Welcome", size = "l", level = 1)
#'       )
#'     )
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
  theme = bslib::bs_theme()
) {
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
    shiny::tags$div(
      `data-govuk-page-width` = page_width,
      style = page_style,
      ...
    )
  )

  attachDependency(page)
}
