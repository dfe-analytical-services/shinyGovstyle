test_that("error_summary works", {
  error_summary <- error_summary(
    "error1",
    "Error Title",
    c("error entry 1", "error entry 2")
  )

  expect_identical(
    error_summary$attribs$id,
    "error1"
  )

  expect_identical(
    error_summary$attribs$class,
    "govuk-error-summary"
  )

  expect_snapshot(error_summary)
})
