mod_text_types_ui <- function(id) {
  gov_layout(
    size = "two-thirds",
    heading_text("backlink_Input", size = "s", level = 2),
    backlink_Input(NS(id, "select_types_back")),
    heading_text("Text Types", size = "l"),
    label_hint(
      NS(id, "label2"),
      "These are some examples of the types of user
           text inputs that you can use"
    ),
    heading_text("date_Input", size = "s", level = 2),
    date_Input(
      inputId = NS(id, "date1"),
      label = "What is your date of birth?",
      hint_label = "For example, 31 3 1980"
    ),
    heading_text("text_Input", size = "s", level = 2),
    text_Input(inputId = NS(id, "txt1"), label = "Event name"),
    heading_text("text_area_Input", size = "s", level = 2),
    text_area_Input(
      inputId = NS(id, "text_area1"),
      label = "Can you provide more detail?",
      hint_label = paste0(
        "Do not include personal or financial information, ",
        "like your National Insurance number or credit card details."
      )
    ),
    text_area_Input(
      inputId = NS(id, "text_area2"),
      label = "How are you today?",
      hint_label = "Leave blank to trigger error",
      error = TRUE,
      error_message = "Please do not leave blank",
      word_limit = 300
    ),
    heading_text(
      "button_Input",
      size = "s",
      level = 2,
      id = "button_input_text_types"
    ),
    button_Input(NS(id, "btn_error"), "Check for errors", type = "warning"),
    heading_text("gov_list", size = "s", level = 2),
    shinyGovstyle::gov_text("List:"),
    gov_list(list = c("a", "b", "c")),
    shinyGovstyle::gov_text("Bulleted list:"),
    gov_list(list = c("a", "b", "c"), style = "bullet"),
    shinyGovstyle::gov_text("Numbered list:"),
    gov_list(list = c("one", "two", "three"), style = "number"),
  )
}

mod_text_types_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    shiny::observeEvent(
      input$text_area2,
      shinyGovstyle::word_count("text_area2", input$text_area2)
    )

    shiny::observeEvent(input$btn_error, {
      if (input$text_area2 == "") {
        shinyGovstyle::error_on("text_area2")
      } else {
        shinyGovstyle::error_off("text_area2")
      }
    })

    list(
      prev_page = reactive(input$select_types_back)
    )
  })
}
