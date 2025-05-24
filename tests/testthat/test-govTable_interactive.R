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
  table_check <- govTable_interactive(
    df = example_data,
    right_col = c("Colours", "Bikes", "Cars", "Vans", "Buses"),
    col_widths = list(Months = "one-third"),
    page_size = 5
  )

  # Ensure the function runs without errors
  expect_silent(table_check)

  # Ensure it returns a reactable table
  expect_equal(table_check$x$tag$name, "Reactable")

  # Check if pagination settings are present
  expect_equal(table_check$x$tag$attribs$defaultPageSize, 5)

  # Check if the right alignment class is applied to Colours column
  expect_equal(table_check$x$tag$attribs$columns[[2]]$className, " govTable_right_align")

  # Check if column widths are correctly applied
  expect_equal(table_check$x$tag$attribs$columns[[1]]$className, "govuk-!-width-one-third ")

})
