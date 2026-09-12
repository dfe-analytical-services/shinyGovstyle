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

#' Resolve the class and inline style for a `.govuk-width-container`
#'
#' Shared by every component that renders a `govuk-width-container` (header,
#' footer, banner, cookieBanner, service_navigation, gov_main_layout and
#' gov_layout) so the `width` argument behaves consistently everywhere.
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
  tiers <- c("standard", "three-quarters", "full")

  if (width %in% tiers) {
    if (width == "standard" && is_default) {
      return(list(class = "govuk-width-container", style = NULL))
    }
    return(list(
      class = paste0("govuk-width-container govuk-width-container--", width),
      style = NULL
    ))
  }

  if (!is_css_length(width)) {
    stop(
      "`width` must be \"standard\", \"three-quarters\", \"full\", or a ",
      "CSS length (e.g. \"1400px\", \"90vw\"), not \"", width, "\"",
      call. = FALSE
    )
  }

  list(
    class = "govuk-width-container govuk-width-container--custom",
    style = paste0("max-width: ", width, ";")
  )
}
