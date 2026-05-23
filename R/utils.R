#' Build a govuk-fieldset block (internal)
#'
#' Returns a `<fieldset class="govuk-fieldset">` with a legend, optional hint,
#' optional hidden error message, and arbitrary `content` nested inside.
#' Hint and error elements receive ids of the form `<inputId>-hint` and
#' `<inputId>-error` and are referenced from the fieldset's `aria-describedby`
#' so screen readers announce them when the group receives focus.
#'
#' @param inputId Base id used to derive hint/error element ids.
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
    if (!nzchar(described_by)) described_by <- NULL

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
      shinyjs::hidden(
        shiny::tags$p(
          error_message,
          class = "govuk-error-message",
          id = error_id,
          role = "alert",
          shiny::tags$span("Error:", class = "govuk-visually-hidden")
        )
      )
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

#' Shared fieldset arguments (internal)
#'
#' Documentation-only function. Holds the canonical `@param` entries for
#' `label_size` and `heading_level`, which are inherited by the input
#' functions that build on `govFieldset()` via `@inheritParams`.
#'
#' @param label_size Size modifier for the legend. One of `"m"`, `"s"`, `"l"`,
#'   or `"xl"`, matching the GDS `govuk-fieldset__legend--*` classes. Defaults
#'   to `"m"`.
#' @param heading_level Optional heading level for the legend. If supplied
#'   (an integer 1-6), the legend text is wrapped in a `<hN>` with the GDS
#'   `govuk-fieldset__heading` class, following the GDS pattern for using a
#'   question as the page heading. Defaults to `NULL` (no heading wrap).
#'
#' @keywords internal
fieldset_args <- function(label_size, heading_level) NULL
