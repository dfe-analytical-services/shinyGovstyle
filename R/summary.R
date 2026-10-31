#' Summary list
#'
#' This function creates a GOV.UK summary list: a set of key and value pairs.
#' @inheritParams id_arg
#' @param headers character vector of row headers (the keys)
#' @param info Summary information values for the table. Each value accepts a
#' plain character string, or `shiny` tag objects such as
#' `shiny::tags$b("Bold")` or a `shiny::tagList()`. Pass a list rather than a
#' character vector to mix tag and string values.
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
  if (border) {
    border_class <- "govuk-summary-list"
  } else {
    border_class <- "govuk-summary-list govuk-summary-list--no-border"
  }

  summary_list <- shiny::tags$dl(
    class = border_class,
    id = inputId,
    Map(
      function(x, y) {
        shiny::tags$div(
          class = "govuk-summary-list__row",
          shiny::tags$dt(
            class = "govuk-summary-list__key",
            x
          ),
          shiny::tags$dd(
            class = "govuk-summary-list__value",
            as_govuk_html(y)
          )
        )
      },
      x = headers,
      y = info
    )
  )
  attachDependency(summary_list)
}
