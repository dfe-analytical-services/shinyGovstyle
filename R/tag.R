#' Tag input (deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `tag_Input()` was renamed to [gov_tag()] in shinyGovstyle 0.3.0. The tag is
#' a display component rather than a Shiny input, so the `_Input` suffix was
#' misleading. The arguments and output are unchanged. `tag_Input()` will be
#' removed in shinyGovstyle 1.0.0.
#'
#' @inheritParams gov_tag
#' @return a tag HTML shiny tag object
#' @keywords internal
#' @export
#' @examples
#' # Before
#' # tag_Input("tag1", "Complete")
#'
#' # After
#' gov_tag("tag1", "Complete")
tag_Input <- # nolint
  function(
    inputId, # nolint
    text,
    colour = "navy"
  ) {
    lifecycle::deprecate_warn(
      when = "0.3.0",
      what = "tag_Input()",
      with = "gov_tag()",
      details = "`tag_Input()` will be removed in shinyGovstyle 1.0.0."
    )

    gov_tag(inputId = inputId, text = text, colour = colour)
  }
