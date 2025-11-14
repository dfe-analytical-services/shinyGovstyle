#' Heading Text Function
#'
#' This function createS heading text
#' @param text_input Text to display
#' @param size Text size using xl, l, m, s. Defaults to xl
#' @param id Custom header id
#' @param level Heading level, integer between 1 and 6. Defaults to 1
#' @return a heading text HTML shiny tag object
#' @keywords heading
#' @family Govstyle text types
#' @export
#' @examples
#' shinyGovstyle::heading_text("This is great text")
#' shinyGovstyle::heading_text("This is great text", size = "l", level = 2)
heading_text <- function(text_input, size = "xl", id, level = 1) {
  if (missing(id)) {
    id <- clean_heading_text(text_input)
  }

  if (!level %in% 1:6) {
    stop("level must be an integer between 1 and 6")
  }

  heading_tag <- paste0("h", level)
  gov_heading <- do.call(
    shiny::tags[[heading_tag]],
    list(
      shiny::HTML(text_input),
      class = paste0("govuk-heading-", size),
      id = id
    )
  )
  attachDependency(gov_heading)
}
