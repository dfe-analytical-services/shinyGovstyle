test_that("standard width returns the base class and no style", {
  wc <- gov_width_container("standard")
  expect_identical(wc$class, "govuk-width-container")
  expect_null(wc$style)
})

test_that("wide width adds the wide modifier class and no style", {
  wc <- gov_width_container("wide")
  expect_identical(
    wc$class,
    "govuk-width-container govuk-width-container--wide"
  )
  expect_null(wc$style)
})

test_that("full width adds the full modifier class and no style", {
  wc <- gov_width_container("full")
  expect_identical(
    wc$class,
    "govuk-width-container govuk-width-container--full"
  )
  expect_null(wc$style)
})

test_that("a custom CSS length uses the wide class with an inline style", {
  wc <- gov_width_container("1400px")
  expect_identical(
    wc$class,
    "govuk-width-container govuk-width-container--wide"
  )
  expect_identical(wc$style, "max-width: 1400px;")

  wc_vw <- gov_width_container("90vw")
  expect_identical(wc_vw$style, "max-width: 90vw;")
})

test_that("an invalid width errors with a clear message", {
  expect_error(gov_width_container("massive"), "must be")
  expect_error(gov_width_container("100"), "must be")
})
