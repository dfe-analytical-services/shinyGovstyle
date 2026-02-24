#' Tag Function
#'
#' This function creates a tag.
#' @param inputId The Id to access the tag
#' @param text The text in the tag
#' @param colour The colour of the tag. Default is navy. Other options are
#' grey, green, turquoise, blue, purple, pink, red, orange and yellow
#' @return a tag HTML shiny tag object
#' @keywords tag
#' @family Govstyle feedback types
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     shinyGovstyle::tag_Input("tag1", "Complete"),
#'     shinyGovstyle::tag_Input("tag2", "Incomplete", "red")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
tag_Input <- # nolint
  function(
    inputId, # nolint
    text,
    colour = "navy"
  ) {
    #check for deprecated colours
    if (colour == "light-blue") {
      warning(
        "'light-blue' is no longer a supported colour. Please select an alternative from:
      'grey', 'purple', 'turquoise', 'blue', 'yellow', 'orange', 'red', 'pink', or 'green'."
      )
    }

    class_colour <- "govuk-tag"
    if (colour != "navy") {
      class_colour <- paste0("govuk-tag govuk-tag--", colour)
    }

    gov_tag <- shiny::tags$strong(
      id = inputId,
      class = class_colour,
      text
    )
    attachDependency(gov_tag)
  }
