# Test for color class when a specific color is set
test_that("value_box color class works", {
  box_yellow <- value_box("testId2", "Test Value", colour = "yellow")

  # Check that the container class includes both "value-box-container" and the color
  expect_identical(box_yellow$attribs$class, "value-box-container govuk-tag--yellow")
})

# Test default values (when no text is provided)
test_that("value_box default values work", {
  box_default <- value_box("testId3")

  # Check default value
  expect_identical(box_default$children[[1]]$children[[1]], "your value goes here")

  # Check that text is NULL when not provided
  expect_null(box_default$children[[2]])

  # Check default color class
  expect_identical(box_default$attribs$class, "value-box-container govuk-tag--blue")
})
