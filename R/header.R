#' Generic header with an optional centred service title
#'
#' A page-level header based on GOV.UK Frontend's Generic header. The linked
#' organisation identity uses the upstream structure. The separate service
#' title is a shinyGovstyle extension: centred on wide screens and stacked
#' below the organisation on smaller screens. Use one header per page.
#'
#' @param org_name Organisation name. Use `NULL` for an image-only identity,
#'   with meaningful `logo_alt_text`.
#' @param service_name Optional service title, outside the homepage link.
#' @param logo URL or app-relative path to your own logo. Defaults to `NULL`
#'   (text only). The `"crown"` shortcut is no longer supported; use your own
#'   logo or `NULL` instead.
#' @param main_text `r lifecycle::badge("deprecated")` Use `org_name` instead.
#'   Will be removed in shinyGovstyle 1.0.0.
#' @param secondary_text `r lifecycle::badge("deprecated")` Use `service_name`
#'   instead. Will be removed in shinyGovstyle 1.0.0.
#' @param main_link,secondary_link,main_alt_text,secondary_alt_text
#'   `r lifecycle::badge("deprecated")` Have no effect and will be removed
#'   in shinyGovstyle 1.0.0. Use `homepage_url` for the organisation link.
#' @param logo_alt_text Alternative text for a custom logo. Defaults to `""`,
#'   which marks the logo as decorative: the adjacent organisation name already
#'   names the homepage link, so repeating it would be read out twice. An
#'   image-only identity (`org_name = NULL`) requires meaningful alternative
#'   text, such as the organisation's name, to name the homepage link.
#' @param logo_width,logo_height Image dimensions, in pixels for numeric values
#'   or as CSS lengths. Applied to each image independently.
#' @param homepage_url Organisation homepage URL. Defaults to `/` (the domain
#'   root). For an app hosted at `https://example.org/my-app/`, use
#'   `homepage_url = "/my-app/"` to return to that app instead.
#' @param classes Additional CSS classes for the outer header.
#' @param attributes Named list of HTML attributes for the outer header,
#'   such as `list(id = "site-header")` or a named `data-brand` attribute.
#'   Use `classes` for CSS classes; the banner role cannot be overridden.
#' @param branding `"generic"` (the default) for your organisation's own name
#'   and logo, using GOV.UK Frontend's Generic header. `"govuk"` for the GOV.UK
#'   header, with the GOV.UK logo, which GOV.UK says to use only for services
#'   on the GOV.UK website. With `"govuk"`, `org_name` and `logo` don't apply
#'   (passing them gives a warning), `homepage_url` defaults to
#'   `"https://www.gov.uk/"`, and `service_name` is still shown as the centred
#'   service title. Use [footer()] with `branding = "govuk"` to match.
#' @inheritParams width_arg
#' @details
#' This replaces the previous branded-header markup for v1.0.0. Update CSS
#' selectors from `govuk-header*` to the Generic header classes or the
#' package-owned `shinygovstyle-header*` classes. The organisation now links
#' to `homepage_url`; `service_name` remains supported and is not a link.
#'
#' Generic header does not remove branding elsewhere in your app. Review fonts,
#' colours, favicons and footer imagery separately against the
# nolint start: line_length_linter.
#' [guidance on using Frontend without GOV.UK branding](https://frontend.design-system.service.gov.uk/using-govuk-frontend-without-govuk-branding/).
# nolint end: line_length_linter.
#' The header uses the same font as the rest of your page. Only call `font()`
#' if your app is on a GOV.UK domain.
#' @return A header HTML Shiny tag object.
#' @family Govstyle page structure
#' @export
#' @examples
#' header("Example organisation")
#' header("Example organisation", "My service", homepage_url = "/my-app/")
#' header(
#'   "Ministry of Justice", "My service",
#'   logo = "shinyGovstyle/images/moj_logo.png",
#'   homepage_url = "/my-app/"
#' )
#'
#' # The GOV.UK header, only for services on the GOV.UK website
#' header(service_name = "Check your state pension", branding = "govuk")
header <- function(
  org_name = "Shiny example app",
  service_name = NULL,
  logo = NULL,
  main_text = lifecycle::deprecated(),
  secondary_text = lifecycle::deprecated(),
  main_link = lifecycle::deprecated(),
  secondary_link = lifecycle::deprecated(),
  logo_alt_text = "",
  main_alt_text = lifecycle::deprecated(),
  secondary_alt_text = lifecycle::deprecated(),
  logo_width = 66,
  logo_height = 34,
  width = "standard",
  homepage_url = "/",
  classes = NULL,
  attributes = list(),
  branding = c("generic", "govuk")
) {
  branding <- match.arg(branding)
  govuk <- branding == "govuk"
  if (govuk && missing(homepage_url)) {
    homepage_url <- "https://www.gov.uk/"
  }
  wc <- gov_width_container(width, is_default = missing(width))
  if (lifecycle::is_present(main_text)) {
    lifecycle::deprecate_warn(
      when = "0.2.0",
      what = "header(main_text)",
      with = "header(org_name)",
      details = "`main_text` will be removed in shinyGovstyle 1.0.0."
    )
    org_name <- main_text
  }

  if (lifecycle::is_present(secondary_text)) {
    lifecycle::deprecate_warn(
      when = "0.2.0",
      what = "header(secondary_text)",
      with = "header(service_name)",
      details = "`secondary_text` will be removed in shinyGovstyle 1.0.0."
    )
    service_name <- secondary_text
  }

  if (lifecycle::is_present(main_link)) {
    lifecycle::deprecate_warn(
      when = "0.2.0",
      what = "header(main_link)",
      details = c(
        i = "It has no effect; remove it from your `header()` call.",
        i = "It will be removed in shinyGovstyle 1.0.0."
      )
    )
  }

  if (lifecycle::is_present(main_alt_text)) {
    lifecycle::deprecate_warn(
      when = "0.2.0",
      what = "header(main_alt_text)",
      details = c(
        i = "It has no effect; remove it from your `header()` call.",
        i = "It will be removed in shinyGovstyle 1.0.0."
      )
    )
  }

  if (lifecycle::is_present(secondary_alt_text)) {
    lifecycle::deprecate_warn(
      when = "0.2.0",
      what = "header(secondary_alt_text)",
      details = c(
        i = "It has no effect; remove it from your `header()` call.",
        i = "It will be removed in shinyGovstyle 1.0.0."
      )
    )
  }

  if (lifecycle::is_present(secondary_link)) {
    lifecycle::deprecate_warn(
      when = "0.2.0",
      what = "header(secondary_link)",
      details = c(
        i = "It has no effect; remove it from your `header()` call.",
        i = "It will be removed in shinyGovstyle 1.0.0."
      )
    )
  }

  if (identical(logo, "crown")) {
    stop(
      '`logo = "crown"` is not supported by Generic header. ',
      'For the GOV.UK logo use `branding = "govuk"` (only for services on ',
      "GOV.UK). Otherwise use `logo = NULL` for text only or supply your own ",
      "logo path and `logo_alt_text`.",
      call. = FALSE
    )
  }
  if (govuk && (!missing(org_name) || !is.null(logo))) {
    warning(
      "The GOV.UK header shows the GOV.UK logo, so `org_name` and `logo` ",
      "are ignored when `branding = \"govuk\"`.",
      call. = FALSE
    )
  }
  if (
    !is.character(homepage_url) ||
      length(homepage_url) != 1L ||
      is.na(homepage_url) ||
      !nzchar(trimws(homepage_url))
  ) {
    stop("`homepage_url` must be a non-empty URL string.", call. = FALSE)
  }
  if (
    !is.null(classes) &&
      (!is.character(classes) || length(classes) != 1L || is.na(classes))
  ) {
    stop("`classes` must be a single string or NULL.", call. = FALSE)
  }
  attribute_names <- names(attributes)
  invalid_names <- length(attributes) > 0L && is.null(attribute_names)
  invalid_names <- invalid_names ||
    anyNA(attribute_names) ||
    any(!nzchar(attribute_names)) ||
    anyDuplicated(attribute_names)
  if (!is.list(attributes) || invalid_names) {
    stop("`attributes` must be a uniquely named list.", call. = FALSE)
  }
  if (any(tolower(names(attributes)) %in% c("class", "role"))) {
    stop(
      "Use `classes` for CSS classes; the header's banner role is fixed.",
      call. = FALSE
    )
  }
  has_name <- !is.null(org_name) &&
    any(nzchar(trimws(as.character(org_name))))
  has_alt <- !is.null(logo_alt_text) &&
    any(nzchar(trimws(logo_alt_text)))
  if (!govuk && !has_name && (is.null(logo) || !has_alt)) {
    stop(
      "Provide `org_name` or a logo with meaningful `logo_alt_text` ",
      "to name the homepage link.",
      call. = FALSE
    )
  }

  # GOV.UK Frontend builds its GOV.UK header from the Generic header, swapping
  # the govuk-generic-header classes for govuk-header ones and the logo for
  # the GOV.UK logotype, so both brandings share this structure
  namespace <- if (govuk) "govuk-header" else "govuk-generic-header"

  identity <- shiny::tags$a(
    href = homepage_url,
    class = paste0(namespace, "__homepage-link shinygovstyle-header__link"),
    if (govuk) {
      govuk_logo_svg("govuk-header__logotype", aria_label = "GOV.UK")
    },
    if (!govuk && !is.null(logo)) {
      shiny::tags$img(
        src = logo,
        class = "shinygovstyle-header__image",
        alt = if (is.null(logo_alt_text)) "" else logo_alt_text,
        style = htmltools::css(
          width = shiny::validateCssUnit(logo_width),
          height = shiny::validateCssUnit(logo_height)
        )
      )
    },
    if (!govuk && !is.null(logo) && has_name) " ",
    if (!govuk && has_name) {
      shiny::tags$span(org_name, class = "shinygovstyle-header__organisation")
    }
  )
  container <- shiny::tags$div(
    class = paste(
      c(
        paste0(namespace, "__container shinygovstyle-header__container"),
        if (!is.null(service_name)) {
          "shinygovstyle-header__container--with-service"
        },
        wc$class
      ),
      collapse = " "
    ),
    style = wc$style,
    shiny::tags$div(class = paste0(namespace, "__logo"), identity),
    if (!is.null(service_name)) {
      shiny::tags$div(
        class = "shinygovstyle-header__service-name",
        service_name
      )
    }
  )
  gov_header <- do.call(
    shiny::tags$header,
    c(
      list(
        class = paste(
          c(namespace, "shinygovstyle-header", classes),
          collapse = " "
        ),
        role = "banner",
        container
      ),
      attributes
    )
  )

  header_css <- htmltools::htmlDependency(
    name = "header",
    version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "header-overrides.css"
  )

  htmltools::attachDependencies(
    attachDependency(gov_header), # nolint
    header_css,
    append = TRUE
  )
}

