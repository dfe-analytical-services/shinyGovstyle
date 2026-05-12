mod_feedback_types_ui <- function(id) {
  shiny::tagList(
    shinyGovstyle::heading_text("Feedback page", size = "l"),
    shinyGovstyle::label_hint(
      shiny::NS(id, "label-feedback"),
      "These are some examples of the types of user
           feedback inputs that you can use"
    ),
    shinyGovstyle::heading_text("tag_Input", size = "s", level = 2),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag1"), "Default"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag2"), "Grey", "grey"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag3"), "Green", "green"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag4"), "Teal", "teal"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag5"), "Blue", "blue"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag6"), "Purple", "purple"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag7"), "Magenta", "magenta"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag8"), "Red", "red"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag9"), "Orange", "orange"),
    shinyGovstyle::tag_Input(shiny::NS(id, "tag10"), "Yellow", "yellow"),
    shiny::tags$br(),
    shiny::tags$br(),
    shinyGovstyle::heading_text("details", size = "s", level = 2),
    shinyGovstyle::details(
      inputId = shiny::NS(id, "detID"),
      label = "Help with nationality",
      help_text = paste(
        "We need to know your nationality so we can work out",
        "which elections you\u0027re entitled to vote in. If you",
        "cannot provide your nationality\u002C you\u0027ll have to",
        "send copies of identity documents through the post."
      )
    ),
    shinyGovstyle::heading_text("insert_text", size = "s", level = 2),
    shinyGovstyle::insert_text(
      inputId = shiny::NS(id, "insertId"),
      text = "It can take up to 8 weeks to register a lasting
                power of attorney if there are no mistakes in the
                application."
    ),
    shinyGovstyle::heading_text("warning_text", size = "s", level = 2),
    shinyGovstyle::warning_text(
      inputId = shiny::NS(id, "warn"),
      text = "You can be fined up to \u00A35\u002C000 if you do
      not register."
    ),
    shinyGovstyle::heading_text("value_box", size = "s", level = 2),
    shinyGovstyle::value_box(
      value = "Default (no description included)"
    ),
    shinyGovstyle::value_box(
      value = "1,000,000",
      text = "This is an example value box in purple.",
      colour = "purple"
    ),
    shinyGovstyle::value_box(
      value = "58.3%",
      text = paste(
        "This is another example value box in red.",
        "More colours are available."
      ),
      colour = "red"
    ),
    shinyGovstyle::heading_text("panel_output", size = "s", level = 2),
    shinyGovstyle::panel_output(
      inputId = shiny::NS(id, "panId"),
      main_text = "Application complete",
      sub_text = paste(
        "Your reference number <br>",
        "<strong>HDJ2123F</strong>"
      )
    ),
    shinyGovstyle::heading_text("noti_banner", size = "s", level = 2),
    shinyGovstyle::noti_banner(
      shiny::NS(id, "notId"),
      title_txt = "Important",
      body_txt = "You have 7 days left to send your application.",
      type = "standard"
    ),
    shinyGovstyle::heading_text("gov_summary", size = "s", level = 2),
    shinyGovstyle::gov_summary(
      shiny::NS(id, "sumID"),
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
}
