#' Text Area Input Function
#'
#' This function create a text area input.
#' @param inputId The input slot that will be used to access the value
#' @param label Display label for the control, or `NULL` for no label
#' @param hint_label Display hint label for the control, or `NULL` for no
#' hint label
#' @param row_no Size of the text entry box. Defaults to 5
#' @param error Whenever to include error handling. Defaults to `FALSE`
#' @param error_message Message to display on error. Defaults to `NULL`
#' @param word_limit Add a word limit to the display. Defaults to `NULL`
#' @return a text area box HTML shiny tag object
#' @family Govstyle text types
#' @export
#' @examples
#' text_area_Input(
#'   "taId",
#'   "Can you provide more detail?",
#'   paste(
#'     "Do not include personal or financial information, like your",
#'     "National Insurance number or credit card details."
#'   )
#' )
text_area_Input <- # nolint
  function(
    inputId, # nolint
    label,
    hint_label = NULL,
    row_no = 5,
    error = FALSE,
    error_message = NULL,
    word_limit = NULL
  ) {
    described_by <- c()
    if (!is.null(hint_label)) {
      described_by <- c(described_by, paste0(inputId, "-hint"))
    }
    if (!is.null(word_limit)) {
      described_by <- c(described_by, paste0(inputId, "-info"))
    }

    gov_textarea <- shiny::tags$div(
      class = if (!is.null(word_limit)) {
        "govuk-form-group govuk-character-count"
      } else {
        "govuk-form-group"
      },
      id = paste0(inputId, "div"),
      `data-module` = if (!is.null(word_limit)) {
        "govuk-character-count"
      },
      `data-maxwords` = if (!is.null(word_limit)) word_limit,
      shiny::tags$label(
        shiny::HTML(label),
        class = "govuk-label",
        `for` = inputId
      ),
      if (!is.null(hint_label)) {
        shiny::tags$div(
          hint_label,
          class = "govuk-hint",
          id = paste0(inputId, "-hint")
        )
      },
      if (error == TRUE) {
        shinyjs::hidden(
          shiny::tags$p(
            error_message,
            class = "govuk-error-message",
            id = paste0(inputId, "error"),
            shiny::tags$span("Error:", class = "govuk-visually-hidden")
          )
        )
      },
      shiny::tags$textarea(
        id = inputId,
        class = if (!is.null(word_limit)) {
          "govuk-textarea govuk-js-character-count"
        } else {
          "govuk-textarea"
        },
        rows = row_no,
        `aria-describedby` = if (length(described_by) > 0) {
          paste(described_by, collapse = " ")
        }
      ),
      if (!is.null(word_limit)) {
        shiny::tags$div(
          class = "govuk-hint govuk-character-count__message",
          id = paste0(inputId, "-info"),
          paste("You can enter up to", word_limit, "words")
        )
      }
    )
    attachDependency(gov_textarea, "textarea")
  }
