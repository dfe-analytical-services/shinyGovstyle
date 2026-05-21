test_that("error_on flags the form group div as in-error", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    .package = "shinyjs"
  )

  form_group_calls <- Filter(
    function(c) {
      identical(recorded_arg(c, "id", 1L), "eventIddiv") &&
        identical(recorded_arg(c, "class", 2L), "govuk-form-group--error")
    },
    calls_for(r, "addClass")
  )
  expect_length(form_group_calls, 1L)
})

test_that("error_on flags the underlying input as in-error", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    .package = "shinyjs"
  )

  input_error_calls <- Filter(
    function(c) {
      identical(recorded_arg(c, "class", 2L), "govuk-input--error")
    },
    calls_for(r, "addClass")
  )
  # One call for the input selector, one for the file_div selector
  expect_length(input_error_calls, 2L)
})

test_that("error_on shows the error message slot", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    .package = "shinyjs"
  )

  show_calls <- calls_for(r, "show")
  expect_length(show_calls, 1L)
  expect_identical(recorded_arg(show_calls[[1L]], "id", 1L), "eventIderror")
})

test_that("error_on dispatches the supplied message into <id>error", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId", error_message = "Required"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    .package = "shinyjs"
  )

  html_calls <- calls_for(r, "html")
  expect_length(html_calls, 1L)
  expect_identical(recorded_arg(html_calls[[1L]], "id", 1L), "eventIderror")
  expect_identical(recorded_arg(html_calls[[1L]], "html", 2L), "Required")
})

test_that("error_on does not dispatch html() when error_message is NULL", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    .package = "shinyjs"
  )

  expect_length(calls_for(r, "html"), 0L)
})
