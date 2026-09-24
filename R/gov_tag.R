#' Tag
#'
#' This function creates the GOV.UK
#' [tag](https://design-system.service.gov.uk/components/tag/) component, used
#' to show users the status of something.
#' @inheritParams id_arg
#' @param text The text in the tag
#' @param colour The colour of the tag. Default is navy. Other options are
#' grey, green, teal, blue, purple, magenta, red, orange and yellow
#' @return a tag HTML shiny tag object
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
#'         shinyGovstyle::gov_tag("tag1", "Complete"),
#'         shinyGovstyle::gov_tag("tag2", "Incomplete", "red")
#'       )
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
gov_tag <- function(
  inputId, # nolint
  text,
  colour = "navy"
) {
  #check for deprecated colours
  if (colour == "light-blue") {
    warning(
      "'light-blue' is no longer a supported colour.
        Please select an alternative from:
       'navy', 'grey', 'purple', 'teal', 'blue', 'yellow',
        'orange', 'red', 'magenta', or 'green'."
    )
  }
  if (colour == "turquoise") {
    warning(
      "'turquoise' is no longer a supported colour.
      Please select an alternative from:
      'grey', 'purple', 'teal', 'blue', 'yellow',
      'orange', 'red', 'magenta', or 'green'."
    )
  }
  if (colour == "pink") {
    warning(
      "'pink' is no longer a supported colour.
      Please select an alternative from:
      'grey', 'purple', 'teal', 'blue', 'yellow',
      'orange', 'red', 'magenta', or 'green'."
    )
  }

  class_colour <- "govuk-tag"
  if (colour != "navy") {
    class_colour <- paste0("govuk-tag govuk-tag--", colour)
  }

  tag_html <- shiny::tags$strong(
    id = inputId,
    class = class_colour,
    text
  )
  attachDependency(tag_html)
}
