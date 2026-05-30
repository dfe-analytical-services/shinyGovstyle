test_that("default works", {
  layout_test <- gov_layout()

  expect_identical(
    htmltools::tagGetAttribute(layout_test, "id"),
    "main"
  )

  expect_identical(
    htmltools::tagGetAttribute(layout_test, "class"),
    "govuk-width-container  govuk-main-wrapper"
  )

  expect_identical(
    htmltools::tagGetAttribute(layout_test$children[[1]], "class"),
    "govuk-grid-column-full"
  )
})