# GOV.UK's logo, copied from GOV.UK Frontend 6.6.0's govukLogo macro
# (macros/logo.njk) so it matches upstream exactly: the Tudor crown's circles
# and path, then the "GOV.UK" wordmark path.
govuk_crown_circles <- list(
  c("20", "17.6"),
  c("10.2", "23.5"),
  c("3.7", "33.2"),
  c("31.7", "30.6"),
  c("43.3", "17.6"),
  c("53.2", "23.5"),
  c("59.7", "33.2"),
  c("31.7", "30.6")
)

govuk_crown_path <- paste0(
  "M33.1,9.8c.2-.1.3-.3.5-.5l4.6,2.4v-6.8l-4.6,1.5c-.1-.2-.3-.3-.5-.5l1.9",
  "-5.9h-6.7l1.9,5.9c-.2.1-.3.3-.5.5l-4.6-1.5v6.8l4.6-2.4c.1.2.3.3.5.5l-2",
  ".6,8c-.9,2.8,1.2,5.7,4.1,5.7h0c3,0,5.1-2.9,4.1-5.7l-2.6-8ZM37,37.9s-3",
  ".4,3.8-4.1,6.1c2.2,0,4.2-.5,6.4-2.8l-.7,8.5c-2-2.8-4.4-4.1-5.7-3.8.1,",
  "3.1.5,6.7,5.8,7.2,3.7.3,6.7-1.5,7-3.8.4-2.6-2-4.3-3.7-1.6-1.4-4.5,2.4-",
  "6.1,4.9-3.2-1.9-4.5-1.8-7.7,2.4-10.9,3,4,2.6,7.3-1.2,11.1,2.4-1.3,6.2,",
  "0,4,4.6-1.2-2.8-3.7-2.2-4.2.2-.3,1.7.7,3.7,3,4.2,1.9.3,4.7-.9,7-5.9-1",
  ".3,0-2.4.7-3.9,1.7l2.4-8c.6,2.3,1.4,3.7,2.2,4.5.6-1.6.5-2.8,0-5.3l5,1",
  ".8c-2.6,3.6-5.2,8.7-7.3,17.5-7.4-1.1-15.7-1.7-24.5-1.7h0c-8.8,0-17.1",
  ".6-24.5,1.7-2.1-8.9-4.7-13.9-7.3-17.5l5-1.8c-.5,2.5-.6,3.7,0,5.3.8-.8",
  ",1.6-2.3,2.2-4.5l2.4,8c-1.5-1-2.6-1.7-3.9-1.7,2.3,5,5.2,6.2,7,5.9,2.3",
  "-.4,3.3-2.4,3-4.2-.5-2.4-3-3.1-4.2-.2-2.2-4.6,1.6-6,4-4.6-3.7-3.7-4.2",
  "-7.1-1.2-11.1,4.2,3.2,4.3,6.4,2.4,10.9,2.5-2.8,6.3-1.3,4.9,3.2-1.8-2.7",
  "-4.1-1-3.7,1.6.3,2.3,3.3,4.1,7,3.8,5.4-.5,5.7-4.2,5.8-7.2-1.3-.2-3.7,1",
  "-5.7,3.8l-.7-8.5c2.2,2.3,4.2,2.7,6.4,2.8-.7-2.3-4.1-6.1-4.1-6.1h10.6,",
  "0Z"
)

