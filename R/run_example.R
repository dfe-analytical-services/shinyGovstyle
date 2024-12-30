#' Example Function
#'
#' This function runs a shiny example showcasing different parts of the package
#'
#' @return a shiny app with examples in
#' @keywords example
#' @export
#' @examples
#' if (interactive()) {
#'   run_example()
#' }
run_example <- function() {
  Months <- c("January", "February", "March")
  Bikes <- c(85, 75, 165)
  Cars <- c(95, 55, 125)
  example_data <- data.frame(Months, Bikes, Cars)
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
      skip_to_main(),
      header("MoJ", "shinyGovstyle showcase",
        logo = "shinyGovstyle/images/moj_logo-1.png", logo_width = 66
      ),
      banner(
        "banner",
        "Beta",
        'This is a new service \u002D your <a class="govuk-link" href="https://github.com/dfe-analytical-services/shinyGovstyle/issues/new/choose">
        feedback</a> will help us to improve it.'
      ),

      # Need this to make the error and word count work
      shinyjs::useShinyjs(),
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
              subcontents_text_list =
                c(
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
              subcontents_text_list = c("date_Input", "text_Input", "text_area_Input", "button_Input"),
              subcontents_id_list = c(NA, NA, NA, "button_input_text_types")
            ),

            # Tables tabs and accordions tab
            contents_link(
              "Tables, tabs and accordions",
              "tables_tabs_and_accordions_button",
              subcontents_text_list = c("govTable", "govTabs", "button_Input", "accordions"),
              subcontents_id_list = c(NA, NA, "button_input_tables_tabs_accordions", NA)
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
          shiny::markdown(
            "If running locally, run ```View(run_example)``` in console to see the code for this app. Otherwise, you can see the <a href='https://github.com/dfe-analytical-services/shinyGovstyle/blob/master/R/run_example.R/'>latest version of the code on GitHub</a>."
          ),

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
                label_hint("label1", "These are some examples of the types of user
                   select type inputs that you can use"),
                heading_text("radio_button_Input (inline)", size = "s"),
                radio_button_Input(
                  inputId = "name_changed", label = "Have you changed your name?",
                  choices = c("Yes", "No"), inline = TRUE,
                  hint_label = "This includes changing your last name or spelling
                            your name differently."
                ),
                heading_text("radio_button_Input (stacked)", size = "s"),
                radio_button_Input(
                  inputId = "name_changed_stacked", label = "Have you changed your name?",
                  choices = c("Yes", "No"), inline = FALSE,
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
                button_Input("btn1", "Go to next page")
              )
            ),


            ##################### Create second panel################################
            shiny::tabPanel(
              "Text Types",
              value = "text_types",
              gov_layout(
                size = "two-thirds",
                backlink_Input("back1"),
                heading_text("Page 2", size = "l"),
                label_hint("label2", "These are some examples of the types of user
                   text inputs that you can use"),
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
                heading_text("button_Input", size = "s", id = "button_input_text_types"),
                button_Input("btn_error", "Check for errors", type = "warning")
              )
            ),

            ##################### Create third panel################################
            shiny::tabPanel(
              "Tables, tabs and accordions",
              value = "tables_tabs_and_accordions",
              gov_layout(
                size = "two-thirds",
                backlink_Input("back2"),
                heading_text("Page 3", size = "l"),
                label_hint("label3", "These are some examples of using tabs and
                       tables"),
                heading_text("govTable", size = "s"),
                shinyGovstyle::govTable(
                  "tab1", example_data, "Test", "l",
                  num_col = c(2, 3),
                  width_overwrite = c("one-half", "one-quarter", "one-quarter")
                ),
                heading_text("govTabs", size = "s"),
                shinyGovstyle::govTabs("tabsID", data, "tabs"),
                heading_text("button_Input", size = "s", id = "button_input_tables_tabs_accordions"),
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
              )
            ),

            ##################### Create feedback panel################################
            shiny::tabPanel(
              "Feedback Types",
              value = "feedback_types",
              gov_layout(
                size = "two-thirds",
                backlink_Input("back3"),
                heading_text("Feedback page", size = "l"),
                label_hint("label-feedback", "These are some examples of the types of user
                   feedback inputs that you can use"),
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
                shiny::tags$br(), shiny::tags$br(),
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
                  inputId = "value1",
                  value = "Default (no description included)"
                ),
                value_box(
                  inputId = "value2",
                  value = "1,000,000",
                  text = "This is an example value box in purple.",
                  colour = "purple"
                ),
                value_box(
                  inputId = "value3",
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
                  c("Name", "Date of birth", "Contact information", "Contact details"),
                  c(
                    "Sarah Philips",
                    "5 January 1978",
                    "72 Guild Street <br> London <br> SE23 6FH",
                    "07700 900457 <br> sarah.phillips@example.com"
                  ),
                  action = FALSE
                ),
              )
            ),

            ##################### Create cookie panel################################
            shiny::tabPanel(
              "Cookies",
              value = "panel-cookies",
              gov_layout(
                size = "two-thirds",
                heading_text("Cookie page", size = "l"),
                label_hint("label-cookies", "This an example cookie page that could be
                       expanded")
              )
            )
          )
        )
      ), # end of gov row

      footer(TRUE)
    ), # end of fluid page

    server = function(input, output, session) {
      # Tab nav
      shiny::observeEvent(input$select_types_button, {
        shiny::updateTabsetPanel(session, "tab-container", selected = "select_types")
      })

      shiny::observeEvent(input$text_types_button, {
        shiny::updateTabsetPanel(session, "tab-container", selected = "text_types")
      })

      shiny::observeEvent(input$tables_tabs_and_accordions_button, {
        shiny::updateTabsetPanel(session, "tab-container", selected = "tables_tabs_and_accordions")
      })

      shiny::observeEvent(input$feedback_types_button, {
        shiny::updateTabsetPanel(session, "tab-container", selected = "feedback_types")
      })

      shiny::observeEvent(input$cookies_button, {
        shiny::updateTabsetPanel(session, "tab-container", selected = "panel-cookies")
      })


      # Back buttons
      shiny::observeEvent(input$back1, {
        shiny::updateTabsetPanel(session, "tab-container", selected = "select_types")
      })
      
    footer(TRUE, links = c("Cookies"))


      # Next page buttons
      shiny::observeEvent(input$btn1, {
        shiny::updateTabsetPanel(session, "tab-container", selected = "text_types")
      })

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

      ##################### Cookie Banner events ################################
      shiny::observeEvent(input$cookieAccept, {
        shinyjs::show(id = "cookieAcceptDiv")
        shinyjs::hide(id = "cookieMain")
      })

      shiny::observeEvent(input$cookieReject, {
        shinyjs::show(id = "cookieRejectDiv")
        shinyjs::hide(id = "cookieMain")
      })

    shiny::observeEvent(input$text_types_button, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "text_types")
    })

    shiny::observeEvent(input$tables_tabs_and_accordions_button, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "tables_tabs_and_accordions")
    })

    shiny::observeEvent(input$feedback_types_button, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "feedback_types")
    })

    shiny::observeEvent(input$cookies_button, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "panel-cookies")
    })

    shiny::observeEvent(input$cookies, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "panel-cookies")
    })

    # Back buttons
    shiny::observeEvent(input$back1, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "select_types")
    })

    shiny::observeEvent(input$back2, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "text_types")
    })

    shiny::observeEvent(input$back3, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "tables_tabs_and_accordions")
    })


    # Next page buttons
    shiny::observeEvent(input$btn1, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "text_types")
    })

    shiny::observeEvent(input$btn1, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "tables_tabs_and_accordions")
    })

    shiny::observeEvent(input$btn1, {
      shiny::updateTabsetPanel(session, "tab-container", selected = "feedback_types")
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
        shiny::updateTabsetPanel(session, "nav",
          selected = "panel4"
        )
      })
    }
  )
}
