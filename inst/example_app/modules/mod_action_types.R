mod_action_types_ui <- function(id) {
  gov_layout(
    size = "two-thirds",
    heading_text("Action types", size = "l"),
    label_hint(
      "label3",
      "These are some examples of the types of user
           action elements that you can use"
    ),
    heading_text("external_link", size = "s", level = 2),
    gov_text(
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
      paste(
        "You can also add external links that don't have the",
        "warning in brackets but do have the warning for screen",
        "readers, such as this link to our "
      ),
      shinyGovstyle::external_link(
        href = paste0(
          "https://dfe-analytical-services.github.io/",
          "shinyGovstyle/"
        ),
        link_text = "package documentation site",
        add_warning = FALSE
      ),
      "."
    ),
    heading_text("download_button", size = "s", level = 2),
    shinyGovstyle::download_button(
      NS(id, "download_button_data"),
      "Download a demo data set",
      file_type = "CSV",
      file_size = "1 KB"
    ),
    heading_text("download_link", size = "s", level = 2),
    shinyGovstyle::gov_text(
      shinyGovstyle::download_link(
        NS(id, "download_data"),
        "Download a demo data set",
        file_type = "CSV",
        file_size = "1 KB"
      )
    ),
    heading_text("download_radios", size = "s", level = 2),
    shinyGovstyle::gov_text(
      shinyGovstyle::download_radios(
        file_types = c("CSV", "XLSX", "ODS")
      )
    )
  )
}

mod_action_types_server <- function(id) {
  moduleServer(id, function(input, output, session) {
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
