mod_tables_tabs_ui <- function(id) {
  shiny::tagList(
    shinyGovstyle::heading_text("Tables, tabs and accordions", size = "l"),
    shinyGovstyle::label_hint(
      shiny::NS(id, "label3"),
      "These are some examples of using tabs and tables"
    ),

    shinyGovstyle::heading_text("govTable", size = "s", level = 2),
    shinyGovstyle::govTable(
      shiny::NS(id, "tab1"),
      shinyGovstyle::transport_data_small,
      "Static example",
      "l",
      num_col = c(2, 3)
    ),

    shinyGovstyle::heading_text(
      "govReactable with static data",
      size = "s",
      level = 2
    ),
    shinyGovstyle::heading_text("Caption added separately", size = "l"),
    shinyGovstyle::govReactable(
      shinyGovstyle::transport_data,
      right_col = c("bikes", "vans", "buses"),
      page_size = 5
    ),

    shinyGovstyle::heading_text(
      "govReactable with reactive data",
      size = "s",
      level = 2
    ),
    shinyGovstyle::select_Input(
      inputId = shiny::NS(id, "colourFilter"),
      label = "Select Colour",
      select_text = c(sort(unique(
        shinyGovstyle::transport_data$colours
      ))),
      select_value = c(sort(unique(
        shinyGovstyle::transport_data$colours
      )))
    ),
    shinyGovstyle::govReactableOutput(
      shiny::NS(id, "interactive_table_test"),
      caption = "Caption in output function"
    ),

    shinyGovstyle::heading_text("govTabs", size = "s", level = 2),
    shinyGovstyle::govTabs(
      shiny::NS(id, "govTabs"),
      shinyGovstyle::case_data,
      "tabs"
    ),
    shiny::tags$br(),
    shiny::tags$br(),
    shinyGovstyle::heading_text("accordions", size = "s", level = 2),
    shinyGovstyle::accordion(
      shiny::NS(id, "acc1"),
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
    )
  )
}

mod_tables_tabs_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    filtered_data <- shiny::reactive({
      subset(shinyGovstyle::transport_data, colours == input$colourFilter)
    })

    output$interactive_table_test <- shinyGovstyle::renderGovReactable({
      shinyGovstyle::govReactable(
        df = filtered_data(),
        right_col = c("bikes", "vans", "buses"),
        page_size = 3,
      )
    })
  })
}
