#' Styling overrides for to give full width
#'
#' `r lifecycle::badge("experimental")`
#' This is an experimental function that will likely be removed in future
#' releases, as we work through updating the core package styling and
#' adding full width options into the components themselves. This is not
#' well tested and may cause unexpected styling issues when combined with
#' components from other packages, use at your own risk.
#'
#' @return HTML containing CSS styling overrides
#' @keywords styling
#' @export
#' @examples
#' shinyGovstyle::full_width_overrides()
full_width_overrides <- function() {
  shiny::tags$head(
    shiny::tags$style(
      shiny::HTML(
        # Overall overrides
        ".container-fluid { padding: 0; }",
        ".govuk-width-container { max-width: 100%; padding-left: 10px; }",
        ".govuk-grid-row { margin-left: 0; margin-right: 0; }",

        # Cookie banner overrides
        #".govuk-cookie-banner { padding-left: 10px; }",
        ".govuk-button-group { margin-right: 0px; }",

        # Footer overrides
        ".govuk-footer { padding: 2rem; }",
        "html { background-color: #f3f2f1; }",

        # Left content overrides
        ".govuk-contents-box { margin-left: 0; margin-right: 0; }",
        ".govuk-contents-box { padding: 10px; width: fit-content !important; }"
      )
    )
  )
}
