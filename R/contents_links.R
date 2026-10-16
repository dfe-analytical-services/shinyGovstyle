#' Subcontents links function
#' This function is used internally within contents_link to create links
#' to headings within pages.
#' @param subcontents_text_list vector of link text for subcontents
#' @param subcontents_id_list vector of link ids for subcontents. Pass NAs
#' for automatic matching to Id in `heading_text()`
#' @return an ordered list HTML shiny tag object
#' @family Govstyle navigation
#' @keywords internal
#' @noRd
subcontents_links <- function(subcontents_text_list, subcontents_id_list) {
  if (!missing(subcontents_id_list)) {
    # check if custom link_id_list is of equal length to links list
    if (length(subcontents_text_list) != length(subcontents_id_list)) {
      message(
        "`subcontents_id_list` must be equal ",
        "length to `subcontents_text_list`"
      )
    }
  }

  # create sidelink
  create_sidelink <- function(link_text, link_id) {
    # match id created in shinygovstyle::heading_text
    # if custom id not specified
    if (is.na(link_id)) {
      link_id <- clean_heading_text(link_text)
    }

    shiny::tags$li(
      "\u2014 ",
      shiny::tags$a(
        class = "govuk-link--no-visited-state",
        link_text,
        href = stringr::str_c("\u0023", link_id)
      )
    )
  }

  # create <li></li> tags
  list_tags <- purrr::map2(
    subcontents_text_list,
    subcontents_id_list,
    create_sidelink
  )

  # return <ol> output
  shiny::tags$ol(class = "govuk-subcontents", list_tags)
}

#' Contents link function
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function creates an action link to nav between tabs and optionally
#' link to subcontents headers.
#'
#' `contents_link()` was deprecated in shinyGovstyle 0.2.0 and will be removed
#' in shinyGovstyle 1.0.0. For multi-page layouts, [service_navigation()] is
#' the recommended approach: it gives users the GOV.UK service navigation bar
#' for moving between pages (tab panels), with [service_navigation_server()]
#' and [navigate_to()] to switch panels from the server.
#'
#' `service_navigation()` is not a drop-in replacement. It has no equivalent
#' of the subcontents links, and it does not create links to headings within a
#' page. For those, use ordinary links to heading ids, e.g.
#' `heading_text("Methodology", id = "methodology")` with
#' `shiny::tags$a(href = "#methodology", class = "govuk-link", "Methodology")`.
#'
#' @param link_text vector of link text for contents
#' @param input_id contents button Id
#' @param subcontents_text_list vector of link text for subcontents
#' @param subcontents_id_list vector of link Ids for subcontents. If missing
#' automatically matches to Id in `heading_text()`
#' @return an action button HTML shiny tag object
#' @keywords internal
#' @export
#' @examples
#' # Multi-page layout: service_navigation() moves between tab panels
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(org_name = "Example", service_name = "My service"),
#'   shinyGovstyle::service_navigation(
#'     c("Summary" = "summary", "Methodology" = "methodology")
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     bslib::navset_hidden(
#'       id = "pages",
#'       bslib::nav_panel_hidden(
#'         "summary",
#'         shinyGovstyle::heading_text("Summary", size = "l"),
#'         # In-page anchor links are ordinary links to heading ids
#'         shiny::tags$a(
#'           href = "#key-findings",
#'           class = "govuk-link",
#'           "Key findings"
#'         ),
#'         shinyGovstyle::heading_text(
#'           "Key findings",
#'           size = "m",
#'           level = 2,
#'           id = "key-findings"
#'         )
#'       ),
#'       bslib::nav_panel_hidden(
#'         "methodology",
#'         shinyGovstyle::heading_text("Methodology", size = "l")
#'       )
#'     )
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   shinyGovstyle::service_navigation_server(
#'     session,
#'     tabset_id = "pages",
#'     link_to_panel = c("summary", "methodology")
#'   )
#' }
#'
#' if (interactive()) shiny::shinyApp(ui = ui, server = server)
contents_link <- function(
  link_text,
  input_id,
  subcontents_text_list,
  subcontents_id_list
) {
  lifecycle::deprecate_warn(
    when = "0.2.0",
    what = "contents_link()",
    details = c(
      i = paste(
        "For multi-page layouts, `service_navigation()` is the recommended",
        "approach, with `service_navigation_server()` to switch tab panels."
      ),
      i = paste(
        "It is not a drop-in replacement: for links to headings on the same",
        "page, use ordinary links to heading ids, e.g.",
        "`shiny::tags$a(href = \"#methods\", \"Methods\")` with",
        "`heading_text(id = \"methods\")`."
      ),
      i = "`contents_link()` will be removed in shinyGovstyle 1.0.0."
    )
  )

  if (
    missing(subcontents_id_list) &&
      !missing(subcontents_text_list)
  ) {
    subcontents_id_list <- rep(NA, length(subcontents_text_list))
  }

  contents_div <- shiny::tags$div(
    class = "govuk-contents",
    shiny::actionLink(
      class = "govuk-contents__link govuk-link--no-visited-state",
      inputId = input_id,
      label = link_text
    ),

    # add subcontents links if required
    if (!missing(subcontents_text_list)) {
      subcontents_links(subcontents_text_list, subcontents_id_list)
    }
  )

  attachDependency(contents_div, "contents_link")
}
