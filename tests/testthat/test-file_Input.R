test_that("file input works", {
  file_check <- file_Input("inputId", "Test")

  expect_identical(
    tag_text(file_check, "govuk-label"),
    "Test"
  )
})

test_that("multiple and accept are wired onto the hidden file input", {
  file_check <- file_Input(
    "inputId",
    "Test",
    multiple = TRUE,
    accept = c(".xls")
  )

  # The hidden <input type="file"> is the only descendant whose id is exactly
  # the inputId (child wrapper ids are suffixed with div / file_div / error).
  hidden_input <- find_by_id_suffix(file_check, "inputId")
  expect_identical(htmltools::tagGetAttribute(hidden_input, "type"), "file")
  expect_identical(htmltools::tagGetAttribute(hidden_input, "name"), "inputId")
  expect_identical(
    htmltools::tagGetAttribute(hidden_input, "multiple"),
    "multiple"
  )
  expect_identical(htmltools::tagGetAttribute(hidden_input, "accept"), ".xls")
})

test_that("accept joins multiple MIME types with a comma", {
  file_check <- file_Input(
    "inputId",
    "Test",
    accept = c(".xls", ".csv")
  )

  hidden_input <- find_by_id_suffix(file_check, "inputId")
  expect_identical(
    htmltools::tagGetAttribute(hidden_input, "accept"),
    ".xls,.csv"
  )
})

test_that("multiple defaults off (no multiple attribute)", {
  file_check <- file_Input("inputId", "Test")
  hidden_input <- find_by_id_suffix(file_check, "inputId")
  expect_null(htmltools::tagGetAttribute(hidden_input, "multiple"))
})

test_that("file input error works", {
  file_check <- file_Input(
    "inputId",
    "Test",
    error = TRUE,
    error_message = "Error test"
  )

  expect_hidden_error(file_check, "Error test")
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

test_that("question label names the file input, not the button text", {
  file_check <- file_Input("inputId", "Upload your report")

  label <- find_by_id_suffix(file_check, "inputId-label")
  expect_identical(htmltools::tagGetAttribute(label, "for"), "inputId")
  expect_null(htmltools::tagGetAttribute(label, "tabindex"))

  # The input sits inside the "Choose file" button label, so it needs
  # aria-labelledby to take the question as its accessible name.
  hidden_input <- find_by_id_suffix(file_check, "inputId")
  expect_identical(
    htmltools::tagGetAttribute(hidden_input, "aria-labelledby"),
    "inputId-label"
  )
})

test_that("hidden error id is never in the rendered aria-describedby", {
  file_check <- file_Input(
    "inputId",
    "Test",
    error = TRUE,
    error_message = "Error test"
  )

  hidden_input <- find_by_id_suffix(file_check, "inputId")
  expect_null(htmltools::tagGetAttribute(hidden_input, "aria-describedby"))
})
