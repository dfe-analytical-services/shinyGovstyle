mod_action_types_ui <- function(id) {
  shiny::tagList(
    shinyGovstyle::heading_text("Action types", size = "l"),
    shinyGovstyle::label_hint(
      "label3",
      "These are some examples of the types of user
           action elements that you can use"
    ),
    shinyGovstyle::heading_text("external_link", size = "s", level = 2),
    shinyGovstyle::gov_text(
      paste0(
        "You can add external links with automatic ",
        "formatting such as to our "
      ),
      shinyGovstyle::external_link(
        href = paste0(
          "https://github.com/dfe-analytical-services/",
          "shinyGovstyle"
        ),
        link_text = "GitHub repository",
      ),
      "."
    ),
    shinyGovstyle::gov_text(
      paste0(
        "When displaying several external links together, you can set ",
        "add_warning = FALSE and add a single note above the group ",
        "instead of repeating the warning on every link:"
      )
    ),
    shinyGovstyle::gov_text("The following links open in a new tab."),
    shinyGovstyle::gov_list(
      list = list(
        shinyGovstyle::external_link(
          href = paste0(
            "https://dfe-analytical-services.github.io/",
            "shinyGovstyle/"
          ),
          link_text = "package documentation site",
          add_warning = FALSE
        ),
        shinyGovstyle::external_link(
          href = paste0(
            "https://dfe-analytical-services.github.io/",
            "shinyGovstyle/CONTRIBUTING.html"
          ),
          link_text = "contributing guidelines",
          add_warning = FALSE
        )
      ),
      style = "bullet"
    ),
    shinyGovstyle::gov_text(
      paste(
        "Or set add_warning = \"icon\" to show a small visual icon",
        "instead of the bracketed text, such as this link to our "
      ),
      shinyGovstyle::external_link(
        href = paste0(
          "https://dfe-analytical-services.github.io/",
          "shinyGovstyle/news/index.html"
        ),
        link_text = "changelog",
        add_warning = "icon"
      ),
      "."
    ),
    shinyGovstyle::heading_text("download_button", size = "s", level = 2),
    shinyGovstyle::download_button(
      shiny::NS(id, "download_button_data"),
      "Download a demo data set",
      file_type = "CSV",
      file_size = "1 KB"
    ),
    shinyGovstyle::heading_text("download_link", size = "s", level = 2),
    shinyGovstyle::gov_text(
      shinyGovstyle::download_link(
        shiny::NS(id, "download_data"),
        "Download a demo data set",
        file_type = "CSV",
        file_size = "1 KB"
      )
    ),
    shinyGovstyle::heading_text("download_radios", size = "s", level = 2),
    shinyGovstyle::gov_text(
      shinyGovstyle::download_radios(
        file_types = c("CSV", "XLSX", "ODS")
      )
    )
  )
}

mod_action_types_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    output$download_data <- shiny::downloadHandler(
      filename = "demo_data.csv",
      content = function(file) {
        data <- data.frame(
          x = 1:10,
          y = 101:110
        )
        write.csv(data, file)
      }
    )

    output$download_button_data <- shiny::downloadHandler(
      filename = "demo_button_data.csv",
      content = function(file) {
        data <- data.frame(
          x = 1:10,
          y = 1:10**3
        )
        write.csv(data, file)
      }
    )
  })
}