govuk_wordmark_path <- paste0(
  "M93.94 41.25c.4 1.81 1.2 3.21 2.21 4.62 1 1.4 2.21 2.41 3.61 3.21s3.21",
  " 1.2 5.22 1.2 3.61-.4 4.82-1c1.4-.6 2.41-1.4 3.21-2.41.8-1 1.4-2.01 1",
  ".61-3.01s.4-2.01.4-3.01v.14h-10.86v-7.02h20.07v24.08h-8.03v-5.56c-.6",
  ".8-1.38 1.61-2.19 2.41-.8.8-1.81 1.2-2.81 1.81-1 .4-2.21.8-3.41 1.2s-2",
  ".41.4-3.81.4a18.56 18.56 0 0 1-14.65-6.63c-1.6-2.01-3.01-4.41-3.81-7",
  ".02s-1.4-5.62-1.4-8.83.4-6.02 1.4-8.83a20.45 20.45 0 0 1 19.46-13.65c3",
  ".21 0 4.01.2 5.82.8 1.81.4 3.61 1.2 5.02 2.01 1.61.8 2.81 2.01 4.01 3",
  ".21s2.21 2.61 2.81 4.21l-7.63 4.41c-.4-1-1-1.81-1.61-2.61-.6-.8-1.4-1",
  ".4-2.21-2.01-.8-.6-1.81-1-2.81-1.4-1-.4-2.21-.4-3.61-.4-2.01 0-3.81.4",
  "-5.22 1.2-1.4.8-2.61 1.81-3.61 3.21s-1.61 2.81-2.21 4.62c-.4 1.81-.6 3",
  ".71-.6 5.42s.8 5.22.8 5.22Zm57.8-27.9c3.21 0 6.22.6 8.63 1.81 2.41 1.2",
  " 4.82 2.81 6.62 4.82S170.2 24.39 171 27s1.4 5.62 1.4 8.83-.4 6.02-1.4 ",
  "8.83-2.41 5.02-4.01 7.02-4.01 3.61-6.62 4.82-5.42 1.81-8.63 1.81-6.22",
  "-.6-8.63-1.81-4.82-2.81-6.42-4.82-3.21-4.41-4.01-7.02-1.4-5.62-1.4-8.83",
  ".4-6.02 1.4-8.83 2.41-5.02 4.01-7.02 4.01-3.61 6.42-4.82 5.42-1.81 8.63",
  "-1.81Zm0 36.73c1.81 0 3.61-.4 5.02-1s2.61-1.81 3.61-3.01 1.81-2.81 2.21",
  "-4.41c.4-1.81.8-3.61.8-5.62 0-2.21-.2-4.21-.8-6.02s-1.2-3.21-2.21-4.62",
  "c-1-1.2-2.21-2.21-3.61-3.01s-3.21-1-5.02-1-3.61.4-5.02 1c-1.4.8-2.61 1",
  ".81-3.61 3.01s-1.81 2.81-2.21 4.62c-.4 1.81-.8 3.61-.8 5.62 0 2.41.2 4",
  ".21.8 6.02.4 1.81 1.2 3.21 2.21 4.41s2.21 2.21 3.61 3.01c1.4.8 3.21 1 ",
  "5.02 1Zm36.32 7.96-12.24-44.15h9.83l8.43 32.77h.4l8.23-32.77h9.83L200.3",
  " 58.04h-12.24Zm74.14-7.96c2.18 0 3.51-.6 3.51-.6 1.2-.6 2.01-1 2.81-1",
  ".81s1.4-1.81 1.81-2.81a13 13 0 0 0 .8-4.01V13.9h8.63v28.15c0 2.41-.4 4",
  ".62-1.4 6.62-.8 2.01-2.21 3.61-3.61 5.02s-3.41 2.41-5.62 3.21-4.62 1.2",
  "-7.02 1.2-5.02-.4-7.02-1.2c-2.21-.8-4.01-1.81-5.62-3.21s-2.81-3.01-3",
  ".61-5.02-1.4-4.21-1.4-6.62V13.9h8.63v26.95c0 1.61.2 3.01.8 4.01.4 1.2 ",
  "1.2 2.21 2.01 2.81.8.8 1.81 1.4 2.81 1.81 0 0 1.34.6 3.51.6Zm34.22-36",
  ".18v18.92l15.65-18.92h10.82l-15.03 17.32 16.03 26.83h-10.21l-11.44-20",
  ".21-5.62 6.22v13.99h-8.83V13.9"
)

