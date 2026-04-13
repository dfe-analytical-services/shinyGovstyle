mod_select_types_ui <- function(id) {
  shiny::tagList(
    shinyGovstyle::heading_text("Select Types", size = "l"),
    shinyGovstyle::label_hint(
      shiny::NS(id, "label1"),
      "These are some examples of the types of user
           select type inputs that you can use"
    ),
    shinyGovstyle::heading_text(
      "radio_button_Input (inline)",
      size = "s",
      level = 2
    ),
    shinyGovstyle::radio_button_Input(
      inputId = shiny::NS(id, "name_changed"),
      label = "Have you changed your name?",
      choices = c("Yes", "No"),
      inline = TRUE,
      hint_label = "This includes changing your last name or spelling
                    your name differently."
    ),
    shinyGovstyle::heading_text(
      "radio_button_Input (stacked)",
      size = "s",
      level = 2
    ),
    shinyGovstyle::radio_button_Input(
      inputId = shiny::NS(id, "name_changed_stacked"),
      label = "Have you changed your name?",
      choices = c("Yes", "No"),
      inline = FALSE,
      hint_label = "This includes changing your last name or spelling
                    your name differently."
    ),
    shinyGovstyle::heading_text("checkbox_Input", size = "s", level = 2),
    shinyGovstyle::checkbox_Input(
      inputId = shiny::NS(id, "checkID"),
      cb_labels = c(
        "Waste from animal carcasses",
        "Waste from mines or quarries",
        "Farm or agricultural waste"
      ),
      checkboxIds = c(
        shiny::NS(id, "op1"),
        shiny::NS(id, "op2"),
        shiny::NS(id, "op3")
      ),
      label = "Which types of waste do you transport?",
      hint_label = "Select all that apply."
    ),
    shinyGovstyle::heading_text("select_Input", size = "s", level = 2),
    shinyGovstyle::select_Input(
      inputId = shiny::NS(id, "sorter"),
      label = "Sort by",
      select_text = c(
        "Recently published",
        "Recently updated",
        "Most views",
        "Most comments"
      ),
      select_value = c("published", "updated", "view", "comments")
    ),
    shinyGovstyle::heading_text("file_Input", size = "s", level = 2),
    shinyGovstyle::file_Input(
      inputId = shiny::NS(id, "file1"),
      label = "Upload a file"
    ),
    shinyGovstyle::heading_text("button_Input", size = "s", level = 2),
    shinyGovstyle::button_Input(
      shiny::NS(id, "text_types_next"),
      "Go to next page"
    )
  )
}

mod_select_types_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    list(
      next_page = shiny::reactive(input$text_types_next)
    )
  })
}
