#' Summary list
#'
#' This function creates a GOV.UK summary list: a set of key and value pairs,
#' optionally with a "Change" action on each row.
#' @inheritParams id_arg
#' @param headers character vector of row headers (the keys)
#' @param info Summary information values for the table. Each value accepts a
#' plain character string, or `shiny` tag objects such as
#' `shiny::tags$b("Bold")` or a `shiny::tagList()`. Pass a list rather than a
#' character vector to mix tag and string values.
#' @param action whether to add a "Change" action to each row. Default set to
#' `FALSE`. When `TRUE`, each row gets its own action button whose input ID is
#' `paste0(inputId, "_", slug)`, where `slug` is the header in lowercase with
#' each run of characters other than letters and numbers replaced by `_` and
#' any leading or trailing `_` removed. For example, with `inputId = "sumID"`
#' the "Date of birth" row sets `input$sumID_date_of_birth`, which counts its
#' clicks like [shiny::actionButton()]. Headers must give unique slugs. Each
#' button also has visually hidden text holding the header as written, so
#' screen readers announce, for example, "Change Date of birth" rather than a
#' bare "Change".
#' @param border set if the table should have borders. Default set
#' to `TRUE`
#' @return a summary list table HTML shiny tag object
#' @family Govstyle feedback types
#' @export
#' @examples
#' # Create an example dataset
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
#'     service_name = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
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
#'   output$changed <- shiny::renderText({
#'     shiny::req(input$sumID_name)
#'     "Change name clicked"
#'   })
#' }
#' if (interactive()) shinyApp(ui = ui, server = server)
gov_summary <- function(
  inputId, # nolint
  headers,
  info,
  action = FALSE,
  border = TRUE
) {
  if (border) {
    border_class <- "govuk-summary-list"
  } else {
    border_class <- "govuk-summary-list govuk-summary-list--no-border"
  }

  if (action) {
    action_ids <- summary_action_ids(inputId, headers)
  } else {
    action_ids <- rep(NA_character_, length(headers))
  }

  summary_list <- shiny::tags$dl(
    class = border_class,
    id = inputId,
    Map(
      function(x, y, z) {
        shiny::tags$div(
          class = "govuk-summary-list__row",
          shiny::tags$dt(
            class = "govuk-summary-list__key",
            x
          ),
          shiny::tags$dd(
            class = "govuk-summary-list__value",
            as_govuk_html(y)
          ),
          if (action) {
            shiny::tags$dd(
              class = "govuk-summary-list__actions",
              shiny::tags$button(
                type = "button",
                id = z,
                class = "govuk-link action-button",
                `data-val` = shiny::restoreInput(id = z, default = NULL),
                "Change",
                shiny::tags$span(
                  class = "govuk-visually-hidden",
                  paste0(" ", x)
                )
              )
            )
          }
        )
      },
      x = headers,
      y = info,
      z = action_ids
    )
  )
  attachDependency(summary_list)
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
