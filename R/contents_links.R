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
#' `r lifecycle::badge('experimental')`
#'
#' This function creates an action link to nav between tabs and optionally
#' link to subcontents headers.
#'
#' This is experimental and may change in future.
#'
#' @param link_text vector of link text for contents
#' @param input_id contents button Id
#' @param subcontents_text_list vector of link text for subcontents
#' @param subcontents_id_list vector of link Ids for subcontents. If missing
#' automatically matches to Id in `heading_text()`
#' @return an action button HTML shiny tag object
#' @export
#' @family Govstyle navigation
#' @examples
#' ui <- shiny::fluidPage(
#'   gov_row(
#'     # Nav columns
#'     shiny::column(
#'       width = 3,
#'       id = "nav", # DO NOT REMOVE ID
#'
#'       # Contents box
#'       shiny::tags$div(
#'         id = "govuk-contents-box", # DO NOT REMOVE ID
#'         class = "govuk-contents-box", # DO NOT REMOVE CLASS
#'
#'         shiny::tags$h2("Contents"),
#'
#'         # Text types tab
#'         contents_link(
#'           "Text Types",
#'           "text_types_button",
#'           subcontents_text_list = c(
#'             "date_Input",
#'             "text_Input",
#'             "text_area_Input",
#'             "button_Input"
#'           ),
#'           subcontents_id_list = c(NA, NA, NA, "button_input_text_types")
#'         ),
#'
#'         # Tables tabs and accordions tab
#'         contents_link(
#'           "Tables, tabs and accordions",
#'           "tables_tabs_and_accordions_button",
#'           subcontents_text_list = c(
#'             "govTable",
#'             "govTabs",
#'             "accordions",
#'             "button_Input"
#'           ),
#'           subcontents_id_list = c(
#'             NA,
#'             NA,
#'             NA,
#'             "button_input_tables_tabs_accordions"
#'           )
#'         ),
#'
#'         contents_link(
#'           "Cookies",
#'           "cookies_button"
#'         ),
#'       )
#'     ),
#'
#'     shiny::column(
#'       width = 9,
#'       id = "main_col", # DO NOT REMOVE ID
#'
#'       # Set up a nav panel so everything not on single page
#'       shiny::tabsetPanel(
#'         type = "hidden",
#'         id = "tab-container", # DO NOT REMOVE ID
#'
#'         shiny::tabPanel(
#'           "Text Types",
#'           value = "text_types",
#'           gov_layout(
#'             size = "two-thirds",
#'             backlink_Input("back1"),
#'             heading_text("Page 2", size = "l"),
#'             label_hint(
#'               "label2",
#'               paste(
#'                 "These are some examples of the",
#'                 "types of user text inputs that you can use"
#'               )
#'             ),
#'             heading_text("date_Input", size = "s"),
#'             date_Input(
#'               inputId = "date1",
#'               label = "What is your date of birth?",
#'               hint_label = "For example, 31 3 1980"
#'             ),
#'             heading_text("text_Input", size = "s"),
#'             text_Input(
#'               inputId = "txt1",
#'               label = "Event name"
#'             ),
#'             heading_text("text_area_Input", size = "s"),
#'             text_area_Input(
#'               inputId = "text_area1",
#'               label = "Can you provide more detail?",
#'               hint_label = paste(
#'                 "Do not include personal or financial",
#'                 "information, like your National Insurance",
#'                 "number or credit card details."
#'               )
#'             ),
#'             text_area_Input(
#'               inputId = "text_area2",
#'               label = "How are you today?",
#'               hint_label = "Leave blank to trigger error",
#'               error = TRUE,
#'               error_message = "Please do not leave blank",
#'               word_limit = 300
#'             ),
#'             heading_text(
#'               "button_Input",
#'               size = "s",
#'               id = "button_input_text_types"
#'             ),
#'             button_Input("btn2", "Go to next page"),
#'             button_Input(
#'               "btn3",
#'               "Check for errors",
#'               type = "warning"
#'             )
#'           )
#'         ),
#'
#'         shiny::tabPanel(
#'           "Tables, tabs and accordions",
#'           value = "tables_tabs_and_accordions",
#'           gov_layout(
#'             size = "two-thirds",
#'             backlink_Input("back2"),
#'             heading_text("Page 3", size = "l"),
#'             label_hint(
#'               "label3",
#'               paste(
#'                 "These are some examples of using tabs",
#'                 "type tables"
#'               )
#'             ),
#'             heading_text("govTable", size = "s"),
#'             heading_text("govTabs", size = "s"),
#'             heading_text("accordions", size = "s"),
#'             shinyGovstyle::accordion(
#'               "acc1",
#'               c(
#'                 "Writing well for the web",
#'                 "Writing well for specialists",
#'                 "Know your audience",
#'                 "How people read"
#'               ),
#'               c(
#'                 paste(
#'                   "This is the content for Writing well",
#'                   "for the web."
#'                 ),
#'                 paste(
#'                   "This is the content for Writing well",
#'                   "for specialists."
#'                 ),
#'                 paste(
#'                   "This is the content for",
#'                   "Know your audience."
#'                 ),
#'                 "This is the content for How people read."
#'               )
#'             ),
#'
#'             heading_text(
#'               "button_Input",
#'               size = "s",
#'               id = "button_input_tables_tabs_accordions"
#'             ),
#'             button_Input("btn4", "Go to next page"),
#'           )
#'         ),
#'
#'         #################### Create cookie panel #########
#'         shiny::tabPanel(
#'           "Cookies",
#'           value = "panel-cookies",
#'           gov_layout(
#'             size = "two-thirds",
#'             heading_text("Cookie page", size = "l"),
#'             label_hint(
#'               "label-cookies",
#'               "This an example cookie page"
#'             )
#'           )
#'         )
#'       )
#'     )
#'   ), # end of main_col
#'   footer(TRUE)
#' ) # end of gov_row
#'
#' server <- function(input, output, session) {
#'   # Tab nav
#'   shiny::observeEvent(input$back2, {
#'     shiny::updateTabsetPanel(
#'       session,
#'       "tab-container",
#'       selected = "text_types"
#'     )
#'   })
#'
#'   shiny::observeEvent(input$tables_tabs_and_accordions_button, {
#'     shiny::updateTabsetPanel(
#'       session,
#'       "tab-container",
#'       selected = "tables_tabs_and_accordions"
#'     )
#'   })
#'
#'   shiny::observeEvent(input$cookies_button, {
#'     shiny::updateTabsetPanel(
#'       session,
#'       "tab-container",
#'       selected = "panel-cookies"
#'     )
#'   })
#' } # end of server
#'
#' if (interactive()) shiny::shinyApp(ui = ui, server = server)
contents_link <- function(
  link_text,
  input_id,
  subcontents_text_list,
  subcontents_id_list
) {
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
