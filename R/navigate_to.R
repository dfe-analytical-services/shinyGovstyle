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
#'   service navigation. It is cleaned up the same way as in
#'   [service_navigation()], so `"Page-Two"` and `"page_two"` both refer to
#'   the same link
#' @param panel The `value` of the tab panel to switch to. Defaults to
#'   `inputId` for the common case where the two are the same. When your
#'   nav inputIds and panel values differ (e.g. nav id `sn_cookies`, panel
#'   value `panel-cookies`), pass `panel` explicitly. If you omit it when
#'   the values differ, only the nav highlight moves, the visible tab
#'   stays put.
#' @param focus Whether to move keyboard focus to the newly shown panel.
#'   Defaults to `TRUE`. Set to `FALSE` when the switch is not a response to
#'   something the user did, for example restoring a page from a bookmarked
#'   URL when the app starts.
#'
#' @section Focus management:
#' When `focus = TRUE`, focus moves to the first `<h1>` in the newly shown
#' panel once it is visible, falling back to the page's `<main>` element
#' (as created by [gov_main_layout()]) when the panel has no `<h1>`. The
#' heading is given `tabindex="-1"` for the move, and loses it again when
#' focus leaves it. Without this, the button or link that triggered the
#' switch is usually inside the panel that has just been hidden, so focus
#' drops to the top of the document with nothing announced to screen
#' reader users (WCAG 2.4.3 Focus Order). Give each panel an `<h1>`, for
#' example with [heading_text()], so the move reads out the new page name.
#'
#' Direct clicks on [service_navigation()] links do not move focus: they go
#' through [service_navigation_server()], not `navigate_to()`. On a GOV.UK
#' service each nav link loads a new page and focus starts again from the
#' top. Leaving focus on the link, which stays visible and is marked as
#' the current page, is the closest match, and users can carry on with the
#' skip link or Tab into the content.
#'
#' @returns NULL, called for side effects
#' @family Govstyle navigation
#' @export
#'
#' @examples
#' # Next / back buttons that cross page boundaries — inputId and panel
#' # value match, so a single id is enough.
#' ui <- shinyGovstyle::gov_page(
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
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::service_navigation(
#'     # names = link text shown to the user, values = nav inputIds
#'     c(Home = "sn_home", Cookies = "sn_cookies")
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
  panel = inputId,
  focus = TRUE
) {
  shiny::updateTabsetPanel(session, tabset_id, selected = panel)
  update_service_navigation(session, inputId)
  if (isTRUE(focus)) {
    focus_panel(session, tabset_id, panel)
  }
}

#' Move focus to a tab panel once it is shown
#'
#' Sends the message handled in `inst/www/js/focus_management.js`. The
#' tabset id is namespaced the same way `shiny::updateTabsetPanel()` does it,
#' so this works from inside a module.
#'
#' @noRd
focus_panel <- function(session, tabset_id, panel) {
  session$sendCustomMessage(
    "shinygovstyle_focus_panel",
    list(tabset_id = session$ns(tabset_id), panel = panel)
  )
}
