#' Panel output (deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `panel_output()` was renamed to [confirmation_panel()] in shinyGovstyle
#' 0.3.0, with `main_text` becoming `title` and `sub_text` becoming `content`.
#' The output is unchanged. `panel_output()` will be removed in shinyGovstyle
#' 1.0.0.
#'
#' @inheritParams id_arg
#' @param main_text Use `confirmation_panel(title)` instead.
#' @param sub_text Use `confirmation_panel(content)` instead.
#' @return a panel HTML shiny tag object
#' @keywords internal
#' @export
#' @examples
#' # Before
#' # panel_output("panel1", main_text = "Application complete",
#' #   sub_text = "Your reference is xvsiq")
#'
#' # After
#' confirmation_panel(
#'   "panel1",
#'   title = "Application complete",
#'   content = "Your reference is xvsiq"
#' )
panel_output <- function(
  inputId, # nolint
  main_text,
  sub_text
) {
  lifecycle::deprecate_warn(
    when = "0.3.0",
    what = "panel_output()",
    with = "confirmation_panel()",
    details = c(
      i = paste(
        "Rename `main_text` to `title` and `sub_text` to `content`;",
        "positional calls work unchanged."
      ),
      i = "`panel_output()` will be removed in shinyGovstyle 1.0.0."
    )
  )

  confirmation_panel(inputId = inputId, title = main_text, content = sub_text)
}
