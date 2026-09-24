#' Banner (deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `banner()` was renamed to [phase_banner()] in shinyGovstyle 0.3.0 to match
#' the name of the GOV.UK Design System component. The arguments and output
#' are unchanged. `banner()` will be removed in shinyGovstyle 1.0.0.
#'
#' @inheritParams phase_banner
#' @return a phase banner HTML shiny tag object
#' @keywords internal
#' @export
#' @examples
#' # Before
#' # banner("banner", "Beta", "This is a new service")
#'
#' # After
#' phase_banner("banner", "Beta", "This is a new service")
banner <- function(
  inputId, # nolint
  type,
  label = NULL,
  feedback_url = NULL,
  width = "standard"
) {
  lifecycle::deprecate_warn(
    when = "0.3.0",
    what = "banner()",
    with = "phase_banner()",
    details = "`banner()` will be removed in shinyGovstyle 1.0.0."
  )

  # gov_width_container() treats an unset `width` differently from an explicit
  # "standard", and missing() does not see through a forwarded argument that
  # has a default, so only pass `width` on when the caller supplied it.
  if (missing(width)) {
    phase_banner(
      inputId = inputId,
      type = type,
      label = label,
      feedback_url = feedback_url
    )
  } else {
    phase_banner(
      inputId = inputId,
      type = type,
      label = label,
      feedback_url = feedback_url,
      width = width
    )
  }
}
