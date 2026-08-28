test_that("default button has plain govuk-button class and renders label", {
  btn <- button_Input("btnId", "Continue")

  expect_identical(
    htmltools::tagGetAttribute(btn, "class"),
    "govuk-button action-button"
  )
  expect_identical(htmltools::tagGetAttribute(btn, "id"), "btnId")
  expect_identical(tag_text(btn, "govuk-button"), "Continue")
  expect_no_tag(btn, "govuk-button__start-icon")
})

test_that("start button has start modifier and start-icon svg", {
  btn <- button_Input("btnId", "Start now", type = "start")

  expect_identical(
    htmltools::tagGetAttribute(btn, "class"),
    "govuk-button govuk-button--start action-button"
  )
  expect_identical(tag_text(btn, "govuk-button"), "Start now")

  icon <- expect_has_tag(btn, "govuk-button__start-icon")
  expect_identical(icon$name, "svg")
})

test_that("secondary button has secondary modifier and no start-icon", {
  btn <- button_Input("btnId", "Cancel", type = "secondary")

  expect_identical(
    htmltools::tagGetAttribute(btn, "class"),
    "govuk-button govuk-button--secondary action-button"
  )
  expect_no_tag(btn, "govuk-button__start-icon")
})

test_that("warning button has warning modifier and no start-icon", {
  btn <- button_Input("btnId", "Delete", type = "warning")

  expect_identical(
    htmltools::tagGetAttribute(btn, "class"),
    "govuk-button govuk-button--warning action-button"
  )
  expect_no_tag(btn, "govuk-button__start-icon")
})
