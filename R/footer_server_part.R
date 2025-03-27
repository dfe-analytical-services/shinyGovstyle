#' Footer Server Part Function
#'
#' This function deals with the server part of the footer links
#'
#' You can add actionLinks as links in the footer through using the links_list
#' argument.
#'
#' Links in the footer should be used sparingly and are usually for supporting
#' information pages such as the accessibility statement, privacy notice,
#' cookies information or link to a statement of voluntary adoption of the
#' statistics code of practice.
#'
#' Generally when using footer links you will be controlling a hidden tabset
#' so to the end user it looks like it is a new page. This deals with the
#' links differently if they are tabset or external
#'
#' @param type must be "tab" or "external"
#' @param link_loc either the name of the tab, or the URL of external link
#' @param session is the shiny session
#' @return a link through to the relevant area
#' @keywords footer_server_part
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo = "shinyGovstyle/images/moj_logo.png"
#'     ),
#'     shinyGovstyle::banner(
#'       inputId = "banner", type = "beta", "This is a new service"
#'     ),
#'     tags$br(),
#'     tags$br(),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'
#'   shinyApp(ui = ui, server = server)
#' }
#'
#' # Add links
#' footer(links = c("Accessibility statement", "Cookies"))
#'
#' # Full app with link controlling a hidden tab
#' if (interactive()) {
#'   ui <- fluidPage(
#'   shinyjs::useShinyjs(),
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo = "shinyGovstyle/images/moj_logo.png"
#'     ),
#'     shinyGovstyle::banner(
#'       inputId = "banner", type = "beta", "This is a new service"
#'     ),
#'     shiny::tabsetPanel(
#'       type = "hidden",
#'       id = "tabs",
#'       shiny::tabPanel(
#'         "Main content",
#'         value = "main",
#'         heading_text("Hello world!")
#'       ),
#'       shiny::tabPanel(
#'         "Cookies",
#'         value = "cookies",
#'         heading_text("Cookies")
#'       )
#'     ),
#'     shinyGovstyle::footer(
#'       full = TRUE,
#'       links = c("Accessibility statement", "Cookies", "External link")
#'     )
#'   )
#'
#'   server <- function(input, output, session) {
#'     shiny::observeEvent(input$cookies, {
#'       footer_server_part(type = 'tab', link_loc = 'cookies',session)
#'     })
#'
#'     shiny::observeEvent(input$external_link, {
#'       footer_server_part(type = 'external',
#'                          link_loc = 'https://shiny.posit.co/',
#'                          session)
#'     })
#'   }
#'
#'   shinyApp(ui = ui, server = server)
#' }
footer_server_part <- function(type = "tab", link_loc = NULL, session) {
  if(type %in% c('tab','external')) {
    if(type == 'tab') {
      shiny::updateTabsetPanel(session, "tabs", selected = link_loc)
    } else if (type == 'external') {
      showModal(modalDialog(
        external_link(link_loc,
                      'External Link',
                      add_warning = FALSE
        ),
        easyClose = TRUE,
        footer = NULL
      ))
      # JavaScript to auto-click the link and close the modal
      shinyjs::runjs("
             setTimeout(function() {
               var link = document.querySelector('.modal a');
               if (link) {
                 link.click();
                 setTimeout(function() {
                   $('.modal').modal('hide');
                 }, 20); // Extra delay to avoid any race conditions
               }
            }, 400);
          ")
    }
  } else {
    message(paste0(type," is not a valid selection for the argument 'type'"))
    message(paste0("'type' must be 'tab' or 'external'"))
  }
}