# Internal helper: GOV.UK's logo as an inline SVG. The Tudor crown alone is
# used in the footer; with the "GOV.UK" wordmark and teal dot it is the
# header logotype. With an `aria_label` the SVG is a named image; without one
# it is decorative. focusable = "false" stops older browsers treating it as
# an interactive element.
govuk_logo_svg <- function(class, aria_label = NULL, logotype = TRUE) {
  width <- if (logotype) 162 else 32

  crown <- shiny::tag(
    "g",
    list(
      lapply(govuk_crown_circles, function(xy) {
        shiny::tag("circle", list(cx = xy[[1]], cy = xy[[2]], r = "3.7"))
      }),
      shiny::tag("path", list(d = govuk_crown_path))
    )
  )

  wordmark <- if (logotype) {
    list(
      shiny::tag(
        "circle",
        list(class = "govuk-logo-dot", cx = "226", cy = "36", r = "7.3")
      ),
      shiny::tag("path", list(d = govuk_wordmark_path))
    )
  }

  shiny::tag(
    "svg",
    list(
      focusable = "false",
      role = if (is.null(aria_label)) "presentation" else "img",
      xmlns = "http://www.w3.org/2000/svg",
      viewBox = paste("0 0", width * 2, "60"),
      height = "30",
      width = as.character(width),
      fill = "currentcolor",
      class = class,
      `aria-label` = aria_label,
      if (!is.null(aria_label)) shiny::tag("title", list(aria_label)),
      crown,
      wordmark
    )
  )
}
