#' Select Function
#'
#' This function inserts a select box
#' @inheritParams id_arg
#' @inheritParams control_label_params
#' @inheritParams error_args
#' @param select_text Add the text that will apply in the drop down as a list
#' @param select_value Add the value that will be used for each selection
#' @return a select input HTML shiny tag object
#' @family Govstyle select inputs
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   # Required for error handling function
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png",
#'     logo_alt_text = "Ministry of Justice logo"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     select_Input(
#'       inputId = "sorter",
#'       label = "Sort by",
#'       select_text = c(
#'         "Recently published",
#'         "Recently updated",
#'         "Most views",
#'         "Most comments"
#'       ),
#'       select_value = c("published", "updated", "view", "comments")
#'     ),
#'     # Select with a hint, and an error raised from the server
#'     select_Input(
#'       inputId = "location",
#'       label = "Where do you live?",
#'       select_text = c("Choose location", "England", "Scotland", "Wales"),
#'       select_value = c("", "england", "scotland", "wales"),
#'       hint_label = "Choose the country you live in"
#'     ),
#'     shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   observeEvent(input$submit, {
#'     if (input$location != "") {
#'       shinyGovstyle::error_off(inputId = "location")
#'     } else {
#'       shinyGovstyle::error_on(
#'         inputId = "location",
#'         error_message = "Select where you live"
#'       )
#'     }
#'   })
#' }
#' if (interactive()) shinyApp(ui = ui, server = server)
select_Input <- # nolint
  function(
    inputId, # nolint
    label,
    select_text,
    select_value,
    hint_label = NULL,
    error = FALSE,
    error_message = NULL
  ) {
    gov_select <- shiny::tags$div(
      class = "govuk-form-group",
      id = paste0(inputId, "div"),
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
      if (isTRUE(error)) govuk_error_message(inputId, error_message),
      shiny::tags$select(
        id = inputId,
        class = "govuk-select",
        `aria-describedby` = govuk_described_by(inputId, hint_label),
        Map(
          function(x, y) {
            shiny::tags$option(value = y, x)
          },
          x = select_text,
          y = select_value
        )
      )
    )
    attachDependency(gov_select)
  }
