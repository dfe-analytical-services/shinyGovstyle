# ---- Internal helpers -------------------------------------------------------

# Build the <dl> for gov_summary() and gov_summary_card(), with the GOV.UK and
# summary-overrides stylesheets attached.
summary_list <- function(input_id, headers, info, border) {
  border_class <- if (border) {
    "govuk-summary-list"
  } else {
    "govuk-summary-list govuk-summary-list--no-border"
  }

  row_tags <- Map(
    function(header, value) {
      shiny::tags$div(
        class = "govuk-summary-list__row",
        shiny::tags$dt(class = "govuk-summary-list__key", header),
        shiny::tags$dd(
          class = "govuk-summary-list__value",
          as_govuk_html(value)
        )
      )
    },
    header = headers,
    value = info,
    USE.NAMES = FALSE
  )
  dl <- do.call(
    shiny::tags$dl,
    c(list(class = border_class, id = input_id), row_tags)
  )

  summary_css <- htmltools::htmlDependency(
    name = "summary",
    version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "summary-overrides.css"
  )

  htmltools::attachDependencies(
    attachDependency(dl),
    summary_css,
    append = TRUE
  )
}

# ---- Exported functions -----------------------------------------------------

#' Summary list
#'
#' Creates a GOV.UK summary list: a set of key and value pairs. To show several
#' lists that need telling apart, wrap each in [gov_summary_card()].
#'
#' The list switches between GOV.UK's stacked and side-by-side layouts based
#' on its own width rather than the screen's. It stays stacked until it is
#' as wide as a full-width GOV.UK list at GOV.UK's 641px breakpoint (about
#' 580px), so in a narrow column, such as
#' `gov_box(size = "two-thirds")`, the key column is never too narrow for
#' ordinary words. Browsers without CSS container queries use GOV.UK's
#' screen-width breakpoint instead.
#'
#' @inheritParams id_arg
#' @param headers Character vector of row headers (the keys).
#' @param info Summary information values for the table. Each value accepts a
#'   plain character string, or `shiny` tag objects such as
#'   `shiny::tags$b("Bold")` or a `shiny::tagList()`. Pass a list rather than a
#'   character vector to mix tag and string values.
#' @param border Whether to show borders between rows. Default `TRUE`.
#' @return A `div` HTML shiny tag object holding the summary list `<dl>`,
#'   which has `inputId` as its id. The `div` lets the list change layout
#'   based on its own width.
#' @family Govstyle feedback types
#' @export
#' @examples
#' # Vector API
#' headers <- c(
#'   "Name",
#'   "Date of birth",
#'   "Contact information",
#'   "Contact details"
#' )
#' info <- c(
#'   "Sarah Philips",
#'   "5 January 1978",
#'   "72 Guild Street <br> London <br> SE23 6FH",
#'   "07700 900457 <br> sarah.phillips@example.com"
#' )
#'
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::gov_summary("sumID", headers, info)
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
gov_summary <- function(
  inputId, # nolint
  headers,
  info,
  border = TRUE
) {
  # The div is the CSS container summary-overrides.css measures, so the list
  # can stack when it is narrow; see that file for why this extends GOV.UK
  shiny::tags$div(
    class = "shinygovstyle-summary",
    summary_list(inputId, headers, info, border)
  )
}

#' Summary card
#'
#' Wraps a [gov_summary()] in a GOV.UK summary card with a titled header. Use
#' summary cards when you need to show multiple summary lists and need to tell
#' them apart, for example in a multi-section check-your-answers page.
#'
#' @param inputId The Id for the inner summary list `<dl>` element.
#' @param title Character string. The card title text.
#' @param heading_level Integer (1-6). HTML heading level for the card title.
#'   Default `2L`.
#' @param headers See [gov_summary()].
#' @param info See [gov_summary()].
#' @param border See [gov_summary()].
#' @return An HTML shiny tag object.
#' @family Govstyle feedback types
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::gov_summary_card(
#'       inputId = "cardID",
#'       title = "Lead tenant",
#'       headers = c("Age", "Nationality"),
#'       info = c("38", "French")
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#' if (interactive()) {
#'   shinyApp(ui = ui, server = function(input, output, session) {})
#' }
gov_summary_card <- function(
  inputId, # nolint
  title,
  heading_level = 2L,
  headers,
  info,
  border = TRUE
) {
  validate_heading_level(heading_level)
  if (!is.character(title) || length(title) != 1 || !nzchar(title)) {
    stop("`title` must be a single, non-empty string.", call. = FALSE)
  }

  inner_list <- summary_list(inputId, headers, info, border)

  # The card is the CSS container summary-overrides.css measures, so the card
  # header and its list stack together when the card is narrow
  shiny::tags$div(
    class = "govuk-summary-card shinygovstyle-summary",
    shiny::tags$div(
      class = "govuk-summary-card__title-wrapper",
      build_heading_tag(heading_level, title, "govuk-summary-card__title")
    ),
    shiny::tags$div(
      class = "govuk-summary-card__content",
      inner_list
    )
  )
}
