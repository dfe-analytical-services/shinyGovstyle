#' Text Area Input Function
#'
#' This function create a text area input.
#' @inheritParams id_arg
#' @inheritParams control_label_params
#' @inheritParams error_args
#' @param row_no Size of the text entry box. Defaults to 5
#' @param word_limit Maximum number of words. When set, a live count below the
#'   text area tells users how many words they have left, matching the GOV.UK
#'   character count component
#'   (<https://design-system.service.gov.uk/components/character-count/>).
#'   Defaults to `NULL`, no limit. See Details for how words are counted.
#' @return a text area box HTML shiny tag object
#' @details
#' With `word_limit`, the browser counts words the way GOV.UK Frontend does,
#' using the JavaScript `Intl.Segmenter` API and counting only word segments,
#' in the language set by the closest `lang` attribute. So `"well-known fact"`
#' is 3 words, `"A - B"` is 2, emoji are not counted, and languages written
#' without spaces, such as Chinese, are split into words. In browsers without
#' `Intl.Segmenter` the live count does not start and users see "You can enter
#' up to N words" instead.
#'
#' The count is only a guide for users: always check the limit on the server
#' too. To match the browser's count, use
#' `stringr::str_count(x, stringr::boundary("word"))`. As GOV.UK advises, front
#' end and back end counts may still differ for some text, so check how your
#' server counts words and allow for small differences.
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
#'
#' # Word limit with a live count. On the server, check the limit with
#' # stringr::str_count(input$taId3, stringr::boundary("word")) > 300
#' text_area_Input(
#'   "taId3",
#'   "Can you provide more detail?",
#'   word_limit = 300
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
    described_by <- govuk_described_by(
      inputId,
      hint_label,
      extra_ids = if (!is.null(word_limit)) paste0(inputId, "-info")
    )

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
      `data-maxlength` = if (!is.null(word_limit)) word_limit,
      `data-count-type` = if (!is.null(word_limit)) "words",
      shiny::tags$label(
        as_govuk_html(label),
        class = "govuk-label",
        `for` = inputId
      ),
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
        `aria-describedby` = described_by
      ),
      if (!is.null(word_limit)) {
        # As in GOV.UK Frontend, the static "-info" message is visible until
        # the JavaScript starts the live count, then hidden visually. The
        # live status starts hidden, so browsers without JavaScript or
        # Intl.Segmenter show only the static message.
        shiny::tagList(
          shiny::tags$div(
            class = "govuk-hint govuk-character-count__message",
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
            hidden = NA
          ),
          shiny::tags$div(
            class = "govuk-character-count__sr-status govuk-visually-hidden",
            id = paste0(inputId, "-sr-status"),
            `aria-live` = "polite",
            `aria-atomic` = "true"
          )
        )
      }
    )
    attachDependency(gov_textarea, "textarea")
  }
