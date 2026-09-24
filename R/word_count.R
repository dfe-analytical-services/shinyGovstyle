#' Word Count Function
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `word_count()` was deprecated in shinyGovstyle 0.3.0 and will be removed in
#' shinyGovstyle 1.0.0. [text_area_Input()] now counts words in the browser and
#' announces the count to screen readers, so no server code is needed. Set the
#' limit with `text_area_Input(word_limit = )` and delete the `observeEvent()`
#' that called `word_count()`.
#' @keywords internal
#' @inheritParams id_arg
#' @param input The text input that is associated with the box
#' @param word_limit Change the word limit if needed. Default will keep as
#' what was used in text area component
#' @return no value returned. Updates the word count in a shiny app
#' @export
#' @examples
#' # The word count is handled by text_area_Input() alone; no server-side
#' # word_count() observer is needed.
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     "Justice", "", logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::text_area_Input(
#'       inputId = "text_area",
#'       label = "Can you provide more detail?",
#'       hint_label = paste(
#'         "Do not include personal or financial information,",
#'         "like your National Insurance number or credit card details."
#'       ),
#'       word_limit = 300
#'     )
#'   ),
#'   shinyGovstyle::footer(TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
word_count <- function(
  inputId, # nolint
  input,
  word_limit = NULL
) {
  lifecycle::deprecate_warn(
    when = "0.3.0",
    what = "word_count()",
    with = I("`text_area_Input(word_limit = )`"),
    details = c(
      i = paste(
        "`text_area_Input()` counts words in the browser, so delete the",
        "server-side `observeEvent()` that calls `word_count()`."
      ),
      i = "`word_count()` will be removed in shinyGovstyle 1.0.0."
    )
  )
  if (input == "") {
    word_no <- 0
  } else {
    word_no <- sapply(gregexpr("\\S+", input), length)
  }

  shinyjs::html(id = paste0(inputId, "wc"), html = word_no)

  if (!is.null(word_limit)) {
    shinyjs::html(
      id = paste0(inputId, "wl"),
      html = paste("of the", word_limit, "allowed")
    )
  }
}
