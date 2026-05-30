radios_container <- function(rtag) {
  # The outer wrapper div also carries the "govuk-radios" class
  # (see R/radio_button_input.R), so take the inner (deepest) match.
  all_matches <- find_tags(rtag, "govuk-radios")
  all_matches[[length(all_matches)]]
}

test_that("Default", {
  choices <- c("A", "B", "C")
  rtag <- radio_button_Input(
    inputId = "Id029",
    label = "Label",
    choices = choices,
    selected = "A"
  )
  choicestag <- radios_container(rtag)$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_identical(checked, c(TRUE, FALSE, FALSE))
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
  choicestag <- radios_container(rtag)$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_identical(checked, c(TRUE, FALSE, FALSE))

  expect_hidden_error(rtag, "Error Test")
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
  choicestag <- radios_container(rtag)$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_identical(checked, c(TRUE, FALSE, FALSE))

  expect_identical(
    htmltools::tagGetAttribute(radios_container(rtag), "class"),
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
  choicestag <- radios_container(rtag)$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_identical(checked, c(TRUE, FALSE, FALSE))

  expect_identical(
    htmltools::tagGetAttribute(radios_container(rtag), "class"),
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
  option_items <- radios_container(rtag)$children[[1]]

  for (i in seq_along(choices)) {
    item <- option_items[[i]]
    input_tag <- item$children[[1]]
    label_tag <- item$children[[2]]
    expected_id <- paste0("radio_a11y-", i)
    expect_identical(htmltools::tagGetAttribute(input_tag, "id"), expected_id)
    expect_identical(
      htmltools::tagGetAttribute(label_tag, "for"),
      expected_id
    )
  }
})

test_that("form group children appear in GOV.UK order", {
  rtag <- radio_button_Input(
    inputId = "Id029",
    label = "Label",
    choices = c("A", "B"),
    selected = "A",
    error = TRUE,
    error_message = "Error Test"
  )

  # Outer wrapper duplicates the "govuk-form-group" class (see
  # R/radio_button_input.R); the meaningful GOV.UK form group is nested.
  form_groups <- find_tags(rtag, "govuk-form-group")
  form_group <- form_groups[[length(form_groups)]]
  expect_identical(
    child_classes(form_group),
    c(
      "govuk-label",
      "govuk-hint",
      "govuk-error-message shinyjs-hide",
      "govuk-radios"
    )
  )
})
