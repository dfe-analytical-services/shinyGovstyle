test_that("date default works", {
  date_check <- date_Input("dateid", "Test Date")

  expect_equal(length(date_check$children[[1]]$children[[4]]), 3)

  expect_identical(
    date_check$children[[1]]$children[[4]]$attribs$class,
    "govuk-date-input"
  )
})

test_that("date error works", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    error = TRUE,
    error_message = "Error test"
  )

  expect_equal(length(date_check$children[[1]]$children[[4]]), 3)

  expect_identical(
    paste(
      date_check$children[[1]]$children[[2]]$attribs$class,
      date_check$children[[1]]$children[[2]]$attribs[3]$class
    ),
    "govuk-error-message shinyjs-hide"
  )

  expect_identical(
    date_check$children[[1]]$children[[2]]$children[[1]],
    "Error test"
  )
})


test_that("date defaults values works", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    day = 1,
    month = 2,
    year = 2020
  )

  expect_equal(length(date_check$children[[1]]$children[[4]]), 3)

  date_child <- date_check$children[[1]]$children[[4]]
  expect_equal(
    date_child$children[[1]]$children[[1]]$children[[2]]$attribs$value,
    1
  )

  expect_equal(
    date_child$children[[2]]$children[[1]]$children[[2]]$attribs$value,
    2
  )

  expect_equal(
    date_child$children[[3]]$children[[1]]$children[[2]]$attribs$value,
    2020
  )
})
