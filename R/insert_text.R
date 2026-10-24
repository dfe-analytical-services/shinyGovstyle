#' Insert text (deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `insert_text()` was renamed to [inset_text()] in shinyGovstyle 0.3.0 to
#' match the name of the GOV.UK Design System component. It will be removed in
#' shinyGovstyle 1.0.0.
#'
#' @inheritParams inset_text
#' @param text `r lifecycle::badge("deprecated")` Use `inset_text(content)`
#' instead.
#' @return an inset text HTML shiny tag object
#' @keywords internal
#' @export
#' @examples
#' # Before
#' # insert_text(inputId = "note", content = "Some supporting text")
#'
#' # After
#' inset_text(inputId = "note", content = "Some supporting text")
insert_text <- # nolint
  function(
    inputId, # nolint
    content,
    text = lifecycle::deprecated()
  ) {
    if (lifecycle::is_present(text)) {
      # One warning covers both the rename and the argument change, so users
      # only have to act on a single message.
      lifecycle::deprecate_warn(
        when = "0.3.0",
        what = "insert_text(text)",
        with = "inset_text(content)",
        details = "`insert_text()` will be removed in shinyGovstyle 1.0.0."
      )
      if (!missing(content)) {
        stop(
          "Supply only one of `content` or the deprecated `text`, not both.",
          call. = FALSE
        )
      }
      content <- text
    } else {
      lifecycle::deprecate_warn(
        when = "0.3.0",
        what = "insert_text()",
        with = "inset_text()",
        details = "`insert_text()` will be removed in shinyGovstyle 1.0.0."
      )
    }

    inset_text(inputId = inputId, content = content)
  }
