test_that("table works", {
  # Sample data
  months <- rep(c("January", "February", "March", "April", "May"), times = 2)
  colours <- rep(c("Red", "Blue"), times = 5)
  bikes <- c(85, 75, 165, 90, 80, 95, 85, 175, 100, 95)
  cars <- c(95, 55, 125, 110, 70, 120, 60, 130, 115, 90)
  vans <- c(150, 130, 180, 160, 140, 175, 135, 185, 155, 145)
  buses <- c(200, 180, 220, 210, 190, 215, 185, 225, 205, 195)
  example_data <- data.frame(months, colours, bikes, cars, vans, buses)

  # Test table with sorting and pagination enabled
  table_check <- govReactable(
    df = example_data,
    right_col = c("Colours", "Bikes", "Cars", "Vans", "Buses"),
    page_size = 5
  )

  # Ensure the function runs without errors
  expect_no_error(table_check)

  # Take snapshot of table HTML
  output_html <- htmltools::renderTags(table_check)$html

  # Prevent unnecessary changes due to random IDs
  stripped_ids <- gsub('"htmlwidget-[^"]*"', "", output_html)

  expect_snapshot(stripped_ids)
})
