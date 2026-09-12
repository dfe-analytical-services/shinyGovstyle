#' Shared parameter documentation
#'
#' Internal documentation object holding the standard descriptions for the
#' label and hint arguments shared across the form-control components. Pull
#' these into a function with `@inheritParams control_label_params` so the
#' rich-content wording stays consistent in one place.
#'
#' @param label Display label for the control, or `NULL` for no label. Accepts
#'   a plain character string, an HTML string, or `shiny` tag objects such as
#'   `shiny::tags$b("Bold")` or a `shiny::tagList()`.
#' @param hint_label Display hint label for the control, or `NULL` for no hint
#'   label. Accepts the same rich content as `label`, so it can include a link.
#' @param hint_input Display hint label for the control, or `NULL` for no hint
#'   label. Accepts the same rich content as `label`, so it can include a link.
#' @keywords internal
#' @name control_label_params
NULL

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

#' Shared error-state arguments (internal)
#'
#' Documentation-only function. Holds the canonical `@param` entries for the
#' pair of params that describe an input's error state (`error`,
#' `error_message`), inherited by functions via `@inheritParams`. Used by
#' components whose `label`/`hint_label` docs are instead covered by
#' [control_label_params], to avoid documenting `hint_label` twice.
#'
#' @param error If `TRUE`, render the component in its error state and
#'   reserve a slot for the error message. Defaults to `FALSE`.
#' @param error_message Text shown when `error` is `TRUE`. Defaults to `NULL`.
#'
#' @keywords internal
error_args <- function(error, error_message) NULL

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
