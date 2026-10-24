test_that("throws error", {
  expect_error(button_Input("foo", button_type = "bar"))
})

test_that("button works", {
  button <- button_Input("btn1", "Click me")

  expect_identical(
    htmltools::tagGetAttribute(button, "id"),
    "btn1"
  )

  expect_identical(
    htmltools::tagGetAttribute(button, "class"),
    "govuk-button action-button"
  )

  expect_identical(
    "Click me",
    tag_text(button, "govuk-button")
  )
})

test_that("start_button works", {
  button <- button_Input("btn1", "Click me", type = "start")

  expect_identical(
    htmltools::tagGetAttribute(button, "id"),
    "btn1"
  )

  expect_identical(
    htmltools::tagGetAttribute(button, "class"),
    "govuk-button govuk-button--start action-button"
  )

  # A start button carries the label plus the arrow svg, so assert the label
  # child rather than reaching for the single-child tag_text().
  expect_identical(
    "Click me",
    rendered_children(button)[[1L]]
  )
})

test_that("secondary_button works", {
  button <- button_Input("btn1", "Click me", type = "secondary")

  expect_identical(
    htmltools::tagGetAttribute(button, "id"),
    "btn1"
  )

  expect_identical(
    htmltools::tagGetAttribute(button, "class"),
    "govuk-button govuk-button--secondary action-button"
  )

  expect_identical(
    "Click me",
    tag_text(button, "govuk-button")
  )
})

test_that("warning_button works", {
  button <- button_Input("btn1", "Click me", type = "warning")

  expect_identical(
    htmltools::tagGetAttribute(button, "id"),
    "btn1"
  )

  expect_identical(
    htmltools::tagGetAttribute(button, "class"),
    "govuk-button govuk-button--warning action-button"
  )

  expect_identical(
    "Click me",
    tag_text(button, "govuk-button")
  )
})
