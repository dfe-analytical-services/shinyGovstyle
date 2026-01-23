#' Page Layout Function
#'
#' This function loads the page layout, This doesn't work as well as
#' the `gov_main_layout` and associated functions. This is being kept for now
#' as a simpler version where grids are not needed.
#' @param inputID ID of the main div. Defaults to "main"
#' @param size Layout of the page. Optional are full, one-half, two-thirds,
#' one-third and one-quarter. Defaults to "full"
#' @param ... include the components of the UI that you want within the
#' main page.
#' @return a HTML shiny layout div
#' @keywords style
#' @family Govstyle page structure
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "full",
#'     shinyGovstyle::panel_output(
#'       inputId = "panel1",
#'       main_text = "Application Complete",
#'       sub_text = paste(
#'         "Thank you for submitting your application.",
#'         "Your reference is xvsiq"
#'       )
#'     ),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
gov_layout <- function(
  ...,
  inputID = "main", # nolint
  size = "full"
) {
  gov_layout <- shiny::tags$div(
    id = inputID,
    class = "govuk-width-container  govuk-main-wrapper",
    shiny::tags$div(
      id = paste0(inputID, "_sub"),
      class = paste0("govuk-grid-column-", size),
      ...
    )
  )
  attachDependency(gov_layout)
}
