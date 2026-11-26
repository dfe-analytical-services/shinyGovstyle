test_that("date default works", {
  date_check <- date_Input("dateid", "Test Date")

  date_input <- find_tag(date_check, "govuk-date-input")
  expect_length(find_tags(date_check, "govuk-date-input__item"), 3L)

  expect_identical(
    htmltools::tagGetAttribute(date_input, "class"),
    "govuk-date-input"
  )
})

test_that("date error works", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    error = TRUE,
    error_message = "Error test"
  )

  expect_length(find_tags(date_check, "govuk-date-input__item"), 3L)

  expect_hidden_error(date_check, "Error test")

  err <- find_tag(date_check, "govuk-error-message")
  expect_identical(htmltools::tagGetAttribute(err, "id"), "dateid-error")
})


test_that("date defaults values works", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    day = 1,
    month = 2,
    year = 2020
  )

  items <- find_tags(date_check, "govuk-date-input__item")
  expect_length(items, 3L)

  values <- vapply(
    items,
    function(item) {
      input <- find_tag(item, "govuk-date-input__input")
      as.character(htmltools::tagGetAttribute(input, "value"))
    },
    character(1L)
  )

  expect_identical(values, c("1", "2", "2020"))
})

test_that("fieldset children appear in GOV.UK order", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    error = TRUE,
    error_message = "Error test"
  )

  fieldset <- find_tag(date_check, "govuk-fieldset")
  expect_identical(
    child_classes(fieldset),
    c(
      "govuk-fieldset__legend govuk-fieldset__legend--m",
      "govuk-error-message shinyjs-hide",
      "govuk-date-input"
    )
  )
})

test_that("Fieldset and legend wrap date input", {
  date_check <- date_Input("dateid", "Test Date")
  fieldset <- find_tag(date_check, "govuk-fieldset")
  expect_identical(
    htmltools::tagGetAttribute(fieldset, "class"),
    "govuk-fieldset"
  )

  legend <- find_tag(fieldset, "govuk-fieldset__legend")
  expect_identical(
    htmltools::tagGetAttribute(legend, "class"),
    "govuk-fieldset__legend govuk-fieldset__legend--m"
  )
})

test_that("label with markup renders as HTML, not escaped text", {
  date_check <- date_Input("dateid", "<b>Bold</b>")
  expect_match(as.character(date_check), "<b>Bold</b>", fixed = TRUE)
})

test_that("Hint id and aria-describedby wired up when hint supplied", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    hint_label = "DD MM YYYY"
  )
  hint <- find_tag(date_check, "govuk-hint")
  expect_identical(htmltools::tagGetAttribute(hint, "id"), "dateid-hint")

  fieldset <- find_tag(date_check, "govuk-fieldset")
  expect_identical(
    htmltools::tagGetAttribute(fieldset, "aria-describedby"),
    "dateid-hint"
  )
})

test_that("Hint <div> is omitted when hint_label is NULL", {
  date_check <- date_Input("dateid", "Test Date")
  expect_no_tag(date_check, "govuk-hint")

  fieldset <- find_tag(date_check, "govuk-fieldset")
  expect_null(htmltools::tagGetAttribute(fieldset, "aria-describedby"))
})

test_that("label_size sets the legend size modifier", {
  for (size in c("s", "m", "l", "xl")) {
    date_check <- date_Input(
      "dateid",
      "Test Date",
      label_size = size
    )
    legend <- find_tag(date_check, "govuk-fieldset__legend")
    expect_identical(
      htmltools::tagGetAttribute(legend, "class"),
      paste0("govuk-fieldset__legend govuk-fieldset__legend--", size)
    )
  }
})

test_that("label_size rejects unknown values", {
  expect_error(
    date_Input("dateid", "Test Date", label_size = "huge")
  )
})

test_that("heading_level wraps the legend text in an <hN>", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    label_size = "l",
    heading_level = 1
  )
  heading <- find_tag(date_check, "govuk-fieldset__heading")
  expect_identical(heading$name, "h1")
  expect_identical(heading$attribs$class, "govuk-fieldset__heading")
})

