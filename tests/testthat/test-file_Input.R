test_that("file input works", {
  file_check <- file_Input("inputId", "Test")

  expect_identical(
    file_check$children[[1]]$children[[1]],
    "Test"
  )
})


test_that("file input works 2", {
  file_check <- file_Input(
    "inputId",
    "Test",
    multiple = TRUE,
    accept = c(".xls")
  )

  in_child <-
    file_check$children[[3]]$children[[1]]$children[[1]]$children[[2]]

  expect_identical(
    in_child$attribs$accept,
    ".xls"
  )

  expect_identical(
    file_check$children[[1]]$children[[1]],
    "Test"
  )
})

test_that("file input error works", {
  file_check <- file_Input(
    "inputId",
    "Test",
    error = TRUE,
    error_message = "Error test"
  )

  expect_identical(
    file_check$children[[2]]$children[[1]],
    "Error test"
  )

  expect_identical(
    paste(
      file_check$children[[2]]$attribs$class,
      file_check$children[[2]]$attribs[3]$class
    ),
    "govuk-error-message shinyjs-hide"
  )
})
