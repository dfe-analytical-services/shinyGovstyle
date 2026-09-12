test_that("standard width adds the standard modifier class and no style", {
  wc <- gov_width_container("standard")
  expect_identical(
    wc$class,
    "govuk-width-container govuk-width-container--standard"
  )
  expect_null(wc$style)
})

test_that("a truly-unset width (is_default = TRUE) renders a bare class", {
  # This is what lets gov_page()'s ambient width CSS style it: a component
  # explicitly set to width = "standard" gets the --standard class above
  # (and stays standard even inside an ambient wide/full page), while a
  # component simply left at its default renders no modifier class at all,
  # so it's free to inherit the page's ambient width.
  wc <- gov_width_container("standard", is_default = TRUE)
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
