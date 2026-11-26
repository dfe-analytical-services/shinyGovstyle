test_that("error_summary_update dispatches html() to the list slot", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_summary_update("errorId", c("first", "second")),
    html = r$record("html"),
    runjs = r$record("runjs"),
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
    runjs = r$record("runjs"),
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

# Runs error_summary_update() with shinyjs mocked, optionally inside a module
# session, and returns the recorder.
record_update <- function(..., session = NULL) {
  r <- make_call_recorder()
  run <- function() {
    testthat::with_mocked_bindings(
      error_summary_update(...),
      html = r$record("html"),
      runjs = r$record("runjs"),
      .package = "shinyjs"
    )
  }
  if (is.null(session)) {
    run()
  } else {
    shiny::withReactiveDomain(session, run())
  }
  r
}

update_payload <- function(r) {
  recorded_arg(calls_for(r, "html")[[1L]], "html", 2L)
}

test_that("error_summary_update links named messages and keeps plain ones", {
  r <- record_update(
    "errorId",
    c(name = "Enter your name", "Check your answers", dob = "Enter a date")
  )

  expect_identical(
    gsub(
      "[[:space:]]*
[[:space:]]*",
      "",
      update_payload(r)
    ),
    paste0(
      "<ul class=\"govuk-list govuk-error-summary__list\">",
      "<li><a href=\"#name\">Enter your name</a></li>",
      "<li>Check your answers</li>",
      "<li><a href=\"#dob\">Enter a date</a></li>",
      "</ul>"
    )
  )
})

test_that("error_summary_update renders the same list as error_summary", {
  messages <- c(name = "Enter your name", "Check your answers")
  r <- record_update("errorId", messages, focus = FALSE)

  initial <- htmltools::tagQuery(error_summary("errorId", "T", messages))$find(
    ".govuk-error-summary__list"
  )$selectedTags()[[1L]]
  expect_identical(update_payload(r), as.character(initial))
})

test_that("error_summary_update escapes plain-string messages", {
  r <- record_update("errorId", c(name = "<script>x</script>"), focus = FALSE)

  expect_match(
    update_payload(r),
    "&lt;script&gt;x&lt;/script&gt;",
    fixed = TRUE
  )
  expect_no_match(update_payload(r), "<script>", fixed = TRUE)
})

test_that("error_summary_update focuses the summary by default", {
  r <- record_update("errorId", "Problem")

  runjs_calls <- calls_for(r, "runjs")
  expect_length(runjs_calls, 1L)
  js <- recorded_arg(runjs_calls[[1L]], "code", 1L)
  expect_match(js, "document.getElementById(\"errorId\")", fixed = TRUE)
  expect_match(js, "setAttribute('tabindex', '-1')", fixed = TRUE)
  expect_match(js, "el.focus()", fixed = TRUE)

  # The list is replaced before focus moves, so the summary is read out with
  # the new messages.
  expect_identical(
    vapply(r$get(), function(c) c$fn, character(1L)),
    c("html", "runjs")
  )
})

test_that("error_summary_update leaves focus alone when focus = FALSE", {
  r <- record_update("errorId", "Problem", focus = FALSE)

  expect_length(calls_for(r, "runjs"), 0L)
  expect_length(calls_for(r, "html"), 1L)
})

test_that("error_summary_update namespaces the summary and links in modules", {
  session <- shiny::MockShinySession$new()$makeScope("mod")
  r <- record_update("errorId", c(name = "Enter your name"), session = session)

  # shinyjs::html() namespaces its own `id`, so it is passed through bare.
  expect_identical(
    recorded_arg(calls_for(r, "html")[[1L]], "id", 1L),
    "errorIdlist"
  )
  expect_match(update_payload(r), "href=\"#mod-name\"", fixed = TRUE)
  expect_match(
    recorded_arg(calls_for(r, "runjs")[[1L]], "code", 1L),
    "document.getElementById(\"mod-errorId\")",
    fixed = TRUE
  )
})
