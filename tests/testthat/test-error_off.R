test_that("error_off clears the form group error class", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_off("eventId"),
    removeClass = r$record("removeClass"),
    hide = r$record("hide"),
    .package = "shinyjs"
  )

  form_group_calls <- Filter(
    function(c) {
      identical(recorded_arg(c, "id", 1L), "eventIddiv") &&
        identical(recorded_arg(c, "class", 2L), "govuk-form-group--error")
    },
    calls_for(r, "removeClass")
  )
  expect_length(form_group_calls, 1L)
})

test_that("error_off clears the underlying input error class", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_off("eventId"),
    removeClass = r$record("removeClass"),
    hide = r$record("hide"),
    .package = "shinyjs"
  )

  input_error_calls <- Filter(
    function(c) {
      identical(recorded_arg(c, "class", 2L), "govuk-input--error")
    },
    calls_for(r, "removeClass")
  )
  expect_length(input_error_calls, 2L)
})

test_that("error_off hides the error message slot", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_off("eventId"),
    removeClass = r$record("removeClass"),
    hide = r$record("hide"),
    .package = "shinyjs"
  )

  hide_calls <- calls_for(r, "hide")
  expect_length(hide_calls, 1L)
  expect_identical(recorded_arg(hide_calls[[1L]], "id", 1L), "eventIderror")
})
