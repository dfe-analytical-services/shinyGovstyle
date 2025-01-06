#' Accordion Function
#'
#' This function inserts a accordion
#' @param inputId Input id for the accordion
#' @param titles Add the titles for the accordion
#' @param descriptions Add the main text for the accordion
#' @return an accordion html shiny object
#' @keywords accordion
#' @export
#' @examples
#' if (interactive()) {
#'
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::banner(
#'       inputId = "banner", type = "beta", 'This is a new service'),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'     accordion(
#'       "acc1",
#'       c("Writing well for the web",
#'         "Writing well for specialists",
#'         "Know your audience",
#'         "How people read"
#'        ),
#'       c("This is the content for Writing well for the web.",
#'         "This is the content for Writing well for specialists.",
#'         "This is the content for Know your audience.",
#'         "This is the content for How people read."
#'        ))),
#'
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'
#'   shinyApp(ui = ui, server = server)
#' }

accordion <- function(inputId, titles, descriptions){

  count_array <- seq(length(titles))

  accordion_div <-
    shiny::tags$div(
      class = "govuk-accordion js-enabled",
      `data-module` = "govuk-accordion",
      id = inputId,
      shiny::tags$div(
        class = "govuk-accordion__controls",
        shiny::tags$button(
          class = "govuk-accordion__show-all",
          `aria-expanded` = "false",
          shiny::tags$span(
            id="show-all-chevron",
            class=paste(
              "govuk-accordion-nav__chevron",
              "govuk-accordion-nav__chevron--down"),
          ),
          shiny::tags$span(
            class = "govuk-accordion__show-all-text",
            "Show all sections"
          )
        )
      ),
      Map(function(x, y, z) {

        if(z < 10){
          z_str <- paste0("0", z)
        } else {
          z_str <- paste0(z)
        }

        shiny::tags$div(
          class="govuk-accordion__section",
          shiny::tags$div(
            class="govuk-accordion__section-header",
            shiny::tags$h2(
              class="govuk-accordion__section-header",
              shiny::tags$button(
                class = "govuk-accordion__section-button",
                id = paste0("accordion-default-heading-", z_str),
                name = paste0("accordion-default-heading-", z_str),
                shiny::tags$span(
                  class = "govuk-accordion__section-heading-text",
                  shiny::tags$span(
                    class = "govuk-accordion__section-heading-text-focus",
                    x
                  )
                ),
                shiny::tags$span(
                  class = paste(
                    "govuk-visually-hidden",
                    "govuk-accordion__section-heading-divider")
                ),
                shiny::tags$span(
                  class = "govuk-accordion__section-toggle",
                  shiny::tags$span(
                    class = "govuk-accordion__section-toggle-focus",
                    shiny::tags$span(
                      class = paste(
                        "govuk-accordion-nav__chevron",
                        "govuk-accordion-nav__chevron--down")
                    ),
                    shiny::tags$span(
                      class = "govuk-accordion__section-toggle-text",
                      "Show",
                      shiny::tags$span(
                        class = "govuk-visually-hidden",
                        "this section"
                      )
                    )
                  )
                )
              )
            )
          ),
          shiny::tags$div(
            id = "accordion-default-content-1",
            class="govuk-accordion__section-content",
            `aria-labelledby` = paste0("accordion-default-heading-", z_str),
            shiny::tags$p(
              class = "govuk-body",
              y
            )
          )
        )}, x = titles, y = descriptions, z = count_array
    )
  )
  attachDependency(accordion_div, "accordion")
}


