#' Resolve the class and inline style for a `.govuk-width-container`
#'
#' Shared by every component that renders a `govuk-width-container` (header,
#' footer, banner, cookieBanner, service_navigation, gov_main_layout and
#' gov_layout) so the `width` argument behaves consistently everywhere.
#'
#' @param width One of `"standard"`, `"wide"`, `"full"`, or a CSS length
#' (e.g. `"1400px"`, `"90vw"`).
#' @return A list with `class` and `style` (`style` is `NULL` unless `width`
#' is a custom CSS length).
#' @noRd
gov_width_container <- function(width) {
  tiers <- c("standard", "wide", "full")

  if (width %in% tiers) {
    class <- if (width == "standard") {
      "govuk-width-container"
    } else {
      paste0("govuk-width-container govuk-width-container--", width)
    }
    return(list(class = class, style = NULL))
  }

  if (!grepl("^[0-9]+(\\.[0-9]+)?(px|rem|em|vw|%)$", width)) {
    stop(
      "`width` must be \"standard\", \"wide\", \"full\", or a CSS length ",
      "(e.g. \"1400px\", \"90vw\"), not \"", width, "\"",
      call. = FALSE
    )
  }

  list(
    class = "govuk-width-container govuk-width-container--wide",
    style = paste0("max-width: ", width, ";")
  )
}
