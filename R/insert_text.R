#' Insert Text Function
#'
#' This function loads the insert text component to display additional
#' information in a special format.
#' @param inputId The input slot that will be used to access the value
#' @param content Content to display on the insert. Accepts a plain character
#' string, or `shiny` tag objects such as `shiny::tags$b("Bold")` or a
#' `shiny::tagList()`.
#' @param text `r lifecycle::badge("deprecated")` Use `content` instead
#' @return a insert text HTML shiny tag object
#' @family Govstyle feedback types
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     shinyGovstyle::insert_text(
#'       inputId = "note",
#'       content = paste(
#'         "It can take up to 8 weeks to register a lasting power of",
#'         "attorney if there are no mistakes in the application."
#'       )
#'     ),
#'     shinyGovstyle::insert_text(
#'       inputId = "note-rich",
#'       content = shiny::tagList(
#'         shiny::tags$b("Important: "),
#'         "you can also pass tag objects."
#'       )
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
insert_text <- # nolint
  function(
    inputId, # nolint
    content,
    text = lifecycle::deprecated()
  ) {
    if (lifecycle::is_present(text)) {
      lifecycle::deprecate_warn(
        when = "0.3.0",
        what = "insert_text(text)",
        with = "insert_text(content)"
      )
      if (!missing(content)) {
        stop(
          "Supply only one of `content` or the deprecated `text`, not both.",
          call. = FALSE
        )
      }
      content <- text
    }
    if (missing(content)) {
      stop("`content` is required.", call. = FALSE)
    }

    gov_insert <- shiny::tags$div(
      as_govuk_html(content),
      id = inputId,
      class = "govuk-inset-text"
    )
    attachDependency(gov_insert)
  }
