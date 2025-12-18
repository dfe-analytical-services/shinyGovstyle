#' Banner Function
#'
#' This function create a detail component that you can click for further
#' details.
#' @param inputId The input slot that will be used to access the value
#' @param type Main type of label e.g. alpha or beta. Can be any word
#' @param label text to display
#' @return a banner HTML shiny tag object
#' @keywords banner
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::banner(
#'     inputId = "banner", type = "Beta", 'This is a new service'
#'   )
#' )
#'
#' server <- function(input, output, session) {}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
banner <- function(
  inputId, # nolint
  type,
  label
) {
  gov_banner <- shiny::tags$div(
    class = "govuk-phase-banner govuk-width-container govuk-main-wrapper",
    id = inputId,
    shiny::tags$p(
      class = "govuk-phase-banner__content",
      shiny::tags$strong(
        class = "govuk-tag govuk-phase-banner__content__tag ",
        type
      ),
      shiny::tags$span(class = "govuk-phase-banner__text", shiny::HTML(label))
    )
  )
  attachDependency(gov_banner)
}
