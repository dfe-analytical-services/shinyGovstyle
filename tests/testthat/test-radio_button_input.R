radio_items <- function(rtag) {
  htmltools::tagQuery(rtag)$find(".govuk-radios__item")$selectedTags()
}

radio_group_div <- function(rtag) {
  htmltools::tagQuery(rtag)$find(".govuk-radios")$selectedTags()[[1]]
}

is_checked <- function(item) {
  input_tag <- htmltools::tagQuery(item)$find("input")$selectedTags()[[1]]
  identical(input_tag$attribs$checked, "checked")
}

checked_index <- function(items) {
  unname(which(vapply(items, is_checked, logical(1))))
}

test_that("Default", {
  choices <- c("A", "B", "C")
  rtag <- radio_button_Input(
    inputId = "Id029",
    label = "Label",
    choices = choices,
    selected = "A"
  )
  items <- radio_items(rtag)
  expect_length(items, length(choices))
  expect_equal(checked_index(items), 1L)
})


test_that("Error", {
  choices <- c("A", "B", "C")
  rtag <- radio_button_Input(
    inputId = "Id029",
    label = "Label",
    choices = choices,
    selected = "A",
    error = TRUE,
    error_message = "Error Test"
  )
  items <- radio_items(rtag)
  expect_length(items, length(choices))
  expect_equal(checked_index(items), 1L)

  err_p <- htmltools::tagQuery(rtag)$find(
    ".govuk-error-message"
  )$selectedTags()[[1]]
  expect_identical(err_p$children[[1]], "Error Test")
  err_html <- as.character(err_p)
  expect_match(err_html, "govuk-error-message")
  expect_match(err_html, "shinyjs-hide")
  expect_identical(err_p$attribs$role, "alert")
})

test_that("Small", {
  choices <- c("A", "B", "C")
  rtag <- radio_button_Input(
    inputId = "Id029",
    label = "Label",
    choices = choices,
    selected = "A",
    small = TRUE
  )
  items <- radio_items(rtag)
  expect_length(items, length(choices))
  expect_equal(checked_index(items), 1L)

  expect_identical(
    radio_group_div(rtag)$attribs$class,
    "govuk-radios govuk-radios--small"
  )
})

test_that("Inline", {
  choices <- c("A", "B", "C")
  rtag <- radio_button_Input(
    inputId = "Id029",
    label = "Label",
    choices = choices,
    selected = "A",
    inline = TRUE
  )
  items <- radio_items(rtag)
  expect_length(items, length(choices))
  expect_equal(checked_index(items), 1L)

  expect_identical(
    radio_group_div(rtag)$attribs$class,
    "govuk-radios govuk-radios--inline"
  )
})

test_that("Labels are programmatically associated with inputs", {
  choices <- c("Yes", "No", "Maybe")
  rtag <- radio_button_Input(
    inputId = "radio_a11y",
    label = "Label",
    choices = choices,
    selected = "Yes"
  )
  items <- radio_items(rtag)

  for (i in seq_along(choices)) {
    tq <- htmltools::tagQuery(items[[i]])
    input_tag <- tq$find("input")$selectedTags()[[1]]
    label_tag <- tq$find("label")$selectedTags()[[1]]
    expected_id <- paste0("radio_a11y-", i)
    expect_identical(input_tag$attribs$id, expected_id)
    expect_identical(label_tag$attribs$`for`, expected_id)
  }
})

test_that("Fieldset and legend wrap radio group with default --m size", {
  rtag <- radio_button_Input(
    inputId = "radio_fieldset",
    label = "Pick one",
    choices = c("Yes", "No")
  )
  fieldset <- htmltools::tagQuery(rtag)$find("fieldset")$selectedTags()[[1]]
  expect_identical(fieldset$attribs$class, "govuk-fieldset")

  legend <- htmltools::tagQuery(fieldset)$find("legend")$selectedTags()[[1]]
  expect_identical(
    legend$attribs$class,
    "govuk-fieldset__legend govuk-fieldset__legend--m"
  )
  expect_identical(legend$children[[1]], "Pick one")
})

test_that("label_size sets the legend size modifier", {
  for (size in c("s", "m", "l", "xl")) {
    rtag <- radio_button_Input(
      inputId = "r",
      label = "Q",
      choices = c("a", "b"),
      label_size = size
    )
    legend <- htmltools::tagQuery(rtag)$find("legend")$selectedTags()[[1]]
    expect_identical(
      legend$attribs$class,
      paste0("govuk-fieldset__legend govuk-fieldset__legend--", size)
    )
  }
})

test_that("label_size rejects unknown values", {
  expect_error(
    radio_button_Input(
      inputId = "r", label = "Q", choices = c("a", "b"), label_size = "huge"
    )
  )
})

test_that("heading_level wraps the legend text in an <hN>", {
  rtag <- radio_button_Input(
    inputId = "r",
    label = "Q",
    choices = c("a", "b"),
    label_size = "l",
    heading_level = 1
  )
  legend <- htmltools::tagQuery(rtag)$find("legend")$selectedTags()[[1]]
  heading <- legend$children[[1]]
  expect_identical(heading$name, "h1")
  expect_identical(heading$attribs$class, "govuk-fieldset__heading")
  expect_identical(heading$children[[1]], "Q")
})

test_that("heading_level rejects invalid values", {
  expect_error(
    radio_button_Input(
      inputId = "r", label = "Q", choices = c("a", "b"), heading_level = 0
    )
  )
  expect_error(
    radio_button_Input(
      inputId = "r", label = "Q", choices = c("a", "b"), heading_level = 7
    )
  )
  expect_error(
    radio_button_Input(
      inputId = "r", label = "Q", choices = c("a", "b"),
      heading_level = c(1, 2)
    )
  )
})

test_that("Fieldset aria-describedby references hint and error ids", {
  rtag <- radio_button_Input(
    inputId = "radio_aria",
    label = "Pick one",
    choices = c("Yes", "No"),
    hint_label = "Choose wisely",
    error = TRUE,
    error_message = "Required"
  )
  fieldset <- htmltools::tagQuery(rtag)$find("fieldset")$selectedTags()[[1]]
  expect_identical(
    fieldset$attribs$`aria-describedby`,
    "radio_aria-hint radio_aria-error"
  )

  hint <- htmltools::tagQuery(rtag)$find(".govuk-hint")$selectedTags()[[1]]
  expect_identical(hint$attribs$id, "radio_aria-hint")

  err <- htmltools::tagQuery(rtag)$find(
    ".govuk-error-message"
  )$selectedTags()[[1]]
  expect_identical(err$attribs$id, "radio_aria-error")
})

test_that("Fieldset has no aria-describedby when no hint or error", {
  rtag <- radio_button_Input(
    inputId = "radio_plain",
    label = "Pick one",
    choices = c("Yes", "No")
  )
  fieldset <- htmltools::tagQuery(rtag)$find("fieldset")$selectedTags()[[1]]
  expect_null(fieldset$attribs$`aria-describedby`)
})
