#' Footer Function
#'
#' This function create a gov style footer for your page
#'
#' You can add actionLinks as links in the footer through using the links_list
#' argument.
#'
#' @param full Whenever you want to have blank footer or official gov version.
#' Defaults to \code{FALSE}
#' @param links A vector of actionLinks to be added to the footer, inputIDs
#' are auto-generated and are the snake case version of the link text, e.g.
#' "Accessibility Statement" will have an inputID of accessibility_statement
#' @return a footer html shiny object
#' @keywords footer
#' @export
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo = "shinyGovstyle/images/moj_logo.png"
#'     ),
#'     shinyGovstyle::banner(
#'       inputId = "banner", type = "beta", "This is a new service"
#'     ),
#'     tags$br(),
#'     tags$br(),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'
#'   shinyApp(ui = ui, server = server)
#' }
#'
#' footer(links = c("Accessibility statement", "Cookies"))
footer <- function(full = FALSE, links = NULL) {
  # Validation on the links input
  if (!is.null(links)) {
    if (!is.vector(links)) {
      stop("links must be a vector")
    }

    footer_link <- function(link_text) {
      shiny::tags$li(
        class = "govuk-footer__inline-list-item",
        shiny::actionLink(
          class = "govuk-link govuk-footer__link",
          inputId = tolower(gsub(" ", "_", link_text)),
          label = link_text
        )
      )
    }
  }

  # The HTML div to be returned
  govFooter <- shiny::tags$footer(
    class = "govuk-footer ",
    role = "contentinfo",
    shiny::div(
      class = "govuk-width-container ",
      shiny::div(
        if (full == FALSE) {
          shiny::div(
            class = "govuk-footer__meta-item govuk-footer__meta-item--grow",
            if (!is.null(links)) {
              shiny::div(
                # Set a visually hidden title for accessibility
                shiny::h2(
                  class = "govuk-visually-hidden",
                  "Support links"
                ),
                shiny::tags$ul(
                  class = "govuk-footer__inline-list",

                  # Generate as many links as needed
                  lapply(links, footer_link)
                )
              )
            }
          )
        } else {
          shiny::tagList(
            shiny::div(
              class = "govuk-footer__meta-item govuk-footer__meta-item--grow",
              if (!is.null(links)) {
                shiny::div(
                  # Set a visually hidden title for accessibility
                  shiny::h2(
                    class = "govuk-visually-hidden",
                    "Support links"
                  ),
                  shiny::tags$ul(
                    class = "govuk-footer__inline-list",

                    # Generate as many links as needed
                    lapply(links, footer_link)
                  )
                )
              },
              shiny::tag("svg", list(
                role = "presentation",
                focusable = "false",
                class = "govuk-footer__licence-logo",
                xmlns = "http://www.w3.org/2000/svg",
                viewbox = "0 0 483.2 195.7",
                height = "17",
                width = "41",
                shiny::tag("path", list(
                  fill = "currentColor",
                  d = paste0(
                    "M421.5 142.8V.1l-50.7 32.3v161.1h112.4v-50.7",
                    "zm-122.3-9.6A47.12 47.12 0 0 1 221 97.8c0-26 21",
                    ".1-47.1 47.1-47.1 16.7 0 31.4 8.7 39.7 21.8l42.7",
                    "-27.2A97.63 97.63 0 0 0 268.1 0c-36.5 0-68.3 20.1",
                    "-85.1 49.7A98 98 0 0 0 97.8 0C43.9 0 0 43.9 0 97",
                    ".8s43.9 97.8 97.8 97.8c36.5 0 68.3-20.1 85.1-49.",
                    "7a97.76 97.76 0 0 0 149.6 25.4l19.4 22.2h3v-87.8",
                    "h-80l24.3 27.5zM97.8 145c-26 0-47.1-21.1-47.1-47",
                    ".1s21.1-47.1 47.1-47.1 47.2 21 47.2 47S123.8 145",
                    " 97.8 145"
                  )
                ))
              )),
              shiny::tags$span(
                class = "govuk-footer__licence-description",
                "All content is available under the",
                shiny::tags$a(
                  class = "govuk-footer__link",
                  href = "https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/",
                  rel = "license",
                  "Open Government Licence v3.0"
                ),
                ", except where otherwise stated"
              )
            ),
            shiny::tags$div(
              class = "govuk-footer__meta-item",
              shiny::tags$a(
                class = "govuk-footer__link govuk-footer__copyright-logo",
                href = "https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/",
                "\u00A9 Crown copyright"
              )
            )
          )
        }
      )
    )
  )
  attachDependency(govFooter)
}
