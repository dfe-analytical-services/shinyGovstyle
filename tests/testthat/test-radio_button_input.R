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
  choicestag <- find_tags(rtag, "govuk-radios__item")
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
  choicestag <- find_tags(rtag, "govuk-radios__item")
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
  choicestag <- find_tags(rtag, "govuk-radios__item")
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
  choicestag <- find_tags(rtag, "govuk-radios__item")
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

test_that("label and hint accept rich content", {
  html <- as.character(
    radio_button_Input(
      inputId = "Id029",
      label = shiny::tags$b("Bold label"),
      choices = c("A", "B"),
      hint_label = shiny::HTML('See <a href="#">guidance</a>')
    )
  )

  expect_match(html, "<b>Bold label</b>", fixed = TRUE)
  expect_match(html, '<a href="#">guidance</a>', fixed = TRUE)
})

# Build a lightweight stand-in for a Shiny session that records the messages
# update_radio_button_Input() would send to the client. `ns` mimics module
# namespacing so we can check the regenerated option markup is namespaced.
mock_radio_session <- function(ns = function(id) id) {
  captured <- new.env(parent = emptyenv())
  captured$inputId <- NULL
  captured$message <- NULL
  list(
    ns = ns,
    sendInputMessage = function(
      inputId, # nolint
      message
    ) {
      captured$inputId <- inputId
      captured$message <- message
    },
    captured = captured
  )
}

test_that("update_radio_button_Input sends only the fields supplied", {
  session <- mock_radio_session()

  update_radio_button_Input(session, inputId = "cookies", selected = "yes")

  expect_identical(session$captured$inputId, "cookies")
  expect_identical(session$captured$message$selected, "yes")
  expect_null(session$captured$message$options)
  expect_null(session$captured$message$label)
})

test_that("update_radio_button_Input can update the label alone", {
  session <- mock_radio_session()

  update_radio_button_Input(session, inputId = "cookies", label = "New label")

  expect_identical(session$captured$message$label, "New label")
  expect_null(session$captured$message$selected)
  expect_null(session$captured$message$options)
})

test_that("update_radio_button_Input regenerates option markup for choices", {
  session <- mock_radio_session()

  update_radio_button_Input(
    session,
    inputId = "cookies",
    choices = c("Yes" = "yes", "No" = "no"),
    selected = "yes"
  )

  options <- session$captured$message$options
  expect_type(options, "character")
  expect_match(options, "govuk-radios__item")
  # The selected value is pre-checked in the rendered markup
  expect_match(options, "checked")
})

test_that("update_radio_button_Input namespaces regenerated option inputs", {
  session <- mock_radio_session(ns = function(id) paste0("mod-", id))

  update_radio_button_Input(
    session,
    inputId = "cookies",
    choices = c("Yes" = "yes", "No" = "no")
  )

  # The option inputs use the namespaced id as their `name` so the client
  # binding can match them, mirroring radio_button_Input() markup.
  expect_match(session$captured$message$options, "mod-cookies")
})

test_that("update_radio_button_Input rejects multiple selected values", {
  session <- mock_radio_session()

  expect_error(
    update_radio_button_Input(
      session,
      inputId = "cookies",
      selected = c("yes", "no")
    ),
    "length 1"
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
  option_items <- find_tags(rtag, "govuk-radios__item")

  for (i in seq_along(choices)) {
    item <- option_items[[i]]
    input_tag <- find_tag(item, "govuk-radios__input")
    label_tag <- find_tag(item, "govuk-label")
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
