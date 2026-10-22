test_that("select works", {
  choices <- c("A", "B", "C")
  select_test <- select_Input("slt1", "Select test", choices, choices)

  select <- find_tag_required(select_test, "govuk-select")
  expect_identical(htmltools::tagGetAttribute(select, "class"), "govuk-select")

  # <option> tags carry no class, so match them by tag name
  expect_length(find_tags_by_name(select_test, "option"), length(choices))
})

test_that("old positional calls still work", {
  select_test <- select_Input("slt1", "Select test", c("A", "B"), c("a", "b"))

  select <- find_tag_required(select_test, "govuk-select")
  expect_identical(htmltools::tagGetAttribute(select, "id"), "slt1")
  expect_null(htmltools::tagGetAttribute(select, "aria-describedby"))
  expect_no_tag(select_test, "govuk-hint")
  expect_no_tag(select_test, "govuk-error-message")
})

test_that("form group id lets error_on() find the select", {
  select_test <- select_Input("slt1", "Select test", "A", "a")

  group <- find_tag_required(select_test, "govuk-form-group")
  expect_identical(htmltools::tagGetAttribute(group, "id"), "slt1div")
})

test_that("hint renders and is in aria-describedby only when given", {
  with_hint <- select_Input(
    "slt1",
    "Select test",
    "A",
    "a",
    hint_label = "Pick one"
  )

  hint <- find_tag_required(with_hint, "govuk-hint")
  expect_identical(htmltools::tagGetAttribute(hint, "id"), "slt1-hint")
  expect_identical(as.character(tag_text(with_hint, "govuk-hint")), "Pick one")
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag_required(with_hint, "govuk-select"),
      "aria-describedby"
    ),
    "slt1-hint"
  )
})

test_that("error renders hidden and is never in rendered aria-describedby", {
  # The error paragraph renders hidden; referencing it would make screen
  # readers announce an error before error_on() has raised one.
  select_test <- select_Input(
    "slt1",
    "Select test",
    "A",
    "a",
    hint_label = "Pick one",
    error = TRUE,
    error_message = "Select an option"
  )

  expect_hidden_error(select_test, "Select an option")
  error <- find_tag_required(select_test, "govuk-error-message")
  expect_identical(htmltools::tagGetAttribute(error, "id"), "slt1-error")
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag_required(select_test, "govuk-select"),
      "aria-describedby"
    ),
    "slt1-hint"
  )
})
