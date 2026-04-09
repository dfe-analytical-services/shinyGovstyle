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

  # Tab nav - button-driven (next / back cross module boundaries) =============
  shiny::observeEvent(
    select_types$next_page(),
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "text_types"
      )
      update_service_navigation(session, "sn_text_types")
    },
    ignoreInit = TRUE
  )

  shiny::observeEvent(
    text_types$prev_page(),
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "select_types"
      )
      update_service_navigation(session, "sn_select_types")
    },
    ignoreInit = TRUE
  )

  # Service navigation link observers =========================================
  shiny::observeEvent(
    input$sn_select_types,
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "select_types"
      )
    },
    ignoreInit = TRUE
  )

  shiny::observeEvent(
    input$sn_text_types,
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "text_types"
      )
    },
    ignoreInit = TRUE
  )

  shiny::observeEvent(
    input$sn_action_types,
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "action_types"
      )
    },
    ignoreInit = TRUE
  )

  shiny::observeEvent(
    input$sn_tables_tabs,
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "tables_tabs_and_accordions"
      )
    },
    ignoreInit = TRUE
  )

  shiny::observeEvent(
    input$sn_feedback_types,
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "feedback_types"
      )
    },
    ignoreInit = TRUE
  )

  shiny::observeEvent(
    input$sn_cookies,
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "panel-cookies"
      )
    },
    ignoreInit = TRUE
  )

  # Cookie banner events ======================================================
  shiny::observeEvent(input$cookieLink, {
    shiny::updateTabsetPanel(
      session,
      "tab-container",
      selected = "panel-cookies"
    )
    update_service_navigation(session, "sn_cookies")
  })

  shiny::observeEvent(
    input$cookies_footer_link,
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "panel-cookies"
      )
      update_service_navigation(session, "sn_cookies")
    },
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
