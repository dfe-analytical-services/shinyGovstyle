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

  err <- find_tag(date_check, "govuk-error-message")
  expect_length(find_tags(date_check, "govuk-error-message"), 1L)
  expect_identical(
    htmltools::tagGetAttribute(err, "class"),
    "govuk-error-message shinyjs-hide"
  )

  expect_identical(err$children[[1]], "Error test")
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
      "govuk-label",
      "govuk-error-message shinyjs-hide",
      "govuk-hint",
      "govuk-date-input"
    )
  )
})
