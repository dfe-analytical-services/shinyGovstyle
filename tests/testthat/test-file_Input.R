test_that("file input works", {
  file_check <- file_Input("inputId", "Test")

  expect_identical(
    tag_text(file_check, "govuk-label"),
    "Test"
  )
})

test_that("file input HTML is as expected", {
  local_edition(3)
  expect_snapshot(file_Input(
    "inputId",
    "Test",
    multiple = TRUE,
    accept = c(".xls")
  ))
})

test_that("file input error works", {
  file_check <- file_Input(
    "inputId",
    "Test",
    error = TRUE,
    error_message = "Error test"
  )

  err <- find_tag(file_check, "govuk-error-message")
  expect_length(find_tags(file_check, "govuk-error-message"), 1L)
  expect_identical(err$children[[1]], "Error test")

  expect_identical(
    htmltools::tagGetAttribute(err, "class"),
    "govuk-error-message shinyjs-hide"
  )
})

test_that("form group children appear in GOV.UK order", {
  file_check <- file_Input(
    "inputId",
    "Test",
    error = TRUE,
    error_message = "Error test"
  )

  expect_identical(
    htmltools::tagGetAttribute(file_check, "class"),
    "govuk-form-group"
  )
  expect_identical(
    child_classes(file_check),
    c(
      "govuk-label",
      "govuk-error-message shinyjs-hide",
      "input-group govuk-file-upload"
    )
  )
})
