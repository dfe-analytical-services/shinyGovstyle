#' Is `x` a CSS length shinyGovstyle's width arguments will accept?
#'
#' Shared by `gov_width_container()` and `gov_page()` so both validate
#' custom width values the same way.
#'
#' @param x A single string.
#' @return `TRUE`/`FALSE`.
#' @noRd
is_css_length <- function(x) {
  grepl("^[0-9]+(\\.[0-9]+)?(px|rem|em|vw|%)$", x)
}

#' Validate `width` and classify it into a tier
#'
#' Shared by `gov_width_container()` and `gov_page()` so both validate and
#' report on an invalid `width` identically.
#'
#' @param width A width value as passed to `width_arg`/`gov_page()`'s `width`.
#' @return One of `"standard"`, `"three-quarters"`, `"full"`, or `"custom"`
#' (when `width` is a valid CSS length).
#' @noRd
validate_width_tier <- function(width) {
  tiers <- c("standard", "three-quarters", "full")

  is_scalar_string <- is.character(width) && length(width) == 1
  if (is_scalar_string && width %in% tiers) {
    return(width)
  }

  if (!is_scalar_string || !is_css_length(width)) {
    stop(
      "`width` must be \"standard\", \"three-quarters\", \"full\", or a ",
      "CSS length (e.g. \"1400px\", \"90vw\"), not ",
      if (is_scalar_string) paste0("\"", width, "\"") else "the given value",
      call. = FALSE
    )
  }

  "custom"
}

#' Resolve the class and inline style for a `.govuk-width-container`
#'
#' Shared by every component that renders a `govuk-width-container` (header,
#' footer, phase_banner, cookieBanner, service_navigation, gov_main_layout and
#' the deprecated gov_layout) so the `width` argument behaves consistently
#' everywhere.
#'
#' @param width One of `"standard"`, `"three-quarters"`, `"full"`, or a CSS
#' length (e.g. `"1400px"`, `"90vw"`).
#' @param is_default `TRUE` when the caller didn't explicitly pass `width`
#' (i.e. `missing(width)` in the calling component). A truly-unset
#' `"standard"` renders a bare class with no modifier, so `gov_page()`'s
#' ambient width CSS can style it; an *explicit* `width = "standard"`
#' renders the `--standard` modifier class, so it stays standard even
#' inside an ambient `"three-quarters"`/`"full"` `gov_page()`.
#' @return A list with `class` and `style` (`style` is `NULL` unless `width`
#' is a custom CSS length).
#' @noRd
gov_width_container <- function(width, is_default = FALSE) {
  tier <- validate_width_tier(width)

  if (tier == "custom") {
    return(list(
      class = "govuk-width-container govuk-width-container--custom",
      style = paste0("max-width: ", width, ";")
    ))
  }

  if (tier == "standard" && is_default) {
    return(list(class = "govuk-width-container", style = NULL))
  }

  list(
    class = paste0("govuk-width-container govuk-width-container--", tier),
    style = NULL
  )
}
