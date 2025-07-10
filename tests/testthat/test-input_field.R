test_that("field works", {
  field_check <- input_field(
    legend = "List of three text boxes in a field",
    labels = c("Field 1", "Field 2", "Field 3"),
    inputIds = c("field1", "field2", "field3"),
    widths = c(30, 20, 10),
    error = TRUE
  )

  expect_equal(length(field_check), 3)

  expect_identical(
    paste(
      field_check$children[[2]]$`Field 1`$children[[2]]$attribs$class,
      field_check$children[[2]]$`Field 1`$children[[2]]$attribs[3]$class
    ),
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
