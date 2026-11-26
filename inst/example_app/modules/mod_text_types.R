mod_text_types_ui <- function(id) {
  shiny::tagList(
    shinyGovstyle::heading_text("backlink_Input", size = "s", level = 2),
    shinyGovstyle::backlink_Input(shiny::NS(id, "select_types_back")),
    # Hidden until "Check for errors" finds a problem. GOV.UK puts the error
    # summary at the top of the page, above the main heading.
    shinyjs::hidden(
      shinyGovstyle::error_summary(
        inputId = shiny::NS(id, "error_summary"),
        error_title = "There is a problem",
        error_list = character(0)
      )
    ),
    shinyGovstyle::heading_text("Text Types", size = "l"),
    shinyGovstyle::label_hint(
      shiny::NS(id, "label2"),
      "These are some examples of the types of user
           text inputs that you can use"
    ),
    shinyGovstyle::heading_text("date_Input", size = "s", level = 2),
    shinyGovstyle::date_Input(
      inputId = shiny::NS(id, "date1"),
      label = "What is your date of birth?",
      hint_label = "For example, 31 3 1980",
      date_of_birth = TRUE,
      error = TRUE,
      error_message = "Enter your date of birth"
    ),
    shinyGovstyle::heading_text("text_Input", size = "s", level = 2),
    shinyGovstyle::text_Input(
      inputId = shiny::NS(id, "txt1"),
      label = "Event name",
      hint_label = shiny::tagList(
        "As shown on your ",
        shinyGovstyle::external_link(
          "https://www.gov.uk",
          "confirmation letter"
        )
      )
    ),
    shinyGovstyle::heading_text("text_area_Input", size = "s", level = 2),
    shinyGovstyle::text_area_Input(
      inputId = shiny::NS(id, "text_area1"),
      label = "Can you provide more detail?",
      hint_label = paste0(
        "Do not include personal or financial information, ",
        "like your National Insurance number or credit card details."
      )
    ),
    shinyGovstyle::text_area_Input(
      inputId = shiny::NS(id, "text_area2"),
      label = "How are you today?",
      hint_label = "Leave blank to trigger error",
      error = TRUE,
      error_message = "Please do not leave blank",
      word_limit = 300
    ),
    shinyGovstyle::heading_text(
      "button_Input",
      size = "s",
      level = 2,
      id = "button_input_text_types"
    ),
    shinyGovstyle::button_Input(
      shiny::NS(id, "btn_error"),
      "Check for errors",
      type = "warning"
    ),
    shinyGovstyle::heading_text("gov_list", size = "s", level = 2),
    shinyGovstyle::gov_text("List:"),
    shinyGovstyle::gov_list(list = c("a", "b", "c")),
    shinyGovstyle::gov_text("Bulleted list:"),
    shinyGovstyle::gov_list(list = c("a", "b", "c"), style = "bullet"),
    shinyGovstyle::gov_text("Numbered list:"),
    shinyGovstyle::gov_list(list = c("one", "two", "three"), style = "number"),
    shinyGovstyle::gov_text("List with a link:"),
    shinyGovstyle::gov_list(
      list = list(
        "An ordinary item",
        shiny::tagList(
          "An item with a ",
          shinyGovstyle::external_link("https://www.gov.uk", "link to GOV.UK")
        )
      ),
      style = "bullet"
    )
  )
}

mod_text_types_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observeEvent(input$btn_error, {
      errors <- c()

      # The date input's value is "day/month/year", so only slashes when blank
      if (is.null(input$date1) || gsub("/", "", input$date1) == "") {
        errors <- c(errors, date1 = "Enter your date of birth")
        shinyGovstyle::error_on("date1")
      } else {
        shinyGovstyle::error_off("date1")
      }

      # Count words the same way as the browser's live count
      word_count <- stringr::str_count(
        input$text_area2,
        stringr::boundary("word")
      )

      if (input$text_area2 == "") {
        errors <- c(errors, text_area2 = "Please do not leave blank")
      } else if (word_count > 300) {
        errors <- c(
          errors,
          text_area2 = "Your answer must be 300 words or less"
        )
      }
      if ("text_area2" %in% names(errors)) {
        shinyGovstyle::error_on(
          "text_area2",
          error_message = errors[["text_area2"]]
        )
      } else {
        shinyGovstyle::error_off("text_area2")
      }

      # Names are input ids, so each message links to its input. The summary
      # is shown before it is updated, as it cannot take focus while hidden.
      if (length(errors) > 0) {
        shinyjs::show("error_summary")
        shinyGovstyle::error_summary_update("error_summary", errors)
      } else {
        shinyjs::hide("error_summary")
      }
    })

    list(
      prev_page = shiny::reactive(input$select_types_back)
    )
  })
}
