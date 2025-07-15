# Deployed at https://department-for-education.shinyapps.io/shinygovstyle-example-app/

library(shinyGovstyle)
library(dplyr) #needed for the pipe to filter reactive data example!

Months <- rep(c("January", "February", "March", "April", "May"), times = 2)
Colours <- rep(c("Red", "Blue"), times = 5)
Bikes <- c(85, 75, 165, 90, 80, 95, 85, 175, 100, 95)
Vans <- c(150, 130, 180, 160, 140, 175, 135, 185, 155, 145)
Buses <- c(200, 180, 220, 210, 190, 215, 185, 225, 205, 195)
example_data <- data.frame(Months, Colours, Bikes, Vans, Buses)
example_data_short <- head(example_data, 5)
tabs <- c(
  rep("Past Day", 3),
  rep("Past Week", 3),
  rep("Past Month", 3),
  rep("Past Year", 3)
)
Case_manager <- rep(c("David Francis", "Paul Farmer", "Rita Patel"), 4)
Cases_open <- c(3, 1, 2, 24, 16, 24, 98, 122, 126, 1380, 1129, 1539)
Cases_closed <- c(0, 0, 0, 18, 20, 27, 95, 131, 142, 1472, 1083, 1265)
data <- data.frame(tabs, Case_manager, Cases_open, Cases_closed)

