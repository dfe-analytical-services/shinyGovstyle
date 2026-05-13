# ---- Internal helpers -------------------------------------------------------

# Build a single <button> action element with visually-hidden context text.
build_action_button <- function(id, text, visually_hidden_text) { # nolint
  shiny::tags$button(
    id = id,
    class = "govuk-link action-button",
    `data-val` = shiny::restoreInput(id = id, default = NULL),
    text,
    if (!is.null(visually_hidden_text) && nchar(visually_hidden_text) > 0) {
      shiny::tags$span(
        class = "govuk-visually-hidden",
        paste0(" ", visually_hidden_text)
      )
    }
  )
}

# Build the <dd class="govuk-summary-list__actions"> cell for one row.
# `actions` is a list of action specs: list(id, text, visually_hidden_text).
build_actions_cell <- function(actions) { # nolint
  if (length(actions) == 0) return(NULL)

  if (length(actions) == 1) {
    a <- actions[[1]]
    shiny::tags$dd(
      class = "govuk-summary-list__actions",
      build_action_button(a$id, a$text, a$visually_hidden_text)
    )
  } else {
    li_items <- lapply(actions, function(a) {
      shiny::tags$li(
        class = "govuk-summary-list__actions-list-item",
        build_action_button(a$id, a$text, a$visually_hidden_text)
      )
    })
    shiny::tags$dd(
      class = "govuk-summary-list__actions",
      do.call(shiny::tags$ul,
        c(list(class = "govuk-summary-list__actions-list"), li_items)
      )
    )
  }
}

# Build a single <div class="govuk-summary-list__row"> from a row spec.
# Row spec fields: key, value, actions (list), no_border (logical).
build_summary_row <- function(row) { # nolint
  has_actions <- length(row$actions) > 0

  row_classes <- "govuk-summary-list__row"
  if (!has_actions) {
    row_classes <- paste(row_classes, "govuk-summary-list__row--no-actions")
  }
  if (isTRUE(row$no_border)) {
    row_classes <- paste(row_classes, "govuk-summary-list__row--no-border")
  }

  key_content <- if (inherits(row$key, "shiny.tag") ||
                       inherits(row$key, "shiny.tag.list") ||
                       inherits(row$key, "html")) {
    row$key
  } else {
    row$key
  }

  value_content <- if (inherits(row$value, "shiny.tag") ||
                          inherits(row$value, "shiny.tag.list") ||
                          inherits(row$value, "html")) {
    row$value
  } else {
    shiny::HTML(row$value)
  }

  shiny::tags$div(
    class = row_classes,
    shiny::tags$dt(
      class = "govuk-summary-list__key",
      key_content
    ),
    shiny::tags$dd(
      class = "govuk-summary-list__value",
      value_content
    ),
    build_actions_cell(row$actions)
  )
}

# Convert the legacy vector API into the rows-list format.
legacy_to_rows <- function(headers, info, action) { # nolint
  action_ids <- if (isFALSE(action)) {
    rep(list(NULL), length(headers))
  } else if (isTRUE(action)) {
    lapply(headers, function(h) {
      id <- gsub(" ", "_", tolower(h))
      list(list(id = id, text = "Change", visually_hidden_text = h))
    })
  } else {
    # action is a character vector of button IDs, one per header
    lapply(seq_along(headers), function(i) {
      id <- action[[i]]
      if (is.na(id) || is.null(id) || isFALSE(id)) {
        list()
      } else {
        list(list(id = id, text = "Change",
                  visually_hidden_text = headers[[i]]))
      }
    })
  }

  lapply(seq_along(headers), function(i) {
    list(
      key = headers[[i]],
      value = info[[i]],
      actions = action_ids[[i]],
      no_border = FALSE
    )
  })
}

# ---- Exported functions -----------------------------------------------------

