test_that("field works", {
  field_check <- input_field(
    legend = "List of three text boxes in a field",
    labels = c("Field 1", "Field 2", "Field 3"),
    inputIds = c("field1", "field2", "field3"),
    widths = c(30, 20, 10),
    error = TRUE
  )

  expect_equal(length(field_check), 3)

  errors <- find_tags(field_check, "govuk-error-message")
  expect_length(errors, 3L)

  error_classes <- vapply(
    errors,
    function(e) htmltools::tagGetAttribute(e, "class"),
    character(1L)
  )
  expect_true(all(error_classes == "govuk-error-message shinyjs-hide"))

  error_roles <- vapply(
    errors,
    function(e) htmltools::tagGetAttribute(e, "role"),
    character(1L)
  )
  expect_true(all(error_roles == "alert"))
})

test_that("field works with null width", {
  field_check <- input_field(
    legend = "List of three text boxes in a field",
    labels = c("Field 1", "Field 2", "Field 3"),
    inputIds = c("field1", "field2", "field3")
  )

  expect_equal(length(field_check), 3)
})

test_that("each label is programmatically associated with its input", {
  field_check <- input_field(
    legend = "Address",
    labels = c("Line 1", "Town"),
    inputIds = c("line1", "town")
  )

  labels <- find_tags(field_check, "govuk-label")
  inputs <- find_tags(field_check, "govuk-input")
  expect_identical(
    unname(vapply(labels, htmltools::tagGetAttribute, character(1L), "for")),
    c("line1", "town")
  )
  expect_identical(
    unname(vapply(inputs, htmltools::tagGetAttribute, character(1L), "id")),
    c("line1", "town")
  )
})

test_that("hidden error ids are never in the rendered aria-describedby", {
  # error_on() adds the error id at runtime; fields take no hint, so nothing
  # else is referenced when the page renders.
  field_check <- input_field(
    legend = "Address",
    labels = c("Line 1", "Town"),
    inputIds = c("line1", "town"),
    error = TRUE,
    error_message = "Required"
  )

  for (input in find_tags(field_check, "govuk-input")) {
    expect_null(htmltools::tagGetAttribute(input, "aria-describedby"))
  }
})
