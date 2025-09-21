#' Tabs Function
#'
#' This function creates a tabs based table.  It requires a single dataframe
#' with a grouping variable
#' @param inputId The id to access the summary list
#' @param headers input for the row headers value
#' @param info summary information values for the table
#' @param action whenever a change link is needed.  sets input to the value of
#' the headers using lowercase and with underscore to replace gaps. Default
#' set to `FALSE`
#' @param border set if the table should have borders.  Default set
#' to `TRUE`
#' @return a summary list table html shiny object.
#' @keywords summary list
#' @export
#' @examples
#' if (interactive()) {
#'
#'   # Create an example dataset
#'   headers <- c(
#'     "Name",
#'     "Date of birth",
#'     "Contact information",
#'     "Contact details"
#'   )
#'   info <- c(
#'     "Sarah Philips",
#'     "5 January 1978",
#'     "72 Guild Street <br> London <br> SE23 6FH",
#'     "07700 900457 <br> sarah.phillips@example.com")
#'
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       shinyGovstyle::gov_summary("sumID", headers, info, action = FALSE)),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }
#'
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

  shiny::tags$dl(
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
            shiny::HTML(y)
          ),
          if (action) {
            shiny::tags$dd(
              class = "govuk-summary-list__actions",
              shiny::tags$button(
                "Change",
                id = z,
                class = "govuk-link action-button",
                `data-val` = shiny::restoreInput(id = z, default = NULL)
              )
            )
          }
        )
      },
      x = headers,
      y = info,
      z = action
    )
  )
}
