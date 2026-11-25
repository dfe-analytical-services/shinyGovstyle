shinyGovstyle::gov_page(
  theme = bslib::bs_theme(version = 5, brand = FALSE),
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

  shinyGovstyle::phase_banner(
    "banner",
    "Beta",
    label = shiny::tagList(
      shiny::tags$span(
        id = "showcase-package-version",
        "You’re viewing the ",
        shinyGovstyle::external_link(
          href = showcase_source_url,
          link_text = showcase_source
        ),
        paste0(" of shinyGovstyle v", showcase_package$Version)
      ),
      ". Your ",
      shinyGovstyle::external_link(
        href = paste0(
          "https://github.com/dfe-analytical-services/shinyGovstyle/issues/new",
          "/choose"
        ),
        link_text = "feedback"
      ),
      " will help us improve the package."
    )
  ),

  shinyGovstyle::gov_main_layout(
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "two-thirds",
        mod_width_toggle_ui("width_toggle", initial = demo_width),
        shinyGovstyle::gov_text(
          "This app showcases the components in the installed",
          "shinyGovstyle package.",
          "The latest development source code is on the ",
          shinyGovstyle::external_link(
            href = paste0(
              "https://github.com/dfe-analytical-services/shinyGovstyle/",
              "blob/main/inst/example_app"
            ),
            link_text = "main GitHub branch"
          ),
          ". The switcher allows you to preview the main page width options."
        )
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
      `Package documentation` = showcase_docs_url,
      `GitHub repository` = paste(
        "https://github.com/dfe-analytical-services/shinyGovstyle"
      )
    )
  )
) # end of gov_page
