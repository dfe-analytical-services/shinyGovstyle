mod_cookies_ui <- function(id) {
  # Create the table used in the UI below
  analytics_cookies <- data.frame(
    Name = "_demo_analytics",
    Purpose = paste(
      "Helps us understand how visitors use the demo (for example which",
      "pages they visit) so we can improve it"
    ),
    Expires = "2 years"
  )

  shiny::tagList(
    shinyGovstyle::heading_text("Cookies", size = "l", level = 1),
    shinyGovstyle::insert_text(
      inputId = shiny::NS(id, "cookies_mock_notice"),
      content = paste(
        "This is a mock cookies page for demonstration only. It shows how",
        "update_radio_button_Input() can keep the settings radio in sync with",
        "the cookie banner."
      )
    ),
    shinyGovstyle::gov_text(
      "Cookies are small files saved on your phone, tablet or computer when",
      "you visit a website."
    ),
    shinyGovstyle::gov_text(
      "We use cookies to make this site work and collect information about how you use our service."
    ),
    shinyGovstyle::heading_text("Analytics cookies", size = "m", level = 2),
    shinyGovstyle::gov_text(
      "Analytics cookies let us measure how the service is used so we can",
      "continually improve it."
    ),
    shinyGovstyle::govTable(
      shiny::NS(id, "analytics_cookies_table"),
      analytics_cookies,
      caption = "Analytics cookies used by this demo",
      caption_size = "s"
    ),
    shiny::uiOutput(shiny::NS(id, "cookie_saved")),
    shinyGovstyle::heading_text(
      "Change your cookie settings",
      size = "m",
      level = 2
    ),
    shinyGovstyle::radio_button_Input(
      inputId = shiny::NS(id, "cookies_analytics"),
      label = "Do you want to accept analytics cookies?",
      choices = c("Yes" = "yes", "No" = "no"),
      selected = "no",
      inline = TRUE
    ),
    shinyGovstyle::button_Input(
      shiny::NS(id, "save_cookies"),
      "Save cookie settings"
    )
  )
}

mod_cookies_server <- function(id, cookie_accept, cookie_reject) {
  shiny::moduleServer(id, function(input, output, session) {
    # Banner choices drive the settings radio server-side, so the radio stays
    # in sync with what the user clicked in the cookie banner without them
    # touching it.
    shiny::observeEvent(
      cookie_accept(),
      {
        shinyGovstyle::update_radio_button_Input(
          session,
          inputId = "cookies_analytics",
          selected = "yes"
        )
      },
      ignoreInit = TRUE
    )

    shiny::observeEvent(
      cookie_reject(),
      {
        shinyGovstyle::update_radio_button_Input(
          session,
          inputId = "cookies_analytics",
          selected = "no"
        )
      },
      ignoreInit = TRUE
    )

    # Saving shows a success banner that reflects the live radio value (nothing
    # is actually stored, this is a mock).
    saved_choice <- shiny::reactiveVal(NULL)

    shiny::observeEvent(input$save_cookies, {
      saved_choice(
        if (identical(input$cookies_analytics, "yes")) "accept" else "reject"
      )
    })

    output$cookie_saved <- shiny::renderUI({
      choice <- saved_choice()
      if (is.null(choice)) {
        return(NULL)
      }
      shinyGovstyle::noti_banner(
        session$ns("saved_banner"),
        title_txt = "Success",
        body_txt = paste0(
          "You've updated your cookie preferences. You chose to ",
          choice,
          " analytics cookies."
        ),
        type = "success"
      )
    })
  })
}
