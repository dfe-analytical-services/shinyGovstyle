# Internal helper: passes through shiny.tag, shiny.tag.list, or HTML() output
# unchanged so callers can supply tags. Wraps plain character strings with
# shiny::HTML() to preserve the existing behaviour for string callers. NULL is
# returned unchanged so optional arguments (e.g. hints) render nothing.
as_govuk_html <- function(x) {
  if (is.null(x)) {
    NULL
  } else if (inherits(x, c("shiny.tag", "shiny.tag.list", "html"))) {
    x
  } else {
    shiny::HTML(x)
  }
}

# Internal helper: the visually hidden "Error:" prefix that screen readers
# announce ahead of the message text. Shared with error_on(), which rewrites
# the message and would otherwise drop it.
govuk_error_prefix <- function() {
  shiny::tags$span("Error:", class = "govuk-visually-hidden")
}

# Internal helper: the standard GOV.UK error message paragraph, hidden until
# error_on() reveals it. The prefix comes before the message so screen readers
# announce "Error: <message>" (GOV.UK Design System, error message component).
# error_message is passed through unwrapped so plain strings keep escaping.
govuk_error_message <- function(inputId, error_message) {
  # nolint
  shinyjs::hidden(
    shiny::tags$p(
      class = "govuk-error-message",
      id = paste0(inputId, "error"),
      role = "alert",
      govuk_error_prefix(),
      " ",
      error_message
    )
  )
}
