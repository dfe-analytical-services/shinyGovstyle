test_that("text area works", {
  text_area_check <- text_area_Input("input1", "Test area")

  expect_equal(
    text_area_check$children[[4]]$attribs$rows,
    5
  )

  expect_identical(
    text_area_check$children[[1]]$children[[1]],
    shiny::HTML("Test area")
  )
})


test_that("text area error works", {
  text_area_check <- text_area_Input(
    "input1",
    "Test area",
    error = TRUE,
    error_message = "Test error",
    row_no = 10
  )

  expect_equal(
    text_area_check$children[[4]]$attribs$rows,
    10
  )

  expect_identical(
    paste(
      text_area_check$children[[3]]$attribs$class,
      text_area_check$children[[3]]$attribs[3]$class
    ),
    "govuk-error-message shinyjs-hide"
  )

  expect_identical(
    text_area_check$children[[3]]$children[[1]],
    "Test error"
  )
})

test_that("text area word works", {
  text_area_check <- text_area_Input("input1", "Test area", word_limit = 300)

  expect_identical(
    paste(
      text_area_check$children[[5]]$children[[1]]$children[[1]],
      text_area_check$children[[5]]$children[[2]]$children[[1]],
      text_area_check$children[[5]]$children[[3]]$children[[1]]
    ),
    "You have used 0 of the 300 allowed"
  )

  expect_identical(
    text_area_check$children[[5]]$attribs$class,
    "govuk-hint govuk-character-count__message"
  )
})
