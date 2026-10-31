#' Error Summary Function
#'
#' This function loads the error summary component to display error text.
#' This replicates the gov style error boxes linked below:
#' https://design-system.service.gov.uk/components/error-summary/
#'
#' Name each message with the `inputId` of the control it is about to turn it
#' into a link, as the GOV.UK Design System requires. Selecting a link moves
#' focus to that control (the day field of a [date_Input()], the first option
#' of a [radio_button_Input()] or [checkbox_Input()]) and scrolls its label or
#' legend into view. Unnamed messages are shown as plain text.
#'
#' Pass the full id of the control, as it appears in the page. Inside a module
#' that means wrapping it in `ns()`, the same as the `inputId` of the summary
#' itself.
#' @inheritParams id_arg
#' @param error_title The title for the error summary
#' @param error_list A character vector or list of messages to be displayed in
#' the error body. Messages named with the id of an input link to that input,
#' for example `c(name = "Enter your name")`. Plain strings are escaped; pass
#' tags or [shiny::HTML()] for markup.
#' @return an error_summary HTML shiny tag object
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
#'         dob = "Enter your date of birth"
#'       )
#'     ),
#'     shinyGovstyle::text_Input("name", "Full name"),
#'     shinyGovstyle::date_Input("dob", "Date of birth")
#'   ),
#'   shinyGovstyle::button_Input("btn1", "Change error summary"),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   shiny::observeEvent(input$btn1, {
#'     error_summary_update(
#'       "errorId",
#'       c(dob = "Date of birth must be in the past")
#'     )},
#'     ignoreInit = TRUE
#'   )
#' }
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
error_summary <- function(
  inputId, # nolint
  error_title,
  error_list
) {
  gov_error_summary <-
    shiny::tags$div(
      id = inputId,
      class = "govuk-error-summary",
      shiny::tags$div(
        role = "alert",
        shiny::tags$h2(error_title, class = "govuk-error-summary__title"),
        shiny::tags$div(
          id = paste0(inputId, "list"),
          class = "govuk-error-summary__body",
          error_summary_list(error_list)
        )
      )
    )
  attachDependency(gov_error_summary, "error_summary")
}

# Internal helper: the summary's `<ul>`, shared by error_summary() and
# error_summary_update() so both render the same markup. Messages named with an
# input id become `<a href="#id">` links (GOV.UK Design System, error summary);
# unnamed or empty-named messages stay plain text, as they always have. `ns`
# namespaces the link targets, for error_summary_update() inside a module.
# Messages go into the tags as they are, so htmltools escapes plain strings and
# keeps tags and HTML(), the same rule govuk_error_html() applies.
error_summary_list <- function(error_list, ns = identity) {
  targets <- names(error_list)
  if (is.null(targets)) {
    targets <- character(length(error_list))
  }
  shiny::tags$ul(
    class = "govuk-list govuk-error-summary__list",
    Map(
      function(message, target) {
        if (is.na(target) || target == "") {
          shiny::tags$li(message)
        } else {
          shiny::tags$li(shiny::tags$a(href = paste0("#", ns(target)), message))
        }
      },
      message = unname(as.list(error_list)),
      target = targets
    )
  )
}

# Internal helper: the id of the control an error summary link moves focus to,
# which GOV.UK says is the first focusable control in the group. Single
# controls (text inputs, textareas, selects, file inputs) are their own target.
# Compound controls render their target as `data-govuk-error-target` on the
# element whose id is `inputId`, and error_summary.js follows it, so a link
# only ever needs the `inputId` the caller already knows. Radio option ids come
# from generateOptions2(); checkbox option ids are the caller's `checkboxIds`.
govuk_error_target_id <- function(
  inputId, # nolint
  type = c("input", "date", "radio", "checkbox"),
  option_ids = NULL
) {
  type <- match.arg(type)
  switch(
    type,
    input = inputId,
    date = paste0(inputId, "_day"),
    radio = paste0(inputId, "-1"),
    checkbox = if (length(option_ids) > 0) as.character(option_ids[[1]])
  )
}