test_that("heading_level rejects invalid values", {
  expect_error(
    date_Input("dateid", "Test Date", heading_level = 0)
  )
  expect_error(
    date_Input("dateid", "Test Date", heading_level = 7)
  )
  expect_error(
    date_Input("dateid", "Test Date", heading_level = c(1, 2))
  )
  expect_error(
    date_Input("dateid", "Test Date", heading_level = TRUE)
  )
  expect_error(
    date_Input("dateid", "Test Date", heading_level = 2.5)
  )
})

test_that("label accepts a shiny.tag", {
  html <- as.character(date_Input("dateid", shiny::tags$b("Bold label")))
  expect_match(html, "<b>Bold label</b>", fixed = TRUE)
})

test_that("Day/Month/Year labels are associated with their inputs", {
  date_check <- date_Input("dateid", "Test Date")
  labels <- find_tags(date_check, "govuk-date-input__label")
  expect_identical(htmltools::tagGetAttribute(labels[[1]], "for"), "dateid_day")
  expect_identical(
    htmltools::tagGetAttribute(labels[[2]], "for"),
    "dateid_month"
  )
  expect_identical(
    htmltools::tagGetAttribute(labels[[3]], "for"),
    "dateid_year"
  )
})

test_that("Day/Month/Year inputs use GOV.UK text inputs with numeric keypad", {
  date_check <- date_Input("dateid", "Test Date")
  inputs <- find_tags(date_check, "govuk-date-input__input")
  expect_length(inputs, 3L)

  for (input in inputs) {
    expect_identical(htmltools::tagGetAttribute(input, "type"), "text")
    expect_identical(htmltools::tagGetAttribute(input, "inputmode"), "numeric")
    expect_null(htmltools::tagGetAttribute(input, "pattern"))
  }
})

test_that("autocomplete is omitted unless date_of_birth is TRUE", {
  date_check <- date_Input("dateid", "Test Date")
  inputs <- find_tags(date_check, "govuk-date-input__input")
  for (input in inputs) {
    expect_null(htmltools::tagGetAttribute(input, "autocomplete"))
  }
})

test_that("date_of_birth = TRUE sets the bday autocomplete tokens", {
  date_check <- date_Input("dateid", "Test Date", date_of_birth = TRUE)
  inputs <- find_tags(date_check, "govuk-date-input__input")
  tokens <- vapply(
    inputs,
    function(input) htmltools::tagGetAttribute(input, "autocomplete"),
    character(1L)
  )
  expect_identical(tokens, c("bday-day", "bday-month", "bday-year"))
})

test_that("date_of_birth rejects non-logical values", {
  expect_error(
    date_Input("dateid", "Test Date", date_of_birth = "yes"),
    "date_of_birth"
  )
  expect_error(
    date_Input("dateid", "Test Date", date_of_birth = NA),
    "date_of_birth"
  )
  expect_error(
    date_Input("dateid", "Test Date", date_of_birth = c(TRUE, FALSE)),
    "date_of_birth"
  )
})

test_that("hidden error id is never in the fieldset aria-describedby", {
  # error_on() adds the error id at runtime; rendering it up front would make
  # screen readers announce the hidden error before it is raised.
  with_hint <- date_Input(
    "dateid",
    "Test Date",
    hint_label = "DD MM YYYY",
    error = TRUE,
    error_message = "Error test"
  )
  without_hint <- date_Input(
    "dateid",
    "Test Date",
    error = TRUE,
    error_message = "Error test"
  )

  expect_identical(
    htmltools::tagGetAttribute(
      find_tag(with_hint, "govuk-fieldset"),
      "aria-describedby"
    ),
    "dateid-hint"
  )
  expect_null(
    htmltools::tagGetAttribute(
      find_tag(without_hint, "govuk-fieldset"),
      "aria-describedby"
    )
  )
})
