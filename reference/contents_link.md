# Contents link function

**\[experimental\]**

## Usage

``` r
contents_link(link_text, input_id, subcontents_text_list, subcontents_id_list)
```

## Arguments

- link_text:

  vector of link text for contents

- input_id:

  contents button Id

- subcontents_text_list:

  vector of link text for subcontents

- subcontents_id_list:

  vector of link Ids for subcontents. If missing automatically matches
  to Id in
  [`heading_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/heading_text.md)

## Value

an action button HTML shiny tag object

## Details

This function creates an action link to nav between tabs and optionally
link to subcontents headers.

This is experimental and may change in future.

## Examples

``` r
ui <- shiny::fluidPage(
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

        # Text types tab
        contents_link(
          "Text Types",
          "text_types_button",
          subcontents_text_list = c(
            "date_Input",
            "text_Input",
            "text_area_Input",
            "button_Input"
          ),
          subcontents_id_list = c(NA, NA, NA, "button_input_text_types")
        ),

        # Tables tabs and accordions tab
        contents_link(
          "Tables, tabs and accordions",
          "tables_tabs_and_accordions_button",
          subcontents_text_list = c(
            "govTable",
            "govTabs",
            "accordions",
            "button_Input"
          ),
          subcontents_id_list = c(
            NA,
            NA,
            NA,
            "button_input_tables_tabs_accordions"
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

      # Set up a nav panel so everything not on single page
      shiny::tabsetPanel(
        type = "hidden",
        id = "tab-container", # DO NOT REMOVE ID

        shiny::tabPanel(
          "Text Types",
          value = "text_types",
          gov_layout(
            size = "two-thirds",
            backlink_Input("back1"),
            heading_text("Page 2", size = "l"),
            label_hint(
              "label2",
              paste(
                "These are some examples of the",
                "types of user text inputs that you can use"
              )
            ),
            heading_text("date_Input", size = "s"),
            date_Input(
              inputId = "date1",
              label = "What is your date of birth?",
              hint_label = "For example, 31 3 1980"
            ),
            heading_text("text_Input", size = "s"),
            text_Input(
              inputId = "txt1",
              label = "Event name"
            ),
            heading_text("text_area_Input", size = "s"),
            text_area_Input(
              inputId = "text_area1",
              label = "Can you provide more detail?",
              hint_label = paste(
                "Do not include personal or financial",
                "information, like your National Insurance",
                "number or credit card details."
              )
            ),
            text_area_Input(
              inputId = "text_area2",
              label = "How are you today?",
              hint_label = "Leave blank to trigger error",
              error = TRUE,
              error_message = "Please do not leave blank",
              word_limit = 300
            ),
            heading_text(
              "button_Input",
              size = "s",
              id = "button_input_text_types"
            ),
            button_Input("btn2", "Go to next page"),
            button_Input(
              "btn3",
              "Check for errors",
              type = "warning"
            )
          )
        ),

        shiny::tabPanel(
          "Tables, tabs and accordions",
          value = "tables_tabs_and_accordions",
          gov_layout(
            size = "two-thirds",
            backlink_Input("back2"),
            heading_text("Page 3", size = "l"),
            label_hint(
              "label3",
              paste(
                "These are some examples of using tabs",
                "type tables"
              )
            ),
            heading_text("govTable", size = "s"),
            heading_text("govTabs", size = "s"),
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
                paste(
                  "This is the content for Writing well",
                  "for the web."
                ),
                paste(
                  "This is the content for Writing well",
                  "for specialists."
                ),
                paste(
                  "This is the content for",
                  "Know your audience."
                ),
                "This is the content for How people read."
              )
            ),

            heading_text(
              "button_Input",
              size = "s",
              id = "button_input_tables_tabs_accordions"
            ),
            button_Input("btn4", "Go to next page"),
          )
        ),

        #################### Create cookie panel #########
        shiny::tabPanel(
          "Cookies",
          value = "panel-cookies",
          gov_layout(
            size = "two-thirds",
            heading_text("Cookie page", size = "l"),
            label_hint(
              "label-cookies",
              "This an example cookie page"
            )
          )
        )
      )
    )
  ), # end of main_col
  footer(TRUE)
) # end of gov_row

server <- function(input, output, session) {
  # Tab nav
  shiny::observeEvent(input$back2, {
    shiny::updateTabsetPanel(
      session,
      "tab-container",
      selected = "text_types"
    )
  })

  shiny::observeEvent(input$tables_tabs_and_accordions_button, {
    shiny::updateTabsetPanel(
      session,
      "tab-container",
      selected = "tables_tabs_and_accordions"
    )
  })

  shiny::observeEvent(input$cookies_button, {
    shiny::updateTabsetPanel(
      session,
      "tab-container",
      selected = "panel-cookies"
    )
  })
} # end of server

if (interactive()) shiny::shinyApp(ui = ui, server = server)
```
