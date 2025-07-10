test_that("default works", {
  layout_test <- gov_layout()

  expect_identical(
    layout_test$attribs$id,
    "main"
  )

  expect_identical(
    layout_test$attribs$class,
    "govuk-width-container  govuk-main-wrapper"
  )

  expect_identical(
    layout_test$children[[1]]$attribs$class,
    "govuk-grid-column-full"
  )
})
