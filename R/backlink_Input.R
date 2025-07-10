#' Back Link Function
#'
#' This function adds a back link to the page
#' @param inputId The input slot that will be used to access the value.
#' @param label The link text for the backlink, default is "Back"
#' @return a backlink html shiny object
#' @keywords backlink
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shiny::navlistPanel(
#'       "",
#'       id="nav",
#'       widths = c(2, 10),
#'       well = FALSE,
#'
#'       #Create first panel
#'       shiny::tabPanel(
#'         "Select Types",
#'         value = "panel1",
#'         gov_layout(size = "two-thirds",
#'           backlink_Input("link1"),
#'           shiny::tags$br(), shiny::tags$br()
#'        )),
#'        shiny::tabPanel(
#'          "Tab2",
#'          value = "panel2")),
#'    shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {
#'     #Slightly confused in that it goes forward rather than back, but shows how
#'     #to use
#'     observeEvent(input$link1,{
#'       updateTabsetPanel(session, "nav", selected = "panel2")
#'     })
#'   }
#'   shinyApp(ui = ui, server = server)
#' }

backlink_Input <- function(inputId, label = "Back") {
  value <- shiny::restoreInput(id = inputId, default = NULL)
  govBacklink <- shiny::actionLink(
    label = label,
    inputId = inputId,
    class = paste0("govuk-back-link"),
    `data-val` = value
  )
  attachDependency(govBacklink)
}
