function(input, output, session) {
  # Module servers ============================================================
  select_types <- mod_select_types_server("select_types")
  text_types <- mod_text_types_server("text_types")
  mod_action_types_server("action_types")
  mod_tables_tabs_server("tables_tabs")

  # download_radios is itself a Shiny module and must be called at the top
  # level so its namespace matches the plain IDs rendered by download_radios()
  shinyGovstyle::download_radios_handler(
    file_name = "example_file",
    file_contents = data.frame(x = c(1, 2, 3), y = c(4, 5, 6))
  )

  # Service navigation link → tab panel wiring ================================
  shinyGovstyle::service_navigation_server(
    session,
    tabset_id = "tab-container",
    link_to_panel = c(
      sn_select_types = "select_types",
      sn_text_types = "text_types",
      sn_action_types = "action_types",
      sn_tables_tabs = "tables_tabs_and_accordions",
      sn_feedback_types = "feedback_types",
      sn_cookies = "panel-cookies"
    )
  )

  # Tab nav - button-driven (next / back cross module boundaries) =============
  shiny::observeEvent(
    select_types$next_page(),
    shinyGovstyle::navigate_to(
      session,
      "tab-container",
      "sn_text_types",
      panel = "text_types"
    ),
    ignoreInit = TRUE
  )

  shiny::observeEvent(
    text_types$prev_page(),
    shinyGovstyle::navigate_to(
      session,
      "tab-container",
      "sn_select_types",
      panel = "select_types"
    ),
    ignoreInit = TRUE
  )

  # Cookie banner events ======================================================
  shiny::observeEvent(input$cookieLink, {
    shinyGovstyle::navigate_to(
      session,
      "tab-container",
      "sn_cookies",
      panel = "panel-cookies"
    )
  })

  shiny::observeEvent(
    input$cookies_footer_link,
    shinyGovstyle::navigate_to(
      session,
      "tab-container",
      "sn_cookies",
      panel = "panel-cookies"
    ),
    ignoreInit = TRUE
  )

  shiny::observeEvent(input$cookieAccept, {
    shinyjs::show(id = "cookieAcceptDiv")
    shinyjs::hide(id = "cookieMain")
  })

  shiny::observeEvent(input$cookieReject, {
    shinyjs::show(id = "cookieRejectDiv")
    shinyjs::hide(id = "cookieMain")
  })

  shiny::observeEvent(input$hideAccept, {
    shinyjs::toggle(id = "cookieDiv")
  })

  shiny::observeEvent(input$hideReject, {
    shinyjs::toggle(id = "cookieDiv")
  })
} # end of server
