#' Heading Text Function
#'
#' This function createS heading text
#' @param text_input Text to display
#' @param size Text size, one of `"xl"`, `"l"`, `"m"`, `"s"`. Defaults to
#' `"xl"`. Any other value throws an error.
#' @param id Custom header id
#' @param level Heading level, integer between 1 and 6. Defaults to 1
#' @return a heading text HTML shiny tag object
#' @family Govstyle text types
#' @export
#' @examples
#' shinyGovstyle::heading_text("This is great text")
#' shinyGovstyle::heading_text("This is great text", size = "l", level = 2)
heading_text <- function(text_input, size = "xl", id, level = 1) {
  if (missing(id)) {
    id <- clean_heading_text(text_input)
  }

  validate_heading_level(level, arg_name = "level")

  validate_gds_text_size(size)

  gov_heading <- build_heading_tag(
    level,
    shiny::HTML(text_input),
    paste0("govuk-heading-", size),
    id
  )
  attachDependency(gov_heading)
}
