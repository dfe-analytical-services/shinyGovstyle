# Internal helper: passes through shiny.tag, shiny.tag.list, or HTML() output
# unchanged so callers can supply tags. Wraps plain character strings with
# shiny::HTML() to preserve the existing behaviour for string callers.
as_govuk_html <- function(x) {
  if (inherits(x, c("shiny.tag", "shiny.tag.list", "html"))) {
    x
  } else {
    shiny::HTML(x)
  }
}
