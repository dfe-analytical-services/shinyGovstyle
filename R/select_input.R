#' Select Function
#'
#' This function inserts a select box
#' @param inputId Input id for the component
#' @param label Insert the text for the label.
#' @param select_text Add the text that will apply in the drop down as a list
#' @param select_value Add the value that will be used for each selection.
#' @return a select input html shiny object
#' @keywords select
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::gov_layout(size = "full",
#'       select_Input(
#'         inputId = "sorter",
#'         label = "Sort by",
#'         select_text = c("Recently published",
#'                         "Recently updated",
#'                         "Most views",
#'                         "Most comments"),
#'         select_value = c("published", "updated", "view", "comments")),
#'         tags$br()
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }
select_Input <- # nolint
  function(
    inputId, # nolint
    label,
    select_text,
    select_value
  ) {
    gov_select <- shiny::tags$div(
      class = "govuk-form-group",
      shiny::tags$label(
        shiny::HTML(label),
        class = "govuk-label",
        `for` = inputId
      ),
      shiny::tags$select(
        id = inputId,
        class = "govuk-select",
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
