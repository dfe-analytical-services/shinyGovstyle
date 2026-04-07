bslib::page_fluid(
  theme = bs_theme(version = 5),
  title = "ShinyGovstyle component showcase",
  cookieBanner("shinyGovstyle component showcase"),
  shinyjs::useShinyjs(),

  shiny::tags$head(shiny::HTML("<html lang='en'>")),

  shinyGovstyle::full_width_overrides(), # TODO: remove when built in

  shinyGovstyle::skip_to_main(),
  header(
    main_text = "Department for Education",
    secondary_text = "shinyGovstyle showcase app"
  ),
  shinyGovstyle::service_navigation(
    c(
      "Select Types" = "sn_select_types",
      "Text Types" = "sn_text_types",
      "Action Types" = "sn_action_types",
      "Tables, tabs and accordions" = "sn_tables_tabs",
      "Feedback types" = "sn_feedback_types",
      "Cookies" = "sn_cookies"
    )
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

  gov_main_layout(
    gov_box(
      size = "two-thirds",
      shinyGovstyle::gov_text(
        "This example app showcases the components available in the",
        "latest development version of the shinyGovstyle package.",
        "The source code for the app can be found on the ",
        shinyGovstyle::external_link(
          href = paste0(
            "https://github.com/dfe-analytical-services/shinyGovstyle/",
            "blob/main/inst/example_app"
          ),
          link_text = "main GitHub branch"
        ),
        ". The page layout has some custom CSS overrides is still being",
        " developed to work with the ",
        shinyGovstyle::external_link(
          href = "https://rstudio.github.io/bslib/",
          link_text = "bslib package"
        ),
        " and may change in future releases."
      )
    ),

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
) # end of page_fluid
