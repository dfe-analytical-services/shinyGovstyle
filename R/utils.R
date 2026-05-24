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

#' Shared id argument (internal)
#'
#' Documentation-only function. Holds the canonical `@param` entry for
#' `inputId`, inherited by consumers via `@inheritParams`.
#'
#' @param inputId The id assigned to the component's root element. For Shiny
#'   input components this is also the name used to access the value via
#'   `input$<inputId>`.
#'
#' @keywords internal
id_arg <- function(inputId) NULL # nolint

#' Shared input-state arguments (internal)
#'
#' Documentation-only function. Holds the canonical `@param` entries for the
#' trio of params that describe an input's visible state (`hint_label`,
#' `error`, `error_message`), inherited by functions via `@inheritParams`.
#' Functions without a `hint_label` in their signature inherit only the
#' applicable subset.
#'
#' @param hint_label Optional hint text shown beneath the label to guide the
#'   user. `NULL` (default) omits the hint.
#' @param error If `TRUE`, render the component in its error state and
#'   reserve a slot for the error message. Defaults to `FALSE`.
#' @param error_message Text shown when `error` is `TRUE`. Defaults to `NULL`.
#'
#' @keywords internal
hint_error_args <- function(hint_label, error, error_message) NULL

#' Shared download arguments (internal)
#'
#' Documentation-only function. Holds the canonical `@param` entries for
#' `outputId`, `file_type` and `file_size`, inherited by the download-button
#' family via `@inheritParams`.
#'
#' @param outputId The name of the output slot that the
#'   `shiny::downloadHandler()` is assigned to.
#' @param file_type File extension shown to the user (e.g. `"CSV"`, `"PDF"`).
#'   Defaults to `"CSV"`.
#' @param file_size Optional human-readable file size; a string ending in
#'   `KB`, `MB`, `GB`, or `rows`.
#'
#' @keywords internal
download_args <- function(outputId, file_type, file_size) NULL # nolint

#' Shared link arguments (internal)
#'
#' Documentation-only function. Holds the canonical `@param` entries for
#' `link` and `link_name`, inherited by the internal link helpers used by
#' `footer()` and `service_navigation()`.
#'
#' @param link Character string containing either link text or url.
#' @param link_name Name of a link where a URL has been provided in `link`.
#'
#' @keywords internal
link_args <- function(link, link_name) NULL
