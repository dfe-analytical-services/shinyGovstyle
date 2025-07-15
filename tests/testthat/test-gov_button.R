test_that("throws error", {
  expect_error(button_Input("foo", button_type = "bar"))
})

test_that("button works", {
  button <- button_Input("btn1", "Click me")

  expect_identical(
    button$attribs$id,
    "btn1"
  )

  expect_identical(
    button$attribs$class,
    "govuk-button action-button"
  )

  expect_identical(
    "Click me",
    button$children[[1]]
  )
})

test_that("start_button works", {
  button <- button_Input("btn1", "Click me", type = "start")

  expect_identical(
    button$attribs$id,
    "btn1"
  )

  expect_identical(
    button$attribs$class,
    "govuk-button govuk-button--start action-button"
  )

  expect_identical(
    "Click me",
    button$children[[1]]
  )
})

test_that("secondary_button works", {
  button <- button_Input("btn1", "Click me", type = "secondary")

  expect_identical(
    button$attribs$id,
    "btn1"
  )

  expect_identical(
    button$attribs$class,
    "govuk-button govuk-button--secondary action-button"
  )

  expect_identical(
    "Click me",
    button$children[[1]]
  )
})

test_that("warning_button works", {
  button <- button_Input("btn1", "Click me", type = "warning")

  expect_identical(
    button$attribs$id,
    "btn1"
  )

  expect_identical(
    button$attribs$class,
    "govuk-button govuk-button--warning action-button"
  )

  expect_identical(
    "Click me",
    button$children[[1]]
  )
})
