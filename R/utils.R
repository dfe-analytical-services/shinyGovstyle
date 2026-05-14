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
    if (!is.null(heading_level) &&
          !(length(heading_level) == 1 &&
              heading_level %in% 1:6)) {
      stop("`heading_level` must be NULL or a single integer between 1 and 6.")
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
