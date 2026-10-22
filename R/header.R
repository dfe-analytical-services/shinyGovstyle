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
  attributes = list()
) {
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
      "Use `logo = NULL` for text only or supply your own logo path ",
      "and `logo_alt_text`.",
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
  if (!has_name && (is.null(logo) || !has_alt)) {
    stop(
      "Provide `org_name` or a logo with meaningful `logo_alt_text` ",
      "to name the homepage link.",
      call. = FALSE
    )
  }

  identity <- shiny::tags$a(
    href = homepage_url,
    class = "govuk-generic-header__homepage-link shinygovstyle-header__link",
    if (!is.null(logo)) {
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
    if (!is.null(logo) && has_name) " ",
    if (has_name) {
      shiny::tags$span(org_name, class = "shinygovstyle-header__organisation")
    }
  )
  container <- shiny::tags$div(
    class = paste(
      c(
        "govuk-generic-header__container shinygovstyle-header__container",
        if (!is.null(service_name)) {
          "shinygovstyle-header__container--with-service"
        },
        wc$class
      ),
      collapse = " "
    ),
    style = wc$style,
    shiny::tags$div(class = "govuk-generic-header__logo", identity),
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
          c("govuk-generic-header shinygovstyle-header", classes),
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
