test_that("file input works", {
  file_check <- file_Input("inputId", "Test")

  expect_identical(
    file_check$children[[1]]$children[[1]],
    "Test"
  )
})


test_that("file input HTML is as expected", {
  local_edition(3)
  expect_snapshot(file_Input(
    "inputId",
    "Test",
    multiple = T,
    accept = c(".xls")
  ))
})


test_that("file input error works", {
  file_check <- file_Input(
    "inputId",
    "Test",
    error = T,
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
