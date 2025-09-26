#' Insert Text Function
#'
#' This function loads the insert text component to display additional
#' information in a special format.
#' @param inputId The input slot that will be used to access the value
#' @param text Text that you want to display on the insert
#' @return a insert text HTML shiny tag object
#' @keywords inserttext
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     shinyGovstyle::insert_text(
#'       inputId = "note",
#'       text = paste(
#'         "It can take up to 8 weeks to register a lasting power of",
#'         "attorney if there are no mistakes in the application."
#'       )
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
insert_text <- # nolint
  function(
    inputId, # nolint
    text
  ) {
    gov_insert <- shiny::tags$div(
      shiny::HTML(text),
      id = inputId,
      class = "govuk-inset-text"
    )
    attachDependency(gov_insert)
  }
