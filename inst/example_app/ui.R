shinyGovstyle::gov_page(
  theme = bslib::bs_theme(version = 5, brand = FALSE),
  title = "Select Types | shinyGovstyle: GOV.UK Design System for R Shiny",
  description = paste(
    "Interactive showcase of shinyGovstyle, an R package of GOV.UK Design",
    "System components for Shiny apps: inputs, tables, tabs, banners and more."
  ),
  favicon = "govuk",
  width = demo_width,

  # Canonical, Open Graph and Twitter card tags: the dev app points at the
  # CRAN app so the two aren't treated as duplicates, and shared links get a
  # large preview card
  shiny::tags$head(
    shiny::tags$link(rel = "canonical", href = app_url),
    shiny::tags$meta(property = "og:type", content = "website"),
    shiny::tags$meta(property = "og:site_name", content = "shinyGovstyle"),
    shiny::tags$meta(property = "og:locale", content = "en_GB"),
    shiny::tags$meta(property = "og:url", content = app_url),
    shiny::tags$meta(
      property = "og:title",
      content = "shinyGovstyle: GOV.UK Design System for R Shiny"
    ),
    shiny::tags$meta(
      property = "og:description",
      content = paste(
        "Interactive showcase of GOV.UK Design System components for R",
        "Shiny apps."
      )
    ),
    shiny::tags$meta(
      property = "og:image",
      content = paste0(
        app_url,
        "shinyGovstyle/images/govuk-opengraph-image.png"
      )
    ),
    shiny::tags$meta(property = "og:image:width", content = "1200"),
    shiny::tags$meta(property = "og:image:height", content = "630"),
    shiny::tags$meta(
      property = "og:image:alt",
      content = "GOV.UK logo: a white crown and wordmark on a blue background"
    ),
    shiny::tags$meta(name = "twitter:card", content = "summary_large_image")
  ),

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
    page_title_suffix = "shinyGovstyle: GOV.UK Design System for R Shiny"
  ),

  shinyGovstyle::phase_banner(
    "banner",
    "Beta",
    feedback_url = paste0(
      "https://github.com/dfe-analytical-services/shinyGovstyle/issues/new",
      "/choose"
    )
  ),

  shinyGovstyle::gov_main_layout(
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "two-thirds",
        mod_width_toggle_ui("width_toggle", initial = demo_width),
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
      `GitHub repository` = paste(
        "https://github.com/dfe-analytical-services/shinyGovstyle"
      )
    )
  )
) # end of gov_page
