
    Months <- rep(c("January", "February", "March", "April", "May"), times = 2)
    Colours <- rep(c("Red", "Blue"), times = 5)
    Bikes <- c(85, 75, 165, 90, 80, 95, 85, 175, 100, 95)
    Cars <- c(95, 55, 125, 110, 70, 120, 60, 130, 115, 90)
    Vans <- c(150, 130, 180, 160, 140, 175, 135, 185, 155, 145)
    Buses <- c(200, 180, 220, 210, 190, 215, 185, 225, 205, 195)
    example_data <- data.frame(Months, Colours, Bikes, Cars, Vans, Buses)


    ui <- fluidPage(
      shinyGovstyle::header(
        main_text = "Example",
        secondary_text = "User Examples",
        logo="shinyGovstyle/images/moj_logo.png",logo_alt_text = "logo"),
      shinyGovstyle::banner(
        inputId = "banner", type = "beta", 'This is a new service'),
      shinyGovstyle::gov_layout(size = "two-thirds",
        govTable_interactive(
          "tab1", example_data, caption = "Test Table",
          right_col = c("Colours", "Bikes", "Cars", "Vans", "Buses"),
          col_widths = list(Months = "one-third"),
          page_size = 5
          ),

        br(),
        selectInput("colourFilter", "Colour",
                    choices = c(sort(unique(example_data$Colours)))),

        heading_text("govTable_interactive", size = "s"),
        govTable_interactiveOutput("interactive_table_test", caption = "testiiiiing"),

        br(),
        govTable_interactiveOutput("reactable_test", caption = "reactable")

      ),

      shinyGovstyle::footer(full = TRUE)
    )

    server <- function(input, output, session) {


      filtered_data <- reactive({

        example_data %>% filter(Colours == input$colourFilter)


      })



      output$interactive_table_test <- render_govTable_interactive(govTable_interactive(

          df=filtered_data(),
          caption = "testiiiing title",
          right_col = c("Colours","Bikes", "Cars", "Vans", "Buses"),
          col_widths = list(Months = "one-third"),
          page_size = 3
        )
        )

      output$reactable_test <- renderReactable(govTable_interactive(

        df=filtered_data(),
        caption = "reactable_test",
        right_col = c("Colours","Bikes", "Cars", "Vans", "Buses"),
        col_widths = list(Months = "one-third"),
        page_size = 3
      ))







        # render_govTable_interactive(
        #
        # shinyGovstyle::govTable_interactive(
        #   "tab1", filtered_data(), "Test interactive example", #"l",
        #   right_col = c("Colours", "Bikes", "Cars", "Vans", "Buses"),
        #   col_widths = list(Months = "one-third"),
        #   page_size = 5
        # ))


    }

    shinyApp(ui, server)

