#' Navigate to a page in one call
#'
#' @description
#' Switches the visible tab panel and updates the active service navigation
#' link in a single call. Use this for programmatic navigation — next / back
#' buttons, modal links, footer shortcuts to a main page — where the user
#' has not clicked a nav link directly.
#'
#' When [service_navigation()] is used with `auto_page_title = TRUE` (the
#' default), the browser tab title is updated automatically too, because
#' [update_service_navigation()] triggers the title sync via the
#' JavaScript binding.
#'
#' By default the nav link `inputId` is also used as the target tab panel
#' `value`. When they differ — for example when nav inputIds carry a prefix
#' like `sn_` to disambiguate from panel values — pass `panel` explicitly.
#'
#' @param session The Shiny session object
#' @param tabset_id The `id` of the `shiny::tabsetPanel()` or
#'   `bslib::navset_hidden()` to switch
#' @param inputId The nav link inputId to set as the active item in the
#'   service navigation
#' @param panel The `value` of the tab panel to switch to. Defaults to
#'   `inputId` for the common case where the two are the same. When your
#'   nav inputIds and panel values differ (e.g. nav id `sn_cookies`, panel
#'   value `panel-cookies`), pass `panel` explicitly. If you omit it when
#'   the values differ, only the nav highlight moves, the visible tab
#'   stays put.
#'
#' @returns NULL, called for side effects
#' @family Govstyle navigation
#' @export
#'
#' @examples
#' # Next / back buttons that cross page boundaries — inputId and panel
#' # value match, so a single id is enough.
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
#'     shinyGovstyle::navigate_to(session, "tabs", "page_two")
#'   })
#' }
#'
#' if (interactive()) shiny::shinyApp(ui = ui, server = server)
#'
#' # Mismatched inputId and panel value — name the panel explicitly.
#' # The nav links use an `sn_` prefix on their inputIds so they don't clash
#' # with any other inputs in the app. The panel values are unrelated names.
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::service_navigation(
#'     # names = nav inputIds, values = link text shown to the user
#'     c(sn_home = "Home", sn_cookies = "Cookies")
#'   ),
#'   bslib::navset_hidden(
#'     id = "tabs",
#'     # first arg of nav_panel() is the panel value
#'     bslib::nav_panel("start", shiny::actionButton("cookies_btn", "Cookies")),
#'     bslib::nav_panel("policy", "Cookies content")
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   shiny::observeEvent(input$cookies_btn, {
#'     # inputId = nav link to highlight; panel = tab panel to show
#'     shinyGovstyle::navigate_to(
#'       session, "tabs", inputId = "sn_cookies", panel = "policy"
#'     )
#'   })
#' }
#'
#' if (interactive()) shiny::shinyApp(ui = ui, server = server)
navigate_to <- function(
  session,
  tabset_id, # nolint: object_name_linter.
  inputId, # nolint: object_name_linter.
  panel = inputId
) {
  shiny::updateTabsetPanel(session, tabset_id, selected = panel)
  update_service_navigation(session, inputId)
}
