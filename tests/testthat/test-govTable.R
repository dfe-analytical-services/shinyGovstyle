test_that("table works", {

    Months <- c("January", "February", "March")
    Bikes <- c("£85", "£75", "£165")
    Cars <- c("£95", "£55", "£125")

    example_data <- data.frame(Months, Bikes, Cars)

  # test table with specified widths
  table_check <- govTable(
    "tab1", example_data, "Test", "l", num_col = c(2,3),
    width_overwrite = c("one-half", "one-quarter", "one-quarter"))

  expect_identical(
    table_check$children[[2]]$children[[1]][[3]][[1]][[1]]$attribs$class,
    "govuk-table__header govuk-!-width-one-half"
  )

  expect_identical(
    table_check$children[[2]]$children[[1]][[3]][[1]][[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric govuk-!-width-one-quarter"
  )

  expect_equal(
    length(table_check$children[[3]]),
    3
  )

# test table with unspecified widths
  table_check2 <- govTable(
    "tab2", example_data, "Test", "l", num_col = c(2,3),
    width_overwrite = NULL)

  expect_identical(
    table_check2$children[[2]]$children[[1]][[3]][[1]][[1]]$attribs$class,
    "govuk-table__header"
  )

  expect_identical(
    table_check2$children[[2]]$children[[1]][[3]][[1]][[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric"
  )

  expect_equal(
    length(table_check2$children[[3]]),
    3
  )


  # and if the argument isn't mentioned at all
  table_check3 <- govTable(
    "tab2", example_data, "Test", "l", num_col = c(2,3))

  expect_identical(
    table_check3$children[[2]]$children[[1]][[3]][[1]][[1]]$attribs$class,
    "govuk-table__header"
  )

  expect_identical(
    table_check3$children[[2]]$children[[1]][[3]][[1]][[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric"
  )

  expect_equal(
    length(table_check3$children[[3]]),
    3
  )


})
