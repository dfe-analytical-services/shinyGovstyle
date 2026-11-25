# Internal helpers: the canonical `-hint`/`-error` id suffixes, shared by
# govFieldset(), govuk_error_message(), error_on(), and error_off() so the
# convention only exists in one place.
govuk_hint_id <- function(inputId) paste0(inputId, "-hint") # nolint
govuk_error_id <- function(inputId) paste0(inputId, "-error") # nolint

# Checks a heading level from 1 to 6, shared by heading_text(), govFieldset()
# and gov_summary_card(). govReactable() and govReactableOutput() use the
# narrower govreactable_heading_level() instead. `arg_name` is the name shown
# in the error message, for callers whose argument isn't `heading_level`.
validate_heading_level <- function(level, arg_name = "heading_level") {
  if (length(level) != 1) {
    stop(
      "`",
      arg_name,
      "` must be a single value, not length ",
      length(level),
      ".",
      call. = FALSE
    )
  }
  if (!is.numeric(level) || level %% 1 != 0 || !(level %in% 1:6)) {
    stop(
      "`",
      arg_name,
      "` must be an integer between 1 and 6.",
      call. = FALSE
    )
  }
}

# Builds an `<hN>` heading tag, shared by the functions that make headings.
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

# Checks a GOV.UK text size ("m", "s", "l" or "xl") for headings, legends and
# captions, so the accepted values and error wording live in one place.
# `arg_name` is the argument name shown in the error message.
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

# Checks that display content (a table caption, subtitle and so on) is markup
# (tags or HTML()) or one non-empty, non-NA string. Empty text would give an
# empty heading and an empty accessible name.
validate_single_content <- function(x, arg_name, allow_null = TRUE) {
  if (is.null(x) && allow_null) {
    return(invisible(x))
  }
  valid_text <- is.character(x) && length(x) == 1 && !is.na(x) && nzchar(x)
  if (!is_govuk_markup(x) && !valid_text) {
    stop(
      "`",
      arg_name,
      "` must be a single, non-empty string, `shiny::HTML()`, or tags.",
      call. = FALSE
    )
  }
  invisible(x)
}

# The class for a table subtitle. It reuses GOV.UK's secondary caption styles,
# so the subtitle always looks lower in importance than the headline. Only an
# "xl" headline needs the larger caption.
subtitle_class <- function(caption_size) {
  if (identical(caption_size, "xl")) "govuk-caption-l" else "govuk-caption-m"
}

# A table needs a title, and a subtitle alone would show as secondary text with
# no heading. Point users at `caption`.
validate_subtitle_has_caption <- function(caption, subtitle) {
  if (!is.null(subtitle) && is.null(caption)) {
    stop(
      "`subtitle` needs a `caption`. `caption` is the table's title; if you ",
      "don't have a headline, put the what, where and when in `caption` ",
      "instead. `subtitle` adds a line under the title.",
      call. = FALSE
    )
  }
  invisible(subtitle)
}

# Internal helper: checks a `colour` argument against the colours the calling
# component (gov_tag(), value_box()) supports, so the wording lives in one
# place. A non-string is an error. A colour govuk-frontend has removed, or one
# it never had, is a warning rather than an error: an unmatched
# govuk-tag--<colour> class only falls back to the default styling, and
# deprecated wrappers such as tag_Input() must keep working in 0.3.0.
validate_colour <- function(colour, supported) {
  if (!is.character(colour) || length(colour) != 1 || is.na(colour)) {
    stop("`colour` must be a single character string.", call. = FALSE)
  }
  if (colour %in% supported) {
    return(invisible(colour))
  }

  problem <- if (colour %in% c("light-blue", "turquoise", "pink")) {
    "is no longer a supported colour"
  } else {
    "is not a supported colour"
  }
  warning(
    "'",
    colour,
    "' ",
    problem,
    ". ",
    "Please select an alternative from: ",
    paste0("'", utils::head(supported, -1), "'", collapse = ", "),
    ", or '",
    utils::tail(supported, 1),
    "'."
  )
  invisible(colour)
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

# Turns content the server pushes into an existing element into HTML, for
# error_on() and update_reactable_caption(). Both set innerHTML in the browser,
# so plain strings are escaped. Otherwise user input such as
# `<img src=x onerror=...>` would run as code. Only tags and HTML() are left
# as they are, matching how htmltools escapes plain strings when building tags.
govuk_markup_html <- function(x) {
  if (is_govuk_markup(x)) {
    as.character(x)
  } else {
    htmltools::htmlEscape(as.character(x))
  }
}

# The error paragraph's inner HTML, for shinyjs::html(). Plain strings are
# escaped, so an error message looks the same whether it is built into the
# component or pushed from the server.
govuk_error_html <- function(error_message) {
  paste0(
    as.character(govuk_error_prefix()),
    " ",
    govuk_markup_html(error_message)
  )
}

#' Wrap a table in a horizontal scroll container
#'
#' Used by govTable() and govTabs() so a wide table scrolls inside its own
#' container, not the whole page. GOV.UK Frontend has no scroll wrapper for
#' tables, so this extends it, using the technique the WCAG 1.4.10 Reflow
#' guidance recommends for tables that are still too wide.
#'
#' The container is not a tab stop or a landmark by default. `table_scroll.js`
#' adds `tabindex="0"`, `role="region"` and `aria-labelledby` (copied from
#' `data-labelledby`) only while the table is wider than the container, so
#' keyboard users can scroll it, without adding a tab stop and landmark to
#' every table that fits.
#'
#' @param table The `<table>` tag to wrap.
#' @param labelledby Id of the element (caption or heading) that names the
#'   table, used as the region's name while it scrolls.
#'
#' @noRd
table_scroll_container <- function(labelledby, table) {
  shiny::tags$div(
    class = "shinygovstyle-table-scroll",
    `data-labelledby` = labelledby,
    table
  )
}
