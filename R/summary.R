# ---- Internal helpers -------------------------------------------------------

# Build a single <div class="govuk-summary-list__row"> from a row spec.
# Row spec fields: key, value, no_border (logical).
build_summary_row <- function(row) {
  row_classes <- "govuk-summary-list__row"
  if (isTRUE(row$no_border)) {
    row_classes <- paste(row_classes, "govuk-summary-list__row--no-border")
  }

  shiny::tags$div(
    class = row_classes,
    shiny::tags$dt(
      class = "govuk-summary-list__key",
      row$key
    ),
    shiny::tags$dd(
      class = "govuk-summary-list__value",
      as_govuk_html(row$value)
    )
  )
}

# Convert the vector API into the rows-list format.
headers_to_rows <- function(headers, info) {
  lapply(seq_along(headers), function(i) {
    list(key = headers[[i]], value = info[[i]], no_border = FALSE)
  })
}

# Build the <dl> for gov_summary() and gov_summary_card(), with the GOV.UK and
# summary-overrides stylesheets attached.
summary_list <- function(input_id, headers, info, rows, border) {
  if (is.null(rows)) {
    rows <- headers_to_rows(headers, info)
  }

  border_class <- if (border) {
    "govuk-summary-list"
  } else {
    "govuk-summary-list govuk-summary-list--no-border"
  }

  row_tags <- lapply(rows, build_summary_row)
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
#' Creates a GOV.UK summary list: a set of key and value pairs. Supports a
#' simple vector API and a row-spec list API that covers per-row borders and
#' HTML keys. To show several lists that need telling apart, wrap each in
#' [gov_summary_card()].
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
#' @param headers Character vector of row headers (the keys). Used with the
#'   vector API. Ignored when `rows` is supplied.
#' @param info Summary information values for the table. Each value accepts a
#'   plain character string, or `shiny` tag objects such as
#'   `shiny::tags$b("Bold")` or a `shiny::tagList()`. Pass a list rather than a
#'   character vector to mix tag and string values. Used with the vector API.
#'   Ignored when `rows` is supplied.
#' @param rows A list of row spec lists for the richer API. Each element is a
#'   named list with the following fields:
#'   \describe{
#'     \item{`key`}{Required. A character string or htmltools/shiny tag for the
#'       key column.}
#'     \item{`value`}{Required. A character string or htmltools/shiny tag for
#'       the value column.}
#'     \item{`no_border`}{Optional logical. Set `TRUE` to remove this row's
#'       border.}
#'   }
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
#'
#' # Rows API with a borderless row and a tag as a key
#' rows <- list(
#'   list(key = "Name", value = "Sarah Philips", no_border = TRUE),
#'   list(
#'     key = shiny::tags$abbr(title = "Date of birth", "DOB"),
#'     value = "5 January 1978"
#'   )
#' )
#'
#' ui2 <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::gov_summary("sumID2", rows = rows)
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#' if (interactive()) {
#'   shinyApp(ui = ui2, server = function(input, output, session) {})
#' }
gov_summary <- function(
  inputId, # nolint
  headers = NULL,
  info = NULL,
  rows = NULL,
  border = TRUE
) {
  # The div is the CSS container summary-overrides.css measures, so the list
  # can stack when it is narrow; see that file for why this extends GOV.UK
  shiny::tags$div(
    class = "shinygovstyle-summary",
    summary_list(inputId, headers, info, rows, border)
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
#' @param rows See [gov_summary()].
#' @param border See [gov_summary()].
#' @return An HTML shiny tag object.
#' @family Govstyle feedback types
#' @export
#' @examples
#' rows <- list(
#'   list(key = "Age", value = "38"),
#'   list(key = "Nationality", value = "French")
#' )
#'
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::gov_summary_card(
#'       inputId = "cardID",
#'       title = "Lead tenant",
#'       rows = rows
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
  headers = NULL,
  info = NULL,
  rows = NULL,
  border = TRUE
) {
  heading_level <- as.integer(heading_level)
  if (heading_level < 1L || heading_level > 6L) {
    stop("`heading_level` must be an integer between 1 and 6.")
  }
  if (!is.character(title) || length(title) != 1 || !nzchar(title)) {
    stop("`title` must be a single, non-empty string.", call. = FALSE)
  }
  heading_tag <- paste0("h", heading_level)

  inner_list <- summary_list(inputId, headers, info, rows, border)

  # The card is the CSS container summary-overrides.css measures, so the card
  # header and its list stack together when the card is narrow
  shiny::tags$div(
    class = "govuk-summary-card shinygovstyle-summary",
    shiny::tags$div(
      class = "govuk-summary-card__title-wrapper",
      shiny::tags[[heading_tag]](
        class = "govuk-summary-card__title",
        title
      )
    ),
    shiny::tags$div(
      class = "govuk-summary-card__content",
      inner_list
    )
  )
}
