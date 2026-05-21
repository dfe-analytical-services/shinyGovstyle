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

  expect_identical(
    payload,
    paste(
      "<ul class=\"govuk-list govuk-error-summary__list\">",
      "  <li>first</li>",
      "  <li>second</li>",
      "  <li>third</li>",
      "</ul>",
      sep = "\n"
    )
  )
})
