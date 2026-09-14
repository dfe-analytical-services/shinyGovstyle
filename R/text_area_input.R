#' Text Area Input Function
#'
#' This function create a text area input.
#' @inheritParams id_arg
#' @inheritParams control_label_params
#' @inheritParams error_args
#' @param row_no Size of the text entry box. Defaults to 5
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
#'
#' # Rich content: a link in the hint
#' text_area_Input(
#'   "taId2",
#'   "Can you provide more detail?",
#'   shiny::tagList(
#'     "Read the ",
#'     shinyGovstyle::external_link("https://www.gov.uk", "guidance on detail")
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
    if (!is.null(word_limit)) {
      described_by <- c(described_by, paste0(inputId, "-info"))
    }
    if (!is.null(hint_label)) {
      described_by <- c(described_by, govuk_hint_id(inputId))
    }
    if (error == TRUE) {
      described_by <- c(described_by, govuk_error_id(inputId))
    }

    word_limit_text <- if (!is.null(word_limit)) {
      paste("You can enter up to", word_limit, "words")
    } else {
      NULL
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
        as_govuk_html(label),
        class = "govuk-label",
        `for` = inputId
      ),
      if (!is.null(word_limit)) {
        shiny::tags$div(
          class = paste0(
            "govuk-hint govuk-character-count__message ",
            "govuk-visually-hidden"
          ),
          shiny::tags$span(
            id = paste0(inputId, "-wl"),
            word_limit_text
          )
        )
      },
      if (!is.null(hint_label)) {
        shiny::tags$div(
          as_govuk_html(hint_label),
          class = "govuk-hint",
          id = govuk_hint_id(inputId)
        )
      },
      if (error == TRUE) govuk_error_message(inputId, error_message),
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
        shiny::tagList(
          shiny::tags$div(
            class = paste0(
              "govuk-hint govuk-character-count__message ",
              "govuk-visually-hidden"
            ),
            id = paste0(inputId, "-info"),
            word_limit_text
          ),
          shiny::tags$div(
            class = paste0(
              "govuk-hint govuk-character-count__message ",
              "govuk-character-count__status"
            ),
            id = paste0(inputId, "-status"),
            `aria-hidden` = "true",
            word_limit_text
          ),
          shiny::tags$div(
            class = "govuk-character-count__sr-status govuk-visually-hidden",
            id = paste0(inputId, "-sr-status"),
            `aria-live` = "polite",
            `aria-atomic` = "true",
            word_limit_text
          )
        )
      }
    )
    attachDependency(gov_textarea, "textarea")
  }
