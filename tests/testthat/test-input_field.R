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

  expect_identical(
    htmltools::tagGetAttribute(errors[[1]], "class"),
    "govuk-error-message shinyjs-hide"
  )
})

test_that("field works with null width", {
  field_check <- input_field(
    legend = "List of three text boxes in a field",
    labels = c("Field 1", "Field 2", "Field 3"),
    inputIds = c("field1", "field2", "field3")
  )

  expect_equal(length(field_check), 3)
})
