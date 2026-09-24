# Internal helpers: the canonical `-hint`/`-error` id suffixes, shared by
# govFieldset(), govuk_error_message(), error_on(), and error_off() so the
# convention only exists in one place.
govuk_hint_id <- function(inputId) paste0(inputId, "-hint") # nolint
govuk_error_id <- function(inputId) paste0(inputId, "-error") # nolint

# Internal helper: the 1-6 heading level convention shared by heading_text(),
# govFieldset() (and so checkbox_Input(), radio_button_Input(), and
# date_Input()), govReactable(), and govReactableOutput(). `arg_name` lets
# callers whose public argument isn't literally called `heading_level` (e.g.
# heading_text()'s `level`) keep an accurate error message.
validate_heading_level <- function(level, arg_name = "heading_level") {
  if (length(level) != 1) {
    stop(
      arg_name, " must be a single value, not length ",
      length(level),
      "."
    )
  }
  if (!is.numeric(level) || level %% 1 != 0 || !(level %in% 1:6)) {
    stop(arg_name, " must be an integer between 1 and 6.")
  }
}

# Internal helper: builds an `<hN>` heading tag shared by heading_text(),
# govFieldset(), govReactable(), and govReactableOutput(), so the
# `shiny::tags[[paste0("h", level)]]` pattern only exists in one place.
build_heading_tag <- function(level, content, class, id = NULL) {
  do.call(
    shiny::tags[[paste0("h", level)]],
    list(content, class = class, id = id)
  )
}

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
    # If label_size wasn't set, default to "m"
    default_label_sizes <- c("m", "s", "l", "xl")
    if (identical(label_size, default_label_sizes)) {
      label_size <- default_label_sizes[1]
    }
    validate_gds_text_size(label_size, "label_size")
    if (!is.null(heading_level)) {
      validate_heading_level(heading_level)
    }

    hint_id <- if (!is.null(hint_label)) govuk_hint_id(inputId)
    error_id <- if (isTRUE(error)) govuk_error_id(inputId)
    described_by <- paste(c(hint_id, error_id), collapse = " ")
    if (!nzchar(described_by)) {
      described_by <- NULL
    }

    legend_class <- paste0(
      "govuk-fieldset__legend govuk-fieldset__legend--",
      label_size
    )
    legend_content <- if (!is.null(heading_level)) {
      build_heading_tag(
        heading_level,
        as_govuk_html(label),
        "govuk-fieldset__heading"
      )
    } else {
      as_govuk_html(label)
    }

    hint_tag <- if (!is.null(hint_label)) {
      shiny::tags$div(
        as_govuk_html(hint_label),
        id = hint_id,
        class = "govuk-hint"
      )
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

# Internal helper: the GOV.UK Design System heading/legend/caption text-size
# scale ("m", "s", "l", "xl"), shared by heading_text(), govTable(),
# govReactable(), govReactableOutput(), and govFieldset() (and, through it,
# checkbox_Input(), radio_button_Input(), date_Input()) so the accepted
# values and error wording only exist in one place. `arg_name` is used in the error message so callers see the actual
# parameter name (e.g. "size" vs "caption_size" vs "label_size").
validate_gds_text_size <- function(size, arg_name = "size") {
  valid_sizes <- c("xl", "l", "m", "s")
  if (!is.character(size) || length(size) != 1 || !(size %in% valid_sizes)) {
    stop(
      "`",
      arg_name,
      "` must be one of ",
      paste(paste0('"', valid_sizes, '"'), collapse = ", "),
      ", not ",
      if (is.character(size) && length(size) == 1) {
        paste0('"', size, '"')
      } else {
        paste0("a value of class ", class(size)[1])
      },
      ".",
      call. = FALSE
    )
  }
  invisible(size)
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
govuk_error_message <- function(input_id, error_message) {
  shinyjs::hidden(
    shiny::tags$p(
      class = "govuk-error-message",
      id = govuk_error_id(input_id),
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
