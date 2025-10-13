months <- c("January", "February", "March")
bikes <- c("£85", "£75", "£165")
cars <- c("£95", "£55", "£125")

example_data <- data.frame(months, bikes, cars)

ui <- shiny::fluidPage(
  shinyGovstyle::govTable(
    "tab1",
    example_data,
    "Test",
    "l",
    num_col = c(2, 3),
    width_overwrite = c("one-half", "one-quarter", "one-quarter")
  )
)

server <- function(input, output, session) {}

if (interactive()) {
  shiny::shinyApp(ui = ui, server = server)
}


ui2 <- bslib::page_fluid(
  shinyGovstyle::govTable(
    "tab1",
    example_data,
    "Test",
    "l",
    num_col = c(2, 3),
    width_overwrite = c("one-half", "one-quarter", "one-quarter")
  )
)

if (interactive()) {
  shiny::shinyApp(ui = ui2, server = server)
}
