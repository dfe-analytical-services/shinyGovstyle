test_that("default works", {
  layout_test <- gov_layout()

  expect_identical(
    htmltools::tagGetAttribute(layout_test, "id"),
    "main"
  )

  expect_identical(
    htmltools::tagGetAttribute(layout_test, "class"),
    "govuk-width-container govuk-main-wrapper"
  )

  expect_has_tag(layout_test, "govuk-grid-column-full")
})

test_that("width defaults to standard", {
  layout_test <- gov_layout()
  expect_null(htmltools::tagGetAttribute(layout_test, "style"))
  expect_no_tag(layout_test, "govuk-width-container--standard")
  expect_no_tag(layout_test, "govuk-width-container--wide")
  expect_no_tag(layout_test, "govuk-width-container--full")
})

test_that("width = 'standard' explicitly renders the standard class", {
  layout_test <- gov_layout(width = "standard")
  expect_has_tag(layout_test, "govuk-width-container--standard")
})

test_that("width = 'full' adds the full modifier class", {
  layout_test <- gov_layout(width = "full")
  expect_has_tag(layout_test, "govuk-width-container--full")
})

test_that("a custom width sets an inline max-width style", {
  layout_test <- gov_layout(width = "1400px")
  expect_identical(
    htmltools::tagGetAttribute(layout_test, "style"),
    "max-width: 1400px;"
  )
})
