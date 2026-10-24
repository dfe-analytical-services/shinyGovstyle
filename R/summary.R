# ---- Internal helpers -------------------------------------------------------

# Build a single <button> action element with visually-hidden context text.
build_action_button <- function(id, text, visually_hidden_text) {
  shiny::tags$button(
    type = "button",
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
build_actions_cell <- function(actions) {
  if (length(actions) == 0) {
    return(NULL)
  }

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
      do.call(
        shiny::tags$ul,
        c(list(class = "govuk-summary-list__actions-list"), li_items)
      )
    )
  }
}

# Build a single <div class="govuk-summary-list__row"> from a row spec.
# Row spec fields: key, value, actions (list), no_border (logical).
build_summary_row <- function(row) {
  has_actions <- length(row$actions) > 0

  row_classes <- "govuk-summary-list__row"
  if (!has_actions) {
    row_classes <- paste(row_classes, "govuk-summary-list__row--no-actions")
  }
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
    ),
    build_actions_cell(row$actions)
  )
}

# Convert the legacy vector API into the rows-list format.
legacy_to_rows <- function(input_id, headers, info, action) {
  action_ids <- if (isFALSE(action)) {
    rep(list(NULL), length(headers))
  } else if (isTRUE(action)) {
    ids <- summary_action_ids(input_id, headers)
    lapply(seq_along(headers), function(i) {
      list(list(
        id = ids[[i]],
        text = "Change",
        visually_hidden_text = tolower(headers[[i]])
      ))
    })
  } else {
    # action is a character vector of button IDs, one per header
    lapply(seq_along(headers), function(i) {
      id <- action[[i]]
      if (is.null(id) || is.na(id) || isFALSE(id)) {
        list()
      } else {
        list(list(
          id = id,
          text = "Change",
          visually_hidden_text = tolower(headers[[i]])
        ))
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

# Builds one input ID per summary row from `input_id` and a slug of the header,
# e.g. "sumID" and "Date of birth" give "sumID_date_of_birth". Errors when a
# header gives an empty slug or two headers give the same one, since the rows
# would then share a Shiny input.
summary_action_ids <- function(input_id, headers) {
  if (!is.character(headers)) {
    stop(
      "`headers` must be a character vector when `action = TRUE`.",
      call. = FALSE
    )
  }

  slugs <- gsub("[^a-z0-9]+", "_", tolower(headers))
  slugs <- gsub("^_+|_+$", "", slugs)

  if (any(slugs == "")) {
    stop(
      "Every header must contain a letter or number when `action = TRUE`, ",
      "so each Change button can have its own input ID.",
      call. = FALSE
    )
  }

  dupes <- unique(slugs[duplicated(slugs)])
  if (length(dupes) > 0) {
    stop(
      "Headers must give unique input IDs when `action = TRUE`. ",
      "These headers clash: ",
      paste(shQuote(headers[slugs %in% dupes]), collapse = ", "),
      call. = FALSE
    )
  }

  paste0(input_id, "_", slugs)
}

# ---- Exported functions -----------------------------------------------------

#' Summary list
#'
#' Creates a GOV.UK summary list: a set of key and value pairs, optionally with
#' actions such as "Change" on each row. Supports a simple vector API and a
#' richer row-spec list API that covers the design system variants: multiple
#' actions per row, per-row borders, HTML keys and mixed-action lists. To show
#' several lists that need telling apart, wrap each in [gov_summary_card()].
#'
#' Between 641px and 768px wide, the list stays stacked rather than switching
#' to GOV.UK's side-by-side layout, so the key column is never too narrow for
#' ordinary words.
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
#'     \item{`actions`}{Optional. A list of action spec lists. Each action spec
#'       has `id` (button input ID), `text` (button label, e.g. "Change"), and
#'       `visually_hidden_text` (screen reader context, e.g. "name"). An empty
#'       list or `NULL` means no actions for that row.}
#'     \item{`no_border`}{Optional logical. Set `TRUE` to remove this row's
#'       border.}
#'   }
#' @param action Used with the vector API. `FALSE` (default) gives rows with
#'   no actions. `TRUE` gives each row its own "Change" button whose input ID
#'   is `paste0(inputId, "_", slug)`, where `slug` is the header in lowercase
#'   with each run of characters other than letters and numbers replaced by
#'   `_` and any leading or trailing `_` removed. For example, with
#'   `inputId = "sumID"` the "Date of birth" row sets
#'   `input$sumID_date_of_birth`, which counts its clicks like
#'   [shiny::actionButton()]. Headers must give unique slugs. A character
#'   vector of input IDs, one per row, sets the IDs yourself; use `NA` for a
#'   row with no action. Each button has visually hidden text so screen
#'   readers announce, for example, "Change date of birth" rather than a bare
#'   "Change". Ignored when `rows` is supplied.
#' @param border Whether to show borders between rows. Default `TRUE`.
#' @return a summary list HTML shiny tag object
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
#'     shinyGovstyle::gov_summary("sumID", headers, info, action = TRUE),
#'     shiny::textOutput("changed")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   # Each row has its own input: sumID_name, sumID_date_of_birth, ...
#'   shiny::observeEvent(input$sumID_name, {
#'     output$changed <- shiny::renderText("Change name clicked")
#'   })
#' }
#' if (interactive()) shinyApp(ui = ui, server = server)
#'
#' # Rows API with multiple actions on one row
#' rows <- list(
#'   list(
#'     key = "Name",
#'     value = "Sarah Philips",
#'     actions = list(
#'       list(id = "change_name", text = "Change", visually_hidden_text = "name")
#'     )
#'   ),
#'   list(
#'     key = "Contact details",
#'     value = "Not provided",
#'     actions = list(
#'       list(
#'         id = "add_contact",
#'         text = "Add",
#'         visually_hidden_text = "contact details"
#'       ),
#'       list(
#'         id = "change_contact",
#'         text = "Change",
#'         visually_hidden_text = "contact details"
#'       )
#'     )
#'   ),
#'   list(key = "Date of birth", value = "5 January 1978", actions = list())
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
  action = FALSE,
  border = TRUE
) {
  if (is.null(rows)) {
    rows <- legacy_to_rows(inputId, headers, info, action)
  }

  border_class <- if (border) {
    "govuk-summary-list"
  } else {
    "govuk-summary-list govuk-summary-list--no-border"
  }

  row_tags <- lapply(rows, build_summary_row)
  summary_list <- do.call(
    shiny::tags$dl,
    c(list(class = border_class, id = inputId), row_tags)
  )

  summary_css <- htmltools::htmlDependency(
    name = "summary",
    version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "summary-overrides.css"
  )

  htmltools::attachDependencies(
    attachDependency(summary_list),
    summary_css,
    append = TRUE
  )
}

#' Summary card
#'
#' Wraps a [gov_summary()] in a GOV.UK summary card, adding a titled header and
#' optional card-level actions. Use summary cards when you need to show multiple
#' summary lists and need to tell them apart, for example in a multi-section
#' check-your-answers page.
#'
#' @param inputId The Id for the inner summary list `<dl>` element.
#' @param title Character string. The card title text.
#' @param heading_level Integer (1-6). HTML heading level for the card title.
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
#'   list(
#'     key = "Age",
#'     value = "38",
#'     actions = list(
#'       list(id = "change_age", text = "Change", visually_hidden_text = "age")
#'     )
#'   ),
#'   list(
#'     key = "Nationality",
#'     value = "French",
#'     actions = list(
#'       list(
#'         id = "change_nat",
#'         text = "Change",
#'         visually_hidden_text = "nationality"
#'       )
#'     )
#'   )
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
#'       card_actions = list(
#'         list(
#'           id = "delete_card",
#'           text = "Delete choice",
#'           visually_hidden_text = "(Lead tenant)"
#'         ),
#'         list(
#'           id = "withdraw_card",
#'           text = "Withdraw",
#'           visually_hidden_text = "(Lead tenant)"
#'         )
#'       ),
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
    do.call(
      shiny::tags$ul,
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
