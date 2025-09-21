#' Text Area Input Function
#'
#' This function create a text area input
#' @param inputId The input slot that will be used to access the value.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param hint_label Display hint label for the control, or \code{NULL} for no
#' hint label.
#' @param row_no Size of the text entry box.  Defaults to 5.
#' @param error Whenever to icnlud error handling  Defaults to \code{FALSE}
#' @param error_message Message to display on error.  Defaults to \code{NULL}
#' @param word_limit Add a word limit to the display.  Defaults to \code{NULL}.
#' @return a text area box html shiny object
#' @keywords text area
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
    gov_textarea <- shiny::tags$div(
      class = "govuk-form-group govuk-character-count",
      id = paste0(inputId, "div"),
      shiny::tags$label(shiny::HTML(label), class = "govuk-label"),
      shiny::tags$div(hint_label, class = "govuk-hint"),
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
        class = "govuk-textarea",
        rows = row_no
      ),
      if (!is.null(word_limit)) {
        shiny::tags$div(
          class = "govuk-hint govuk-character-count__message",
          shiny::tags$span(
            "You have used"
          ),
          shiny::tags$span(
            id = paste0(inputId, "wc"),
            "0"
          ),
          shiny::tags$span(
            id = paste0(inputId, "wl"),
            paste("of the", word_limit, "allowed")
          )
        )
      }
    )
    attachDependency(gov_textarea)
  }
