#' Error Summary Update Function
#'
#' This function changes the messages that display in the error summary box
#' and, by default, moves focus to the summary so screen reader and keyboard
#' users are taken straight to the list of problems, as the GOV.UK Design
#' System requires after a failed submission. Requires
#' `shinyjs::useShinyjs()` to work.
#'
#' Name messages with the `inputId` of the control they are about to link
#' them, as in [error_summary()]. Inside a module, pass the bare ids (without
#' `ns()`): both the summary's `inputId` and the link targets are namespaced
#' for you, as with [error_on()].
#'
#' The summary must be visible before it can take focus. If you show and hide
#' it with `shinyjs`, call `shinyjs::show()` before `error_summary_update()`.
#' @inheritParams id_arg
#' @param error_list An updated character vector or list of messages to be
#' displayed in the error body. Messages named with the id of an input link to
#' that input, for example `c(name = "Enter your name")`. Plain strings are
#' escaped; pass tags or [shiny::HTML()] for markup.
#' @param focus If `TRUE` (the default), move focus to the summary after
#' updating it. Set to `FALSE` when the update is not the result of the user
#' submitting a form, for example when clearing the list as they fix answers.
#' @return Called for its side effects; no return value
#' @family Govstyle errors
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     error_summary(
#'       inputId = "errorId",
#'       error_title = "There is a problem",
#'       error_list = c(
#'         name = "Enter your full name",
#'         contact = "Select how you would like to be contacted"
#'       )
#'     ),
#'     shinyGovstyle::text_Input("name", "Full name"),
#'     shinyGovstyle::radio_button_Input(
#'       "contact",
#'       "How would you like to be contacted?",
#'       choices = c("Email", "Phone")
#'     )
#'   ),
#'   shinyGovstyle::button_Input("btn1", "Change error summary"),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   shiny::observeEvent(input$btn1, {
#'     error_summary_update(
#'       "errorId",
#'       c(
#'         name = "Enter your full name",
#'         contact = "Select how you would like to be contacted",
#'         "Check your answers before you continue"
#'       )
#'     )
#'   },
#'   ignoreInit = TRUE
#'   )
#' }
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
error_summary_update <- function(
  inputId, # nolint
  error_list,
  focus = TRUE
) {
  session <- shiny::getDefaultReactiveDomain()
  ns <- if (is.null(session)) identity else session$ns

  # shinyjs::html() namespaces `id` itself, so it gets the bare id; the link
  # targets are written into the markup, so they are namespaced here.
  shinyjs::html(
    id = paste0(inputId, "list"),
    html = as.character(error_summary_list(error_list, ns = ns))
  )

  if (isTRUE(focus)) {
    shinyjs::runjs(error_summary_focus_js(ns(inputId)))
  }
}

# Internal helper: JavaScript that moves focus to the summary, as GOV.UK
# Frontend does when a page loads with errors. tabindex="-1" makes the div
# focusable by script without adding it to the tab order, and is removed again
# on blur so a later click on the summary does not draw a focus outline. The id
# is already namespaced and is embedded as a JSON string literal so it cannot
# break the script.
error_summary_focus_js <- function(summary_id) {
  paste0(
    "(function() {",
    "var el = document.getElementById(",
    as.character(jsonlite::toJSON(summary_id, auto_unbox = TRUE)),
    ");",
    "if (!el) return;",
    "el.setAttribute('tabindex', '-1');",
    "el.addEventListener('blur', function() {",
    " el.removeAttribute('tabindex'); }, { once: true });",
    "el.focus();",
    "})();"
  )
}
