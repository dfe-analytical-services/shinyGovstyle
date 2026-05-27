#' Update the browser page title
#'
#' @description
#' Sends a message to the browser to update `document.title` — the text shown
#' in the browser tab. Use this to keep the page title in sync with the
#' content currently on display.
#'
#' Keeping the page title in sync with the visible page is a GOV.UK Design
#' System recommendation: screen readers announce the title on navigation,
#' and the tab text helps users orient themselves when many tabs are open.
#'
#' **When you need this function:** when navigation is triggered
#' programmatically (next / back buttons, footer links pointing to a main
#' page, modal dialogue links) and the visible page changes without the user
#' clicking a nav link directly. Also useful when the page heading differs
#' from the nav link label and you want the tab title to match the heading.
#'
#' **When you don't need this function:** when the user clicks a
#' `service_navigation()` link directly and the page title should just match
#' the link text. `service_navigation()` syncs the title automatically by
#' default — see its `auto_page_title` argument.
#'
#' The JavaScript handler ships with every shinyGovstyle component, so
#' `update_page_title()` works in any app that uses at least one
#' shinyGovstyle function in its UI.
#'
#' @param session The Shiny session object
#' @param page_title Character string with the new page title (typically the
#'   page heading or nav link text)
#' @param service_name Optional character string. When supplied, the browser
#'   tab title is set to `"<page_title> | <service_name>"` — the GOV.UK
#'   recommended format. When `NULL`, only `page_title` is shown.
#'
#' @returns NULL, called for side effects
#' @family Govstyle navigation
#' @export
#'
#' @examples
#' # Programmatic navigation — keep the page title in sync with the new page.
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::service_navigation(c("Page one", "Page two")),
#'   bslib::navset_hidden(
#'     id = "tabs",
#'     bslib::nav_panel("page_one", shiny::actionButton("next_btn", "Next")),
#'     bslib::nav_panel("page_two", "Page two content")
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   shiny::observeEvent(input$next_btn, {
#'     bslib::nav_select("tabs", "page_two")
#'     shinyGovstyle::update_service_navigation(session, "page_two")
#'     shinyGovstyle::update_page_title(
#'       session,
#'       page_title = "Page two",
#'       service_name = "My service"
#'     )
#'   })
#' }
#'
#' if (interactive()) shiny::shinyApp(ui = ui, server = server)
update_page_title <- function(
  session,
  page_title,
  service_name = NULL
) {
  stopifnot(
    is.character(page_title),
    length(page_title) == 1,
    nzchar(page_title)
  )
  if (is.null(service_name) || !nzchar(service_name)) {
    title <- page_title
  } else {
    title <- paste(page_title, service_name, sep = " | ")
  }
  session$sendCustomMessage("update_page_title", title)
}
