test_that("error_summary works", {
  error_summary <- error_summary(
    "error1",
    "Error Title",
    c("error entry 1", "error entry 2")
  )

  # Check InputID
  expect_identical(
    error_summary$attribs$id,
    "error1"
  )

  # Check class
  expect_identical(
    error_summary$attribs$class,
    "govuk-error-summary"
  )

  # Check error_title class
  expect_identical(
    error_summary$children[[1]]$attribs$class,
    "govuk-error-summary__title"
  )

  # Check error_title value
  expect_identical(
    error_summary$children[[1]]$children[[1]],
    "Error Title"
  )

  # Check error_summary body class
  expect_identical(
    error_summary$children[[2]]$attribs$class,
    "govuk-error-summary__body"
  )

  # Check error_list class
  expect_identical(
    error_summary$children[[2]]$children[[1]]$attribs$class,
    "govuk-list govuk-error-summary__list"
  )

  # Check error_list values
  expect_identical(
    names(error_summary$children[[2]]$children[[1]]$children[[1]]),
    c("error entry 1", "error entry 2")
  )
})
