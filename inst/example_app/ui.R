shinyGovstyle::gov_page(
  theme = bslib::bs_theme(version = 5),
  title = "Select Types | shinyGovstyle",
  description = "A showcase of the components available in shinyGovstyle",
  width = demo_width,

  shinyGovstyle::cookieBanner("shinyGovstyle component showcase"),
  shinyjs::useShinyjs(),

  shinyGovstyle::skip_to_main(),
  shinyGovstyle::header(
    org_name = "Department for Education",
    service_name = "shinyGovstyle showcase app"
  ),
  shinyGovstyle::service_navigation(
    c(
      "Select Types" = "sn_select_types",
      "Text Types" = "sn_text_types",
      "Action Types" = "sn_action_types",
      "Tables, tabs and accordions" = "sn_tables_tabs",
      "Feedback types" = "sn_feedback_types",
      "Cookies" = "sn_cookies"
    ),
    page_title_suffix = "shinyGovstyle"
  ),

  shinyGovstyle::banner(
    "banner",
    "Beta",
    paste0(
      'This is a new service \u002D your <a class="govuk-link" href=',
      '"https://github.com/dfe-analytical-services/shinyGovstyle/issues/new',
      '/choose">feedback</a> will help us to improve it.'
    )
  ),

  shinyGovstyle::gov_main_layout(
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "two-thirds",
        shinyGovstyle::gov_text(
          "This example app showcases the components available in the",
          "latest development version of the shinyGovstyle package.",
          "The source code is on the ",
          shinyGovstyle::external_link(
            href = paste0(
              "https://github.com/dfe-analytical-services/shinyGovstyle/",
              "blob/main/inst/example_app"
            ),
            link_text = "main GitHub branch"
          ),
          ". The page is built with ",
          shinyGovstyle::external_link(
            href = "https://rstudio.github.io/bslib/",
            link_text = "bslib package"
          ),
          "'s ", shiny::tags$code("page_fluid()"), ", via ",
          shiny::tags$code("shinyGovstyle::gov_page()"),
          "; it's currently using the \"full\" width option, so try",
          " \"standard\" and \"three quarters\" with the switcher below."
        ),
        mod_width_toggle_ui("width_toggle")
      )
    ),

    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "two-thirds",
        shiny::tabsetPanel(
          type = "hidden",
          id = "tab-container",

          shiny::tabPanel(
            "Select Types",
            value = "select_types",
            mod_select_types_ui("select_types")
          ),

          shiny::tabPanel(
            "Text Types",
            value = "text_types",
            mod_text_types_ui("text_types")
          ),

          shiny::tabPanel(
            "Action types",
            value = "action_types",
            mod_action_types_ui("action_types")
          ),

          shiny::tabPanel(
            "Tables, tabs and accordions",
            value = "tables_tabs_and_accordions",
            mod_tables_tabs_ui("tables_tabs")
          ),

          shiny::tabPanel(
            "Feedback Types",
            value = "feedback_types",
            mod_feedback_types_ui("feedback_types")
          ),

          shiny::tabPanel(
            "Cookies",
            value = "panel-cookies",
            mod_cookies_ui("cookies")
          )
        )
      )
    )
  ),

  shinyGovstyle::footer(
    TRUE,
    links = c(
      `Cookies` = "cookies_footer_link",
      `GitHub repository` = paste(
        "https://github.com/dfe-analytical-services/shinyGovstyle"
      )
    )
  )
) # end of gov_page
