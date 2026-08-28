# Internal helper: TRUE for values htmltools already treats as markup, i.e.
# shiny.tag, shiny.tag.list, and HTML() output. Anything else is plain content
# that has to be coerced or escaped before it reaches the browser.
is_govuk_markup <- function(x) {
  inherits(x, c("shiny.tag", "shiny.tag.list", "html"))
}

# Internal helper: passes through shiny.tag, shiny.tag.list, or HTML() output
# unchanged so callers can supply tags. Wraps plain character strings with
# shiny::HTML() to preserve the existing behaviour for string callers. NULL is
# returned unchanged so optional arguments (e.g. hints) render nothing.
as_govuk_html <- function(x) {
  if (is.null(x)) {
    NULL
  } else if (is_govuk_markup(x)) {
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
govuk_error_message <- function(input_id, error_message) {
  shinyjs::hidden(
    shiny::tags$p(
      class = "govuk-error-message",
      id = paste0(input_id, "error"),
      role = "alert",
      govuk_error_prefix(),
      " ",
      error_message
    )
  )
}

# Internal helper: the paragraph's inner HTML, serialised for shinyjs::html(),
# which assigns it as innerHTML. Escaping plain strings here keeps error_on()
# in step with govuk_error_message(): the same error_message renders the same
# way whether it is baked into the component or pushed from the server.
govuk_error_html <- function(error_message) {
  message_html <- if (is_govuk_markup(error_message)) {
    as.character(error_message)
  } else {
    htmltools::htmlEscape(as.character(error_message))
  }
  paste0(as.character(govuk_error_prefix()), " ", message_html)
}
