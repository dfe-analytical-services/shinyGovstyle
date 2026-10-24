# Test for color class when a specific color is set
test_that("value_box color class works", {
  box_yellow <- value_box("testId2", "Test Value", colour = "yellow")

  # Check that the container class includes both
  # "value-box-container" and the color
  expect_identical(
    htmltools::tagGetAttribute(box_yellow, "class"),
    "value-box-container govuk-tag--yellow"
  )
})

# Test default values (when no text is provided)
test_that("value_box default values work", {
  box_default <- value_box()

  # Check default value
  expect_identical(
    tag_text(box_default, "value-box-value"),
    "your value goes here"
  )

  # Check that no description is rendered when text is not provided
  expect_no_tag(box_default, "value-box-description")

  # Check default color class
  expect_identical(
    htmltools::tagGetAttribute(box_default, "class"),
    "value-box-container govuk-tag--blue"
  )
})


test_that("deprecated colours are warned against", {
  expect_warning(
    value_box("testId3", "Test Value", colour = "light-blue"),
    paste(
      "'light-blue' is no longer a supported colour.",
      "Please select an alternative from: 'grey', 'purple', 'teal', 'blue',",
      "'yellow', 'orange', 'red', 'magenta', or 'green'."
    ),
    fixed = TRUE
  )
})


test_that("unknown colours warn and list the supported options", {
  # "navy" is a gov_tag() colour but not a value_box() one
  for (colour in c("rainbow", "navy")) {
    expect_warning(
      value_box("Test Value", colour = colour),
      paste0(
        "'",
        colour,
        "' is not a supported colour. Please select an alternative from: ",
        "'grey', 'purple', 'teal', 'blue', 'yellow', 'orange', 'red', ",
        "'magenta', or 'green'."
      ),
      fixed = TRUE
    )
  }
  expect_no_warning(value_box("Test Value", colour = "green"))
})


test_that("a colour that is not a single string errors clearly", {
  for (colour in list(NULL, NA_character_, 1, c("red", "blue"))) {
    expect_error(
      value_box("Test Value", colour = colour),
      "`colour` must be a single character string.",
      fixed = TRUE
    )
  }
})
