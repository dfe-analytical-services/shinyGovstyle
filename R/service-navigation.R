#' Service navigation
#'
#' @description
#' Service navigation component consistent with the
#' [GDS service navigation](https://design-system.service.gov.uk/components/service-navigation/)
#' (pre-June 2025).
#'
#' @param links A vector of actionLinks to be added to the service navigation.
#' inputIDs are auto-generated and are the snake case version of the link text, e.g.
#' "Overview page" will have an inputID of overview_page. Can also be provided as a named
#' vector, in which case the vector names will be used as the page titles and the vector values
#' will be used as the individual inputIDs.
#'
#' @returns Shiny tag object
#' @export
#'
#' @examples
#' if (interactive()) {
#'   ui <- shiny::fluidPage(
#'     shinyGovstyle::header("Title", "Secondary heading"),
#'     shinyGovstyle::service_navigation(
#'        c("Summary data", "Detailed stats 1", "User guide")
#'     ),
#'     bslib::navset_hidden(
#'        id = "main_panels",
#'        bslib::nav_panel(
#'          "summary_data",
#'          shiny::tags$h2("Summary data")
#'        ),
#'        bslib::nav_panel(
#'          "detailed_stats_1",
#'          shiny::tags$h2("Detailed stats 1")
#'        ),
#'        bslib::nav_panel(
#'          "user_guide",
#'          shiny::tags$h2("User guide")
#'        )
#'      ),
#'      shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {
#'       observeEvent(input$summary_data, bslib::nav_select("main_panels", "summary_data"))
#'       observeEvent(input$detailed_stats_1, bslib::nav_select("main_panels", "detailed_stats_1"))
#'       observeEvent(input$user_guide, bslib::nav_select("main_panels", "user_guide"))
#'   }
#'
#'   shiny::shinyApp(ui = ui, server = server)
#' }
service_navigation <- function(
  links
) {
  if (is.null(names(links))) {
    link_names <- links
  } else {
    link_names <- names(links)
    link_names[link_names == ""] <- links[link_names == ""]
  }
  navigation <- shiny::tags$div(
    class = "govuk-service-navigation",
    `data-module` = "govuk-service-navigation",
    shiny::tags$div(
      class = "govuk-width-container",
      shiny::tags$div(
        class = "govuk-service-navigation__container",
        shiny::tags$nav(
          `aria-label` = "Menu",
          class = "govuk-service-navigation__wrapper",
          shiny::tags$button(
            type = "button",
            class = "govuk-service-navigation__toggle govuk-js-service-navigation-toggle",
            `aria-controls` = "navigation",
            hidden = TRUE,
            "Menu"
          ),
          shiny::tags$ul(
            class = "govuk-service-navigation__list",
            id = "navigation",
            mapply(
              service_nav_link,
              links,
              link_names,
              SIMPLIFY = FALSE,
              USE.NAMES = FALSE
            )
          )
        )
      )
    )
  )
  dependency <- htmltools::htmlDependency(
    name = "service-navigation",
    version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "service-navigation.css"
  )

  # Return the link with the CSS attached
  return(
    htmltools::attachDependencies(
      navigation,
      dependency,
      append = TRUE
    )
  )
}


#' Create a service navigation link for use in `service_navigation()` function
#'
#' @param link Character string containing either link text or url
#' @param link_name Name of a link where a URL has been provided in link_text
#'
#' @returns HTML tag list item
#'
#' @keywords internal
#' @examples
#' # Internal (i.e. within dashboard) link
#' shinyGovstyle:::service_nav_link("Cookie statement")
#' # Named internal link
#' shinyGovstyle:::service_nav_link("cookie_statement", "Cookies")
service_nav_link <- function(
  link,
  link_name = NULL
) {
  if (is.null(link_name)) {
    warning("Link name provided is NULL for ", link)
    link_name <- link
  }
  shiny::tags$li(
    class = "govuk-service-navigation__item",
    shiny::actionLink(
      class = "govuk-service-navigation__link",
      inputId = tolower(gsub(" ", "_", link)),
      label = link_name
    )
  )
}
