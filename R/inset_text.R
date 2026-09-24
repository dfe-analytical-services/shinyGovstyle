#' Inset text
#'
#' This function creates the GOV.UK
#' [inset text](https://design-system.service.gov.uk/components/inset-text/)
#' component, used to differentiate a block of text from the content that
#' surrounds it, for example a quote, example, or additional information
#' about the page.
#' @inheritParams id_arg
#' @param content Content to display in the inset. Accepts a plain character
#' string, or `shiny` tag objects such as `shiny::tags$b("Bold")` or a
#' `shiny::tagList()`.
#' @return an inset text HTML shiny tag object
#' @family Govstyle feedback types
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::gov_row(
#'       shinyGovstyle::gov_box(
#'         size = "two-thirds",
#'         shinyGovstyle::inset_text(
#'           inputId = "note",
#'           content = paste(
#'             "It can take up to 8 weeks to register a lasting power of",
#'             "attorney if there are no mistakes in the application."
#'           )
#'         ),
#'         shinyGovstyle::inset_text(
#'           inputId = "note-rich",
#'           content = shiny::tagList(
#'             shiny::tags$b("Important: "),
#'             "you can also pass tag objects."
#'           )
#'         )
#'       )
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
inset_text <- function(
  inputId, # nolint
  content
) {
  if (missing(content)) {
    stop("`content` is required.", call. = FALSE)
  }

  gov_inset <- shiny::tags$div(
    as_govuk_html(content),
    id = inputId,
    class = "govuk-inset-text"
  )
  attachDependency(gov_inset)
}
