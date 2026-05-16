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
})

test_that("field works with null width", {
  field_check <- input_field(
    legend = "List of three text boxes in a field",
    labels = c("Field 1", "Field 2", "Field 3"),
    inputIds = c("field1", "field2", "field3")
  )

  expect_equal(length(field_check), 3)
})
