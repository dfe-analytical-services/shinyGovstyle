date_items <- function(dtag) {
  htmltools::tagQuery(dtag)$find(".govuk-date-input__item")$selectedTags()
}

test_that("date default works", {
  date_check <- date_Input("dateid", "Test Date")

  items <- date_items(date_check)
  expect_length(items, 3)

  date_div <- htmltools::tagQuery(date_check)$find(
    ".govuk-date-input"
  )$selectedTags()[[1]]
  expect_identical(date_div$attribs$class, "govuk-date-input")
})

test_that("date error works", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    error = TRUE,
    error_message = "Error test"
  )

  expect_length(date_items(date_check), 3)

  err_p <- htmltools::tagQuery(date_check)$find(
    ".govuk-error-message"
  )$selectedTags()[[1]]
  expect_identical(err_p$children[[1]], "Error test")
  err_html <- as.character(err_p)
  expect_match(err_html, "govuk-error-message")
  expect_match(err_html, "shinyjs-hide")
  expect_identical(err_p$attribs$id, "dateid-error")
  expect_identical(err_p$attribs$role, "alert")
})


test_that("date defaults values works", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    day = 1,
    month = 2,
    year = 2020
  )

  inputs <- htmltools::tagQuery(date_check)$find(
    ".govuk-date-input__input"
  )$selectedTags()
  expect_length(inputs, 3)
  expect_equal(inputs[[1]]$attribs$value, 1)
  expect_equal(inputs[[2]]$attribs$value, 2)
  expect_equal(inputs[[3]]$attribs$value, 2020)
})

test_that("Fieldset and legend wrap date input", {
  date_check <- date_Input("dateid", "Test Date")
  fieldset <- htmltools::tagQuery(date_check)$find(
    "fieldset"
  )$selectedTags()[[1]]
  expect_identical(fieldset$attribs$class, "govuk-fieldset")

  legend <- htmltools::tagQuery(fieldset)$find("legend")$selectedTags()[[1]]
  expect_identical(
    legend$attribs$class,
    "govuk-fieldset__legend govuk-fieldset__legend--m"
  )
})

test_that("Hint id and aria-describedby wired up when hint supplied", {
  date_check <- date_Input(
    "dateid",
    "Test Date",
    hint_label = "DD MM YYYY"
  )
  hint <- htmltools::tagQuery(date_check)$find(
    ".govuk-hint"
  )$selectedTags()[[1]]
  expect_identical(hint$attribs$id, "dateid-hint")

  fieldset <- htmltools::tagQuery(date_check)$find(
    "fieldset"
  )$selectedTags()[[1]]
  expect_identical(fieldset$attribs$`aria-describedby`, "dateid-hint")
})

test_that("Hint <div> is omitted when hint_label is NULL", {
  date_check <- date_Input("dateid", "Test Date")
  hints <- htmltools::tagQuery(date_check)$find(
    ".govuk-hint"
  )$selectedTags()
  expect_length(hints, 0)

  fieldset <- htmltools::tagQuery(date_check)$find(
    "fieldset"
  )$selectedTags()[[1]]
  expect_null(fieldset$attribs$`aria-describedby`)
})
