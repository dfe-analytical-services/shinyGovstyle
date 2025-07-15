test_that("text box works", {
  text_check <- text_Input("txtId", "Text test")

  expect_identical(
    text_check$children[[1]]$children[[1]],
    shiny::HTML("Text test")
  )
})

test_that("text width change", {
  text_check <- text_Input("txtId", "Text test", width = 30)

  expect_identical(
    text_check$children[[4]]$attribs$class,
    "govuk-input govuk-input--width-30"
  )
})


test_that("text box error works", {
  text_check <- text_Input(
    "txtId",
    "Text test",
    error = TRUE,
    error_message = "Error test"
  )

  expect_identical(text_check$children[[3]]$children[[1]], "Error test")

  expect_identical(
    paste(
      text_check$children[[3]]$attribs$class,
      text_check$children[[3]]$attribs[3]$class
    ),
    "govuk-error-message shinyjs-hide"
  )
})

test_that("text box prefix works", {
  text_check <- text_Input("txtId", "Text test", prefix = "£")

  expect_identical(text_check$children[[4]]$children[[1]]$children[[1]], "£")
})

test_that("text box suffix works", {
  text_check <- text_Input("txtId", "Text test", suffix = ".00")

  expect_identical(text_check$children[[4]]$children[[2]]$children[[1]], ".00")
})

test_that("text box prefix suffix works", {
  text_check <- text_Input("txtId", "Text test", prefix = "£", suffix = ".00")

  expect_identical(text_check$children[[4]]$children[[1]]$children[[1]], "£")
  expect_identical(text_check$children[[4]]$children[[3]]$children[[1]], ".00")
})
