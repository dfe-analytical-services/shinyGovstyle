#' Word Count Function
#'
#' @description
#' `r lifecycle::badge('deprecated)`
#' This helper function was deprecated as text_area_Input no longer relies on this, and uses js instead.
#' The text_area_Input function can still be used as before
#' @keywords internal
#'
#' This function create tracks the word count and should be used with the
#' text area function.
#' @param inputId The input slot of the text area that you want to affect
#' @param input The text input that is associated with the box
#' @param word_limit Change the word limit if needed. Default will keep as
#' what was used in text area component
#' @return no value returned. Updates the word count in a shiny app
#' @family Govstyle text types
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     "Justice", "", logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   gov_layout(
#'     size = "full",
#'     text_area_Input(
#'       inputId = "text_area",
#'       label = "Can you provide more detail?",
#'       hint_label = paste(
#'         "Do not include personal or financial information,",
#'         "like your National Insurance number or credit card details."
#'       ),
#'       word_limit = 300
#'     )
#'   ),
#'   footer(TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   shiny::observeEvent(input$text_area,
#'     word_count(
#'       inputId = "text_area",
#'       input = input$text_area
#'     )
#'   )
#' }
#' if (interactive()) shinyApp(ui = ui, server = server)
word_count <- function(
  inputId, # nolint
  input,
  word_limit = NULL
) {
  lifecycle::deprecate_warn(
    '1.0.0',
    'word_count',
    details = 'This helper function is no longer required. Use text_area_Input() instead.'
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
