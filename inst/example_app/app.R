# Deployed at
# https://department-for-education.shinyapps.io/shinygovstyle-example-app/

# Dependencies ================================================================
library(shinyGovstyle)
library(bslib)

# Global variables ============================================================
months <- rep(c("January", "February", "March", "April", "May"), times = 2)
colours <- rep(c("Red", "Blue"), times = 5)
bikes <- c(85, 75, 165, 90, 80, 95, 85, 175, 100, 95)
vans <- c(150, 130, 180, 160, 140, 175, 135, 185, 155, 145)
buses <- c(200, 180, 220, 210, 190, 215, 185, 225, 205, 195)
example_data <- data.frame(months, colours, bikes, vans, buses)
example_data_short <- head(example_data, 5)
tabs <- c(
  rep("Past Day", 3),
  rep("Past Week", 3),
  rep("Past Month", 3),
  rep("Past Year", 3)
)
case_manager <- rep(c("David Francis", "Paul Farmer", "Rita Patel"), 4)
cases_open <- c(3, 1, 2, 24, 16, 24, 98, 122, 126, 1380, 1129, 1539)
cases_closed <- c(0, 0, 0, 18, 20, 27, 95, 131, 142, 1472, 1083, 1265)
data <- data.frame(tabs, case_manager, cases_open, cases_closed)

# UI ==========================================================================
ui = bslib::page_fluid(
  theme = bs_theme(version = 5),
  title = "ShinyGovstyle showcase",
  cookieBanner("shinyGovstyle showcase"),
  shinyjs::useShinyjs(),

  # Add custom CSS to head remove padding around page
  shiny::tags$head(
    shiny::tags$style(
      shiny::HTML(
        ".container-fluid { padding: 0; }"
      )
    )
  ),

  shinyGovstyle::skip_to_main(),
  header(
    "MoJ",
    "shinyGovstyle showcase",
    logo = "shinyGovstyle/images/moj_logo-1.png",
    logo_width = 66,
    logo_alt_text = "Ministry of Justice logo"
  ),
  banner(
    "banner",
    "Beta",
    paste0(
      'This is a new service \u002D your <a class="govuk-link" href=',
      '"https://github.com/dfe-analytical-services/shinyGovstyle/issues/new',
      '/choose">feedback</a> will help us to improve it.'
    )
  ),

  bslib::layout_column_wrap(
    style = css(grid_template_columns = "2fr 10fr"), # TODO

    shiny::tags$div(
      id = "nav", # TODO
      shiny::tags$div(
        id = "govuk-contents-box", # TODO
        class = "govuk-contents-box", # TODO
        style = "padding: 10px;",

        shiny::tags$h2("Contents"),

        contents_link(
          "Select Types",
          "select_types_button",
          subcontents_text_list = c(
            "radio_button_Input (inline)",
            "radio_button_Input (stacked)",
            "checkbox_Input",
            "select_Input",
            "file_Input",
            "button_Input"
          )
        ),

        contents_link(
          "Text Types",
          "text_types_button",
          subcontents_text_list = c(
            "date_Input",
            "text_Input",
            "text_area_Input",
            "gov_list"
          ),
          subcontents_id_list = c(
            NA,
            NA,
            NA,
            NA
          )
        ),

        contents_link(
          "Action Types",
          "action_types_button",
          subcontents_text_list = c(
            "external_link",
            "download_button",
            "download_link",
            "download_radios"
          )
        ),

        contents_link(
          "Tables, tabs and accordions",
          "tables_tabs_and_accordions_button",
          subcontents_text_list = c(
            "govTable",
            "govReactable",
            "govTabs",
            "button_Input",
            "accordions"
          ),
          subcontents_id_list = c(
            NA,
            NA,
            NA,
            "button_input_tables_tabs_accordions",
            NA
          )
        ),

        contents_link(
          "Feedback types",
          "feedback_types_button",
          subcontents_text_list = c(
            "tag_Input",
            "details",
            "insert_text",
            "warning_text",
            "value_box",
            "panel_output",
            "noti_banner",
            "gov_summary"
          )
        ),
        contents_link(
          "Cookies",
          "cookies_button"
        )
      )
    ),

    gov_main_layout(
      inputId = "main-col", # TODO
      shinyGovstyle::gov_text(
        paste0(
          "This example app showcases the components available in the",
          " latest development version of the shinyGovstyle package.",
          " The source code for the app can be found on the "
        ),
        shinyGovstyle::external_link(
          href = paste0(
            "https://github.com/dfe-analytical-services/shinyGovstyle/",
            "blob/main/inst/example_app/app.R"
          ),
          link_text = "main GitHub branch"
        ),
        "."
      )
    ),
  ),
)

# Server ======================================================================
server = function(input, output, session) {
  # Cookies link from banner
  shiny::observeEvent(input$cookieLink, {
    shiny::updateTabsetPanel(
      session,
      "tab-container",
      selected = "panel-cookies"
    )
  })

  # Tab nav
  shiny::observeEvent(
    c(input$select_types_button, input$select_types_back),
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
    c(input$text_types_button, input$text_types_back, input$text_types_next),
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
    c(
      input$action_types_button,
      input$action_types_back,
      input$action_types_next
    ),
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
    c(
      input$tables_tabs_and_accordions_button,
      input$tables_tabs_and_accordions_back,
      input$tables_tabs_and_accordions_next
    ),
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
    c(input$feedback_types_button, input$feedback_types_next),
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
    c(input$cookies_button, input$cookies_footer_link),
    {
      shiny::updateTabsetPanel(
        session,
        "tab-container",
        selected = "panel-cookies"
      )
    },
    ignoreInit = TRUE
  )

  # Need this to use live update the word counter
  shiny::observeEvent(
    input$text_area2,
    word_count("text_area2", input$text_area2)
  )

  # Trigger error if text_are2 is blank
  shiny::observeEvent(input$btn_error, {
    if (input$text_area2 == "") {
      error_on("text_area2")
    } else {
      error_off("text_area2")
    }
  })

  # Need this to use live update the word counter
  shiny::observeEvent(
    input$text_area2,
    word_count("text_area2", input$text_area2)
  )

  # Trigger error if text_are2 is blank
  shiny::observeEvent(input$btn3, {
    if (input$text_area2 == "") {
      error_on("text_area2")
    } else {
      error_off("text_area2")
    }
  })

  ##################### Cookie Banner events ################################
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

  shiny::observeEvent(input$cookieLink, {
    shiny::updateTabsetPanel(session, "nav", selected = "panel4")
  })

  output$download_data <- downloadHandler(
    filename = "demo_data.csv",
    content = function(file) {
      # Write the dataset to the `file` that will be downloaded
      data <- data.frame(
        x = 1:10,
        y = 101:110
      )
      write.csv(data, file)
    }
  )

  output$download_button_data <- downloadHandler(
    filename = "demo_button_data.csv",
    content = function(file) {
      # Write the dataset to the `file` that will be downloaded
      data <- data.frame(
        x = 1:10,
        y = 1:10**3
      )
      write.csv(data, file)
    }
  )

  output$download_radios <- download_radios_handler(
    file_name = "example_file",
    file_contents = data.frame(x = c(1, 2, 3), y = c(4, 5, 6))
  )

  filtered_data <- reactive({
    subset(example_data, colours == input$colourFilter)
  })

  output$interactive_table_test <- renderGovReactable({
    govReactable(
      df = filtered_data(),
      right_col = c("bikes", "vans", "buses"),
      page_size = 3,
    )
  })
} # end of server

shiny::shinyApp(
  ui = ui,
  server = server
)
