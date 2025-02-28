test_that("table works", {

  # Sample data
  Months <- rep(c("January", "February", "March", "April", "May"), times = 2)
  Colours <- rep(c("Red", "Blue"), times = 5)
  Bikes <- c(85, 75, 165, 90, 80, 95, 85, 175, 100, 95)
  Cars <- c(95, 55, 125, 110, 70, 120, 60, 130, 115, 90)
  Vans <- c(150, 130, 180, 160, 140, 175, 135, 185, 155, 145)
  Buses <- c(200, 180, 220, 210, 190, 215, 185, 225, 205, 195)
  example_data <- data.frame(Months, Colours, Bikes, Cars, Vans, Buses)

  # Test table with sorting and pagination enabled
  table_check <- govTable(
    inputId = "tab1",
    df = example_data,
    caption = "Test",
    right_col = c("Colours", "Bikes", "Cars", "Vans", "Buses"),
    col_widths = list(Months = "one-third"),
    page_size = 5
  )

  # Ensure the function runs without errors
  expect_silent(table_check)

  # Ensure it returns an HTML div
  expect_s3_class(table_check, "shiny.tag")
  expect_equal(table_check$name, "div")

  # Convert to HTML string for content verification
  table_html <- as.character(table_check)

  # Check if sorting is enabled
  expect_match(table_html, "sortable", fixed = TRUE)

  # Check if pagination settings are present
  expect_match(table_html, "defaultPageSize", fixed = TRUE)

  # Check if the right alignment class is applied
  expect_match(table_html, "govTable_right_align", fixed = TRUE)

  # Check if the "Colours" column has the right alignment class
  expect_match(table_html, '"id":"Colours",".*"className":" ?govTable_right_align"', perl = TRUE)

  # Check if column widths are correctly applied
  expect_match(table_html, "govuk-!-width-one-third", fixed = TRUE)

})
