#' Create a GOV.UK Service Navigation Layout for Shiny
#'
#' This function generates a GOV.UK style service navigation bar, suitable for use in Shiny applications.
#' It uses HTML markup based on the GOV.UK Design System and is designed to work with hidden panels
#' (e.g., using `bslib::hidden()` or `shiny::conditionalPanel()`) that are shown/hidden when navigation links are clicked.
#'
#' @param service_name Character. The name of the service to display.
#' @param nav_items A named list. Each element name is the navigation label, and the value is a list with:
#'   \itemize{
#'     \item \code{panel_id}: The id of the panel to show when clicked.
#'     \item \code{active}: Logical, whether this item is active on load.
#'     \item \code{href}: Optional, a URL to link to (default is "#").
#'   }
#' @param id Character. The id for the navigation list (default "navigation").
#'
#' @return HTML for the navigation bar (as `shiny::tagList`).
#' @export
#'
#' @examples
#' service_navigation(
#'   service_name = "Service name",
#'   nav_items = list(
#'     "Navigation item 1" = list(panel_id = "panel1", active = FALSE),
#'     "Navigation item 2" = list(panel_id = "panel2", active = TRUE),
#'     "Navigation item 3" = list(panel_id = "panel3", active = FALSE)
#'   )
#' )
service_navigation <- function(service_name, nav_items, id = "navigation") {
  # Helper to create each nav item
  nav_item_tag <- function(label, panel_id, active = FALSE, href = "#") {
    item_class <- "govuk-service-navigation__item"
    if (active) {
      item_class <- paste(item_class, "govuk-service-navigation__item--active")
    }
    link_tag <- if (active) {
      shiny$tags$a(
        class = "govuk-service-navigation__link",
        href = href,
        `aria-current` = "true",
        onclick = sprintf(
          "$('.govuk-service-navigation__item').removeClass('govuk-service-navigation__item--active'); $(this).parent().addClass('govuk-service-navigation__item--active'); $('.govuk-panel').hide(); $('#%s').show(); return false;",
          panel_id
        ),
        shiny$tags$strong(
          class = "govuk-service-navigation__active-fallback",
          label
        )
      )
    } else {
      shiny$tags$a(
        class = "govuk-service-navigation__link",
        href = href,
        onclick = sprintf(
          "$('.govuk-service-navigation__item').removeClass('govuk-service-navigation__item--active'); $(this).parent().addClass('govuk-service-navigation__item--active'); $('.govuk-panel').hide(); $('#%s').show(); return false;",
          panel_id
        ),
        label
      )
    }
    shiny$tags$li(class = item_class, link_tag)
  }

  # Build nav items
  nav_list <- lapply(names(nav_items), function(label) {
    item <- nav_items[[label]]
    nav_item_tag(
      label = label,
      panel_id = item$panel_id,
      active = isTRUE(item$active),
      href = item$href %||% "#"
    )
  })

  # Main navigation HTML
  shiny$tags$section(
    `aria-label` = "Service information",
    class = "govuk-service-navigation",
    `data-module` = "govuk-service-navigation",
    shiny$tags$div(
      class = "govuk-width-container",
      shiny$tags$div(
        class = "govuk-service-navigation__container",
        shiny$tags$span(
          class = "govuk-service-navigation__service-name",
          shiny$tags$a(
            href = "#",
            class = "govuk-service-navigation__link",
            service_name
          )
        ),
        shiny$tags$nav(
          `aria-label` = "Menu",
          class = "govuk-service-navigation__wrapper",
          shiny$tags$button(
            type = "button",
            class = "govuk-service-navigation__toggle govuk-js-service-navigation-toggle",
            `aria-controls` = id,
            hidden = NA
          ),
          shiny$tags$ul(
            class = "govuk-service-navigation__list",
            id = id,
            nav_list
          )
        )
      )
    )
  )
}
