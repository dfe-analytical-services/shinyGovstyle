test_that("error_summary_update dispatches html() to the list slot", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_summary_update("errorId", c("first", "second")),
    html = r$record("html"),
    .package = "shinyjs"
  )

  html_calls <- calls_for(r, "html")
  expect_length(html_calls, 1L)
  expect_identical(
    recorded_arg(html_calls[[1L]], "id", 1L),
    "errorIdlist"
  )
})

test_that("error_summary_update renders the GOV.UK list wrapper and entries", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_summary_update("errorId", c("first", "second", "third")),
    html = r$record("html"),
    .package = "shinyjs"
  )

  payload <- recorded_arg(calls_for(r, "html")[[1L]], "html", 2L)

  # Assert the markup, not htmltools' pretty-printing: the newlines and
  # indentation in as.character() output belong to htmltools and can change
  # without this package changing. Unlike expect_snapshot() (cran = FALSE by
  # default), this test runs on CRAN, so pinning them would turn an htmltools
  # release into a CRAN check failure. Collapsing the whitespace between tags
  # keeps the wrapper class and the entries (and their order) under test.
  expect_identical(
    gsub("[[:space:]]*\n[[:space:]]*", "", payload),
    paste0(
      "<ul class=\"govuk-list govuk-error-summary__list\">",
      "<li>first</li><li>second</li><li>third</li>",
      "</ul>"
    )
  )
})