#' Summary List Function
#'
#' Creates a GOV.UK summary list. Supports a simple vector API (for backwards
#' compatibility) and a richer row-spec list API that unlocks all design system
#' variants: multiple actions per row, per-row borders, HTML keys, summary
#' cards, and mixed-action lists.
#'
#' @param inputId The Id for the summary list `<dl>` element.
#' @param headers Character vector of key/label strings. Used with the legacy
#'   vector API. Ignored when `rows` is supplied.
#' @param info Character vector of value strings (may contain HTML). Used with
#'   the legacy vector API. Ignored when `rows` is supplied.
#' @param rows A list of row spec lists for the richer API. Each element is a
#'   named list with the following fields:
#'   \describe{
#'     \item{`key`}{Required. A character string or htmltools/shiny tag for the
#'       key column.}
#'     \item{`value`}{Required. A character string (treated as HTML) or
#'       htmltools/shiny tag for the value column.}
#'     \item{`actions`}{Optional. A list of action spec lists. Each action spec
#'       has `id` (button ID), `text` (button label, e.g. "Change"), and
#'       `visually_hidden_text` (screen-reader context, e.g. "name"). An empty
#'       list or `NULL` means no actions for that row.}
#'     \item{`no_border`}{Optional logical. Set `TRUE` to add
#'       `govuk-summary-list__row--no-border` to this row.}
#'   }
#' @param action Legacy parameter. `FALSE` (default) produces rows without
#'   actions. `TRUE` produces a "Change" button per row with the button ID
#'   derived from the header text. A character vector of IDs (one per row)
#'   gives per-row control. Ignored when `rows` is supplied.
#' @param border Logical. Whether to show borders between rows. Default `TRUE`.
#'   Set `FALSE` to add `govuk-summary-list--no-border`.
#' @return An HTML shiny tag object.
#' @family Govstyle feedback types
#' @export
#' @examples
#' # --- Legacy vector API ---
#' headers <- c("Name", "Date of birth", "Contact information")
#' info    <- c("Sarah Philips", "5 January 1978",
#'              "72 Guild Street <br> London <br> SE23 6FH")
#'
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header("Example", "User Examples",
#'                         logo = "shinyGovstyle/images/moj_logo.png"),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     shinyGovstyle::gov_summary("sumID", headers, info, action = FALSE)
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
#'
#' # --- Rich rows API with multiple actions ---
#' rows <- list(
#'   list(key = "Name", value = "Sarah Philips",
#'        actions = list(
#'          list(id = "change_name", text = "Change",
#'               visually_hidden_text = "name")
#'        )),
#'   list(key = "Contact details", value = "Not provided",
#'        actions = list(
#'          list(id = "add_contact",    text = "Add",
#'               visually_hidden_text = "contact details"),
#'          list(id = "change_contact", text = "Change",
#'               visually_hidden_text = "contact details")
#'        )),
#'   list(key = "Date of birth", value = "5 January 1978", actions = list())
#' )
#'
#' ui2 <- shiny::fluidPage(
#'   shinyGovstyle::header("Example", "User Examples",
#'                         logo = "shinyGovstyle/images/moj_logo.png"),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     shinyGovstyle::gov_summary("sumID2", rows = rows)
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#' if (interactive()) shinyApp(ui = ui2, server = function(input, output, session) {})
gov_summary <- function( # nolint
  inputId, # nolint
  headers = NULL,
  info = NULL,
  rows = NULL,
  action = FALSE,
  border = TRUE
) {
  if (is.null(rows)) {
    rows <- legacy_to_rows(headers, info, action)
  }

  border_class <- if (border) {
    "govuk-summary-list"
  } else {
    "govuk-summary-list govuk-summary-list--no-border"
  }

  row_tags <- lapply(rows, build_summary_row)
  tag <- do.call(shiny::tags$dl,
    c(list(class = border_class, id = inputId), row_tags)
  )

  summary_css <- htmltools::htmlDependency(
    name = "summary",
    version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "summary-overrides.css"
  )

  htmltools::attachDependencies(
    attachDependency(tag), # nolint
    summary_css,
    append = TRUE
  )
}

#' Summary Card Function
#'
#' Wraps a [gov_summary()] in a GOV.UK summary card, adding a titled header and
#' optional card-level actions. Use summary cards when you need to show multiple
#' summary lists and need to tell them apart, for example in a multi-section
#' check-your-answers page.
#'
#' @param inputId The Id for the inner summary list `<dl>` element.
#' @param title Character string. The card title text.
#' @param heading_level Integer (1–6). HTML heading level for the card title.
#'   Default `2L`.
#' @param card_actions Optional list of card-level action specs. Each element is
#'   a named list with `id`, `text`, and optionally `visually_hidden_text`. Card
#'   actions appear in the title bar and apply to the whole card (e.g. "Delete",
#'   "Withdraw").
#' @param headers See [gov_summary()].
#' @param info See [gov_summary()].
#' @param rows See [gov_summary()].
#' @param action See [gov_summary()].
#' @param border See [gov_summary()].
#' @return An HTML shiny tag object.
#' @family Govstyle feedback types
#' @export
#' @examples
#' rows <- list(
#'   list(key = "Age",        value = "38",
#'        actions = list(list(id = "change_age", text = "Change",
#'                            visually_hidden_text = "age"))),
#'   list(key = "Nationality", value = "French",
#'        actions = list(list(id = "change_nat", text = "Change",
#'                            visually_hidden_text = "nationality")))
#' )
#'
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header("Example", "User Examples",
#'                         logo = "shinyGovstyle/images/moj_logo.png"),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     shinyGovstyle::gov_summary_card(
#'       inputId = "cardID",
#'       title   = "Lead tenant",
#'       card_actions = list(
#'         list(id = "delete_card", text = "Delete choice",
#'              visually_hidden_text = "(Lead tenant)"),
#'         list(id = "withdraw_card", text = "Withdraw",
#'              visually_hidden_text = "(Lead tenant)")
#'       ),
#'       rows = rows
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#' if (interactive()) shinyApp(ui = ui, server = function(input, output, session) {})
gov_summary_card <- function( # nolint
  inputId, # nolint
  title,
  heading_level = 2L,
  card_actions = NULL,
  headers = NULL,
  info = NULL,
  rows = NULL,
  action = FALSE,
  border = TRUE
) {
  heading_level <- as.integer(heading_level)
  if (heading_level < 1L || heading_level > 6L) {
    stop("`heading_level` must be an integer between 1 and 6.")
  }
  heading_tag <- paste0("h", heading_level)

  actions_html <- if (!is.null(card_actions) && length(card_actions) > 0) {
    li_items <- lapply(card_actions, function(a) {
      shiny::tags$li(
        class = "govuk-summary-card__action",
        build_action_button(a$id, a$text, a$visually_hidden_text)
      )
    })
    do.call(shiny::tags$ul,
      c(list(class = "govuk-summary-card__actions"), li_items)
    )
  }

  inner_list <- gov_summary(
    inputId = inputId,
    headers = headers,
    info = info,
    rows = rows,
    action = action,
    border = border
  )

  shiny::tags$div(
    class = "govuk-summary-card",
    shiny::tags$div(
      class = "govuk-summary-card__title-wrapper",
      shiny::tags[[heading_tag]](
        class = "govuk-summary-card__title",
        title
      ),
      actions_html
    ),
    shiny::tags$div(
      class = "govuk-summary-card__content",
      inner_list
    )
  )
}
