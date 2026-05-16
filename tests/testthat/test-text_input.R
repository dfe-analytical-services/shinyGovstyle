test_that("text box works", {
  text_check <- text_Input("txtId", "Text test")

  expect_identical(
    tag_text(text_check, "govuk-label"),
    shiny::HTML("Text test")
  )
})

test_that("text width change", {
  text_check <- text_Input("txtId", "Text test", width = 30)

  expect_identical(
    htmltools::tagGetAttribute(find_tag(text_check, "govuk-input"), "class"),
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

  expect_hidden_error(text_check, "Error test")
})

test_that("text box prefix works", {
  text_check <- text_Input("txtId", "Text test", prefix = "£")

  expect_identical(
    tag_text(text_check, "govuk-input__prefix"),
    "£"
  )
})

test_that("text box suffix works", {
  text_check <- text_Input("txtId", "Text test", suffix = ".00")

  expect_identical(
    tag_text(text_check, "govuk-input__suffix"),
    ".00"
  )
})

test_that("text box prefix suffix works", {
  text_check <- text_Input("txtId", "Text test", prefix = "£", suffix = ".00")

  expect_identical(
    tag_text(text_check, "govuk-input__prefix"),
    "£"
  )
  expect_identical(
    tag_text(text_check, "govuk-input__suffix"),
    ".00"
  )
})

test_that("form group children appear in GOV.UK order", {
  text_check <- text_Input(
    "txtId",
    "Text test",
    error = TRUE,
    error_message = "Error test"
  )

  expect_identical(
    htmltools::tagGetAttribute(text_check, "class"),
    "govuk-form-group"
  )
  expect_identical(
    child_classes(text_check),
    c(
      "govuk-label",
      "govuk-hint",
      "govuk-error-message shinyjs-hide",
      "govuk-input"
    )
  )
})
