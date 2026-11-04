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
      "Bike and car costs were highest in March",
      "l",
      num_col = c(2, 3),
      subtitle = "Cost of bikes and cars (£), January to March, example data"
    ),

    shinyGovstyle::heading_text(
      "govReactable with static data",
      size = "s",
      level = 2
    ),
    shinyGovstyle::govReactable(
      shinyGovstyle::transport_data,
      caption = "Costs peaked in March for every vehicle type",
      subtitle = paste(
        "Cost of bikes, vans and buses by vehicle colour (£),",
        "January to May, example data"
      ),
      caption_size = "l",
      page_size = 5
    ),

    shinyGovstyle::heading_text(
      "govReactable with reactive data and dynamic title",
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
      # Start with the caption for the dropdown's default (first) colour, so
      # it's right before the server's update_reactable_caption() runs
      caption = paste(
        sort(unique(shinyGovstyle::transport_data$colours))[1],
        "vehicles by month"
      )
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
      list(
        "This is the content for Writing well for the web.",
        "This is the content for Writing well for specialists.",
        "This is the content for Know your audience.",
        # Rich block content: paragraph + bulleted list with a link
        shiny::tagList(
          shinyGovstyle::gov_text("People read in different ways, including:"),
          shinyGovstyle::gov_list(
            list(
              "scanning for key words",
              shinyGovstyle::external_link(
                "https://www.gov.uk",
                "following links to GOV.UK"
              )
            ),
            style = "bullet"
          )
        )
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
        page_size = 3
      )
    })

    # Keep the caption describing the filtered data. Runs inside
    # moduleServer(), so the id is namespaced automatically.
    shiny::observe({
      shinyGovstyle::update_reactable_caption(
        session,
        "interactive_table_test",
        paste(input$colourFilter, "vehicles by month")
      )
    })
  })
}
