#' Warning Text Function
#'
#' This function create warning text.
#' @param inputId The input slot that will be used to access the value
#' @param text Text that goes in the main
#' @return a warning box HTML shiny tag object
#' @keywords warning
#' @family Govstyle feedback types
#' @export
#' @examples
#' shinyGovstyle::warning_text(
#'   inputId = "warn1",
#'   text = "You can be fined up to £5,000 if you do not register."
#' )
warning_text <- function(
  inputId, # nolint
  text
) {
  gov_warning <- shiny::tags$div(
    class = "govuk-warning-text",
    id = inputId,
    shiny::tags$span(
      "!",
      class = "govuk-warning-text__icon",
      `aria-hidden` = "true"
    ),
    shiny::tags$strong(
      text,
      class = "govuk-warning-text__text",
      shiny::tags$span("Warning", class = "govuk-visually-hidden")
    )
  )
  attachDependency(gov_warning)
}
