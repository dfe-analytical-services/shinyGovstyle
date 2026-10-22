test_that("error_off clears the form group error class", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_off("eventId"),
    removeClass = r$record("removeClass"),
    hide = r$record("hide"),
    runjs = r$record("runjs"),
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
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  input_error_calls <- Filter(
    function(c) {
      identical(recorded_arg(c, "class", 2L), "govuk-input--error")
    },
    calls_for(r, "removeClass")
  )
  # Assert the selectors themselves: a wrong selector would leave the error
  # styling stuck on screen after the user fixes their input, while leaving the
  # call count unchanged.
  expect_length(input_error_calls, 2L)
  expect_setequal(
    vapply(
      input_error_calls,
      function(c) recorded_arg(c, "selector", 1L),
      character(1L)
    ),
    c("#eventIddiv :input", "#eventIdfile_div")
  )
})

test_that("error_off hides the error message slot", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_off("eventId"),
    removeClass = r$record("removeClass"),
    hide = r$record("hide"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  hide_calls <- calls_for(r, "hide")
  expect_length(hide_calls, 1L)
  expect_identical(recorded_arg(hide_calls[[1L]], "id", 1L), "eventId-error")
})

test_that("error_off removes the error id from the aria-describedby", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_off("eventId"),
    removeClass = r$record("removeClass"),
    hide = r$record("hide"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  runjs_calls <- calls_for(r, "runjs")
  expect_length(runjs_calls, 1L)
  js <- recorded_arg(runjs_calls[[1L]], "code", 1L)
  expect_match(js, "var errorId = \"eventId-error\";", fixed = TRUE)
  expect_match(js, "querySelector('fieldset.govuk-fieldset')", fixed = TRUE)
  expect_match(js, "x !== errorId", fixed = TRUE)
  expect_no_match(js, "ids.push(errorId);", fixed = TRUE)
  # An empty list removes the attribute rather than leaving it blank.
  expect_match(js, "el.removeAttribute('aria-describedby')", fixed = TRUE)
})
