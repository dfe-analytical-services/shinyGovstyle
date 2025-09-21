#' Error Summary Update Function
#'
#' This function changes the text that displays in the error summary box.
#' Requires `shinyjs::useShinyjs()` to work.
#' @param inputId The input Id of the error summary you want to update
#' @param error_list An updated list of text values to be displayed in the
#' error body
#' @return an update error summary box
#' @keywords error_summary_update
#' @export
#' @examples
#' ui <- fluidPage(
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     error_summary(
#'       inputId = "errorId",
#'       error_title = "Error title",
#'       error_list = c("error item1", "error item2")
#'     )
#'   ),
#'   shinyGovstyle::button_Input("btn1", "Change error summary"),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   shiny::observeEvent(input$btn1, {
#'     error_summary_update(
#'       "errorId",
#'       c("error item1", "error item2", "error item3")
#'     )
#'   },
#'   ignoreInit = TRUE
#'   )
#' }
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
error_summary_update <- function(
  inputId, # nolint
  error_list
) {
  new_err_sum <-
    shiny::tags$ul(
      class = "govuk-list govuk-error-summary__list",
      Map(
        function(x) {
          shiny::tags$li(x)
        },
        x = error_list
      )
    )

  shinyjs::html(id = paste0(inputId, "list"), html = as.character(new_err_sum))
}
