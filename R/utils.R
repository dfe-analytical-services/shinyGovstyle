#' Build a govuk-fieldset block (internal)
#'
#' Returns a `<fieldset class="govuk-fieldset">` with a legend, optional hint,
#' optional hidden error message, and arbitrary `content` nested inside.
#' Hint and error elements receive ids of the form `<inputId>-hint` and
#' `<inputId>-error` and are referenced from the fieldset's `aria-describedby`
#' so screen readers announce them when the group receives focus.
#'
#' @param inputId Base id used to derive hint / error element ids.
#' @param label Legend text (the question or group label).
#' @param content Tag(s) to nest inside the fieldset after the legend / hint /
#'   error block.
#' @param hint_label Optional hint text. `NULL` (default) omits the hint div.
#' @param error If `TRUE`, render a hidden error message element with the
#'   supplied `error_message`.
#' @param error_message Text for the error message.
#' @param label_size Legend size modifier, one of `"m"`, `"s"`, `"l"`, `"xl"`.
#' @param heading_level Optional 1-6 integer; wraps the legend text in an
#'   `<hN class="govuk-fieldset__heading">` per the GDS pattern for using a
#'   question as the page heading.
#'
#' @return A `shiny.tag` for the fieldset.
#' @keywords internal
#' @noRd
govFieldset <- # nolint
  function(
    inputId, # nolint
    label,
    content,
    hint_label = NULL,
    error = FALSE,
    error_message = NULL,
    label_size = c("m", "s", "l", "xl"),
    heading_level = NULL
  ) {
    label_size <- match.arg(label_size)
    if (!is.null(heading_level)) {
      if (length(heading_level) != 1) {
        stop(
          "`heading_level` must be a single value, not length ",
          length(heading_level),
          "."
        )
      }
      if (!(heading_level %in% 1:6)) {
        stop("`heading_level` must be an integer between 1 and 6.")
      }
    }

    hint_id <- if (!is.null(hint_label)) paste0(inputId, "-hint")
    error_id <- if (isTRUE(error)) paste0(inputId, "-error")
    described_by <- paste(c(hint_id, error_id), collapse = " ")
    if (!nzchar(described_by)) {
      described_by <- NULL
    }

    legend_class <- paste0(
      "govuk-fieldset__legend govuk-fieldset__legend--",
      label_size
    )
    legend_content <- if (!is.null(heading_level)) {
      shiny::tag(
        paste0("h", heading_level),
        list(class = "govuk-fieldset__heading", label)
      )
    } else {
      label
    }

    hint_tag <- if (!is.null(hint_label)) {
      shiny::tags$div(hint_label, id = hint_id, class = "govuk-hint")
    }

    error_tag <- if (isTRUE(error)) {
      govuk_error_message(inputId, error_message)
    }

    shiny::tags$fieldset(
      class = "govuk-fieldset",
      `aria-describedby` = described_by,
      shiny::tags$legend(legend_content, class = legend_class),
      hint_tag,
      error_tag,
      content
    )
  }

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
# The id matches the "-error" suffix used elsewhere for aria-describedby.
govuk_error_message <- function(input_id, error_message) {
  shinyjs::hidden(
    shiny::tags$p(
      class = "govuk-error-message",
      id = paste0(input_id, "-error"),
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
