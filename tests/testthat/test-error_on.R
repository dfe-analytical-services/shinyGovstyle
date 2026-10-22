test_that("error_on flags the form group div as in-error", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
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
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  input_error_calls <- Filter(
    function(c) {
      identical(recorded_arg(c, "class", 2L), "govuk-input--error")
    },
    calls_for(r, "addClass")
  )
  # One call for the input selector, one for the file_div selector. Assert the
  # selectors themselves: a wrong selector would stop the error styling reaching
  # the input while leaving the call count unchanged.
  expect_length(input_error_calls, 2L)
  expect_setequal(
    vapply(
      input_error_calls,
      function(c) recorded_arg(c, "selector", 1L),
      character(1L)
    ),
    c("#eventIddiv :input:not(select)", "#eventIdfile_div")
  )
})

test_that("error_on shows the error message slot", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  show_calls <- calls_for(r, "show")
  expect_length(show_calls, 1L)
  expect_identical(recorded_arg(show_calls[[1L]], "id", 1L), "eventId-error")
})

test_that("error_on dispatches the supplied message into <id>-error", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId", error_message = "Required"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  html_calls <- calls_for(r, "html")
  expect_length(html_calls, 1L)
  expect_identical(recorded_arg(html_calls[[1L]], "id", 1L), "eventId-error")
  # The visually hidden "Error:" prefix is sent with the message:
  # shinyjs::html() replaces the paragraph's contents, so a bare message
  # would drop it.
  expect_identical(
    recorded_arg(html_calls[[1L]], "html", 2L),
    "<span class=\"govuk-visually-hidden\">Error:</span> Required"
  )
})

test_that("error_on escapes a plain string error message", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId", error_message = "Enter a date in <YYYY-MM-DD> form"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  # shinyjs::html() assigns the payload as innerHTML, so an unescaped string
  # would be parsed as markup and the browser would swallow <YYYY-MM-DD>.
  # Plain strings escape here exactly as they do in the rendered component.
  expect_identical(
    recorded_arg(calls_for(r, "html")[[1L]], "html", 2L),
    paste0(
      "<span class=\"govuk-visually-hidden\">Error:</span> ",
      "Enter a date in &lt;YYYY-MM-DD&gt; form"
    )
  )
})

test_that("error_on renders tag and HTML() error messages as markup", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    {
      error_on("tagId", error_message = shiny::tags$strong("Required"))
      error_on("htmlId", error_message = shiny::HTML("<b>Required</b>"))
    },
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  html_calls <- calls_for(r, "html")
  expect_length(html_calls, 2L)
  expect_identical(
    recorded_arg(html_calls[[1L]], "html", 2L),
    paste0(
      "<span class=\"govuk-visually-hidden\">Error:</span> ",
      "<strong>Required</strong>"
    )
  )
  expect_identical(
    recorded_arg(html_calls[[2L]], "html", 2L),
    paste0(
      "<span class=\"govuk-visually-hidden\">Error:</span> ",
      "<b>Required</b>"
    )
  )
})

test_that("error_on does not dispatch html() when error_message is NULL", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  expect_length(calls_for(r, "html"), 0L)
})

test_that("error_on adds the error id to the control's aria-describedby", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  runjs_calls <- calls_for(r, "runjs")
  expect_length(runjs_calls, 1L)
  js <- recorded_arg(runjs_calls[[1L]], "code", 1L)
  # Grouped controls (checkboxes, radios, dates) are described on the fieldset
  # inside <id>div; everything else on the element with the input id.
  expect_match(js, "var id = \"eventId\";", fixed = TRUE)
  expect_match(js, "var errorId = \"eventId-error\";", fixed = TRUE)
  expect_match(js, "document.getElementById(id + 'div')", fixed = TRUE)
  expect_match(js, "querySelector('fieldset.govuk-fieldset')", fixed = TRUE)
  expect_match(js, "document.getElementById(id)", fixed = TRUE)
  # The existing ids are kept, the error id is filtered out before it is
  # appended so repeated calls never duplicate it.
  expect_match(js, "x !== errorId", fixed = TRUE)
  expect_match(js, "ids.push(errorId);", fixed = TRUE)
})

test_that("error_on embeds the input id as a JavaScript string literal", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("mod-\"x\""),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  js <- recorded_arg(calls_for(r, "runjs")[[1L]], "code", 1L)
  expect_match(js, "var id = \"mod-\\\"x\\\"\";", fixed = TRUE)
})

test_that("error_on toggles the GOV.UK select error class on selects only", {
  r <- make_call_recorder()

  testthat::with_mocked_bindings(
    error_on("eventId"),
    addClass = r$record("addClass"),
    show = r$record("show"),
    html = r$record("html"),
    runjs = r$record("runjs"),
    .package = "shinyjs"
  )

  calls <- calls_for(r, "addClass")
  selectors_for <- function(class) {
    matching <- Filter(
      function(c) identical(recorded_arg(c, "class", 2L), class),
      calls
    )
    vapply(matching, function(c) recorded_arg(c, "selector", 1L), character(1L))
  }
  # GOV.UK styles an invalid select with govuk-select--error; the :input
  # selector excludes selects so they do not also get govuk-input--error.
  expect_identical(selectors_for("govuk-select--error"), "#eventIddiv select")
  expect_false(any(selectors_for("govuk-input--error") == "#eventIddiv :input"))
})

test_that("error_on namespaces class selectors inside modules", {
  # shinyjs namespaces `id` arguments but not `selector` ones, so without this
  # the error classes would miss controls built with shiny::NS().
  r <- make_call_recorder()

  shiny::withReactiveDomain(
    list(ns = shiny::NS("mod")),
    testthat::with_mocked_bindings(
      error_on("eventId"),
      addClass = r$record("addClass"),
      show = r$record("show"),
      html = r$record("html"),
      runjs = r$record("runjs"),
      .package = "shinyjs"
    )
  )

  selectors <- vapply(
    Filter(
      function(c) "selector" %in% names(c$args),
      calls_for(r, "addClass")
    ),
    function(c) recorded_arg(c, "selector", 1L),
    character(1L)
  )
  expect_setequal(
    selectors,
    c(
      "#mod-eventIddiv :input:not(select)",
      "#mod-eventIddiv select",
      "#mod-eventIdfile_div"
    )
  )
})