shiny::shinyApp(
  ui = shiny::fluidPage(
    title = "ShinyGovstyle",
    cookieBanner("shinyGovstyle showcase"),
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
      'This is a new service \u002D your <a class="govuk-link" href="https://github.com/dfe-analytical-services/shinyGovstyle/issues/new/choose">
        feedback</a> will help us to improve it.'
    ),

    # Need this to make the error and word count work
    shinyjs::useShinyjs(),

    # Notice at top of page ----
    br(),
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "full",
        shinyGovstyle::gov_text(
          style = "margin-bottom: -10px;",
          "This example app showcases the components available in the latest development version of the shinyGovstyle
                    package. The source code for the app can be found on the ",
          shinyGovstyle::external_link(
            href = "https://github.com/dfe-analytical-services/shinyGovstyle/blob/master/inst/example_app/app.R",
            link_text = "master GitHub branch"
          ),
          "."
        )
      )
    ),

    # Main navigation ----
    gov_row(
      # Nav columns
      shiny::column(
        width = 3,
        id = "nav", # DO NOT REMOVE ID

        # Contents box
        shiny::tags$div(
          id = "govuk-contents-box", # DO NOT REMOVE ID
          class = "govuk-contents-box", # DO NOT REMOVE CLASS

          shiny::tags$h2("Contents"),

          # Select Types tab
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

          # Text types tab
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

          # Action types tab
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

          # Tables tabs and accordions tab
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

          # Feedback types tab
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
          ),
        )
      ),
      shiny::column(
        width = 9,
        id = "main_col", # DO NOT REMOVE ID

        shiny::tags$br(),

        # Set up a nav panel so everything not on single page
        shiny::tabsetPanel(
          type = "hidden",
          id = "tab-container", # DO NOT REMOVE ID

          ##################### Create first panel################################
          shiny::tabPanel(
            "Select Types",
            value = "select_types",
            gov_layout(
              size = "two-thirds",
              heading_text("Select Types", size = "l"),
              label_hint(
                "label1",
                "These are some examples of the types of user
                   select type inputs that you can use"
              ),
              heading_text("radio_button_Input (inline)", size = "s"),
              radio_button_Input(
                inputId = "name_changed",
                label = "Have you changed your name?",
                choices = c("Yes", "No"),
                inline = TRUE,
                hint_label = "This includes changing your last name or spelling
                            your name differently."
              ),
              heading_text("radio_button_Input (stacked)", size = "s"),
              radio_button_Input(
                inputId = "name_changed_stacked",
                label = "Have you changed your name?",
                choices = c("Yes", "No"),
                inline = FALSE,
                hint_label = "This includes changing your last name or spelling
                            your name differently."
              ),
              heading_text("checkbox_Input", size = "s"),
              checkbox_Input(
                inputId = "checkID",
                cb_labels = c(
                  "Waste from animal carcasses",
                  "Waste from mines or quarries",
                  "Farm or agricultural waste"
                ),
                checkboxIds = c("op1", "op2", "op3"),
                label = "Which types of waste do you transport?",
                hint_label = "Select all that apply."
              ),
              heading_text("select_Input", size = "s"),
              select_Input(
                inputId = "sorter",
                label = "Sort by",
                select_text = c(
                  "Recently published",
                  "Recently updated",
                  "Most views",
                  "Most comments"
                ),
                select_value = c("published", "updated", "view", "comments")
              ),
              heading_text("file_Input", size = "s"),
              file_Input(inputId = "file1", label = "Upload a file"),
              heading_text("button_Input", size = "s"),
              button_Input("text_types_next", "Go to next page")
            )
          ),

          ##################### Create second panel################################
          shiny::tabPanel(
            "Text Types",
            value = "text_types",
            gov_layout(
              size = "two-thirds",
              backlink_Input("select_types_back"),
              heading_text("Page 2", size = "l"),
              label_hint(
                "label2",
                "These are some examples of the types of user
                   text inputs that you can use"
              ),
              heading_text("date_Input", size = "s"),
              date_Input(
                inputId = "date1",
                label = "What is your date of birth?",
                hint_label = "For example, 31 3 1980"
              ),
              heading_text("text_Input", size = "s"),
              text_Input(inputId = "txt1", label = "Event name"),
              heading_text("text_area_Input", size = "s"),
              text_area_Input(
                inputId = "text_area1",
                label = "Can you provide more detail?",
                hint_label = "Do not include personal or financial information,
          like your National Insurance number or credit card details."
              ),
              text_area_Input(
                inputId = "text_area2",
                label = "How are you today?",
                hint_label = "Leave blank to trigger error",
                error = T,
                error_message = "Please do not leave blank",
                word_limit = 300
              ),
              heading_text(
                "button_Input",
                size = "s",
                id = "button_input_text_types"
              ),
              button_Input("btn_error", "Check for errors", type = "warning"),
              button_Input("action_types_next", "Go to next page"),
              heading_text("gov_list", size = "s"),
              shinyGovstyle::gov_text("List:"),
              gov_list(list = c("a", "b", "c")),
              shinyGovstyle::gov_text("Bulleted list:"),
              gov_list(list = c("a", "b", "c"), style = "bullet"),
              shinyGovstyle::gov_text("Numbered list:"),
              gov_list(list = c("one", "two", "three"), style = "number"),
            )
          ),

          ##################### Create action types panel################################
          shiny::tabPanel(
            "Action types",
            value = "action_types",
            gov_layout(
              size = "two-thirds",
              backlink_Input("text_types_back"),
              heading_text("Action types", size = "l"),
              label_hint(
                "label3",
                "These are some examples of the types of user
                   action elements that you can use"
              ),
              heading_text("external_link", size = "s"),
              gov_text(
                "You can add external links with automatic formatting such as to our ",
                shinyGovstyle::external_link(
                  href = "https://github.com/dfe-analytical-services/shinyGovstyle",
                  link_text = "GitHub repository",
                ),
                "."
              ),
              shinyGovstyle::gov_text(
                "You can also add external links that don't have the warning in brackets
                but do have the warning for screen readers, such as this link to our ",
                shinyGovstyle::external_link(
                  href = "https://dfe-analytical-services.github.io/shinyGovstyle/",
                  link_text = "package documentation site",
                  add_warning = FALSE
                ),
                "."
              ),
              heading_text("download_button", size = "s"),
              shinyGovstyle::download_button(
                "download_button_data",
                "Download a demo data set",
                file_type = "CSV",
                file_size = "1 KB"
              ),
              heading_text("download_link", size = "s"),
              shinyGovstyle::gov_text(
                shinyGovstyle::download_link(
                  "download_data",
                  "Download a demo data set",
                  file_type = "CSV",
                  file_size = "1 KB"
                )
              ),
              heading_text("download_radios", size = "s"),
              shinyGovstyle::gov_text(
                shinyGovstyle::download_radios(
                  file_types = c("CSV", "XLSX", "ODS")
                )
              ),
              button_Input("tables_tabs_and_accordions_next", "Go to next page")
            )
          ),

          ##################### Create third panel################################
          shiny::tabPanel(
            "Tables, tabs and accordions",
            value = "tables_tabs_and_accordions",
            gov_layout(
              size = "two-thirds",
              backlink_Input("action_types_back"),
              heading_text("Tables, tabs and accordions", size = "l"),
              label_hint(
                "label3",
                "These are some examples of using tabs and tables"
              ),

              heading_text("govTable", size = "s"),
              shinyGovstyle::govTable(
                "tab1",
                example_data_short,
                "Static example",
                "l",
                num_col = c(3, 4, 5)
              ),

              heading_text("govReactable with static data", size = "s"),
              heading_text("Caption added separately", size = "l"),
              govReactable(
                example_data,
                right_col = c("Bikes", "Vans", "Buses"),
                page_size = 5
              ),

              heading_text("govReactable with reactive data", size = "s"),
              select_Input(
                inputId = "colourFilter",
                label = "Select Colour",
                select_text = c(sort(unique(example_data$Colours))),
                select_value = c(sort(unique(example_data$Colours)))
              ),
              govReactableOutput(
                "interactive_table_test",
                caption = "Caption in output function"
              ),

              heading_text("govTabs", size = "s"),
              shinyGovstyle::govTabs("tabsID", data, "tabs"),
              shiny::tags$br(),
              shiny::tags$br(),
              heading_text("accordions", size = "s"),
              shinyGovstyle::accordion(
                "acc1",
                c(
                  "Writing well for the web",
                  "Writing well for specialists",
                  "Know your audience",
                  "How people read"
                ),
                c(
                  "This is the content for Writing well for the web.",
                  "This is the content for Writing well for specialists.",
                  "This is the content for Know your audience.",
                  "This is the content for How people read."
                )
              ),
              button_Input("feedback_types_next", "Go to next page")
            )
          ),

          ##################### Create feedback panel################################
          shiny::tabPanel(
            "Feedback Types",
            value = "feedback_types",
            gov_layout(
              size = "two-thirds",
              backlink_Input("tables_tabs_and_accordions_back"),
              heading_text("Feedback page", size = "l"),
              label_hint(
                "label-feedback",
                "These are some examples of the types of user
                   feedback inputs that you can use"
              ),
              heading_text("tag_Input", size = "s"),
              shinyGovstyle::tag_Input("tag1", "Default"),
              shinyGovstyle::tag_Input("tag2", "Grey", "grey"),
              shinyGovstyle::tag_Input("tag3", "Green", "green"),
              shinyGovstyle::tag_Input("tag4", "Turquoise", "turquoise"),
              shinyGovstyle::tag_Input("tag5", "Blue", "blue"),
              shinyGovstyle::tag_Input("tag6", "Light-blue", "light-blue"),
              shinyGovstyle::tag_Input("tag7", "Purple", "purple"),
              shinyGovstyle::tag_Input("tag8", "Pink", "pink"),
              shinyGovstyle::tag_Input("tag9", "Red", "red"),
              shinyGovstyle::tag_Input("tag10", "Orange", "orange"),
              shinyGovstyle::tag_Input("tag11", "Yellow", "yellow"),
              shiny::tags$br(),
              shiny::tags$br(),
              heading_text("details", size = "s"),
              details(
                inputId = "detID",
                label = "Help with nationality",
                help_text = "We need to know your nationality so we can work out
              which elections you\u0027re entitled to vote in. If you cannot provide
              your nationality\u002C you\u0027ll have to send copies of identity
              documents through the post."
              ),
              heading_text("insert_text", size = "s"),
              insert_text(
                inputId = "insertId",
                text = "It can take up to 8 weeks to register a lasting
                        power of attorney if there are no mistakes in the
                        application."
              ),
              heading_text("warning_text", size = "s"),
              warning_text(
                inputId = "warn",
                text = "You can be fined up to \u00A35\u002C000 if you do
              not register."
              ),
              heading_text("value_box", size = "s"),
              value_box(
                value = "Default (no description included)"
              ),
              value_box(
                value = "1,000,000",
                text = "This is an example value box in purple.",
                colour = "purple"
              ),
              value_box(
                value = "58.3%",
                text = "This is another example value box in red. More colours are available.",
                colour = "red"
              ),
              heading_text("panel_output", size = "s"),
              panel_output(
                inputId = "panId",
                main_text = "Application complete",
                sub_text = "Your reference number <br> <strong>HDJ2123F</strong>"
              ),
              heading_text("noti_banner", size = "s"),
              noti_banner(
                "notId",
                title_txt = "Important",
                body_txt = "You have 7 days left to send your application.",
                type = "standard"
              ),
              heading_text("gov_summary", size = "s"),
              shinyGovstyle::gov_summary(
                "sumID",
                c(
                  "Name",
                  "Date of birth",
                  "Contact information",
                  "Contact details"
                ),
                c(
                  "Sarah Philips",
                  "5 January 1978",
                  "72 Guild Street <br> London <br> SE23 6FH",
                  "07700 900457 <br> sarah.phillips@example.com"
                ),
                action = FALSE
              )
            )
          ),

          ##################### Create cookie panel################################
          shiny::tabPanel(
            "Cookies",
            value = "panel-cookies",
            gov_layout(
              size = "two-thirds",
              heading_text("Cookie page", size = "l"),
              label_hint(
                "label-cookies",
                "This an example cookie page that could be
                       expanded"
              )
            )
          )
        )
      )
    ), # end of gov row

    shinyGovstyle::footer(
      TRUE,
      links = c(
        `Cookies` = "cookies_footer_link",
        `GitHub repository` = "https://github.com/dfe-analytical-services/shinyGovstyle"
      )
    )
  ), # end of fluid page

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
      example_data %>% filter(Colours == input$colourFilter)
    })

    output$interactive_table_test <- renderGovReactable({
      govReactable(
        df = filtered_data(),
        right_col = c("Bikes", "Vans", "Buses"),
        page_size = 3,
      )
    })
  } # end of server
)
