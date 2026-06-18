test_that("Default", {
  choices <- c("A", "B", "C")
  cbtag <- checkbox_Input(
    inputId = "Id029",
    label = "Label",
    cb_labels = choices,
    checkboxIds = choices
  )
  choicestag <- find_tag(cbtag, "govuk-checkboxes")$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_true(all(!checked))
})


test_that("Error", {
  choices <- c("A", "B", "C")
  cbtag <- checkbox_Input(
    inputId = "Id029",
    label = "Label",
    cb_labels = choices,
    checkboxIds = choices,
    error = TRUE,
    error_message = "Error Test"
  )
  choicestag <- find_tag(cbtag, "govuk-checkboxes")$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_true(all(!checked))

  expect_hidden_error(cbtag, "Error Test")
})


test_that("Small", {
  choices <- c("A", "B", "C")
  cbtag <- checkbox_Input(
    inputId = "Id029",
    label = "Label",
    cb_labels = choices,
    checkboxIds = choices,
    small = TRUE
  )
  choicestag <- find_tag(cbtag, "govuk-checkboxes")$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_true(all(!checked))

  expect_identical(
    htmltools::tagGetAttribute(find_tag(cbtag, "govuk-checkboxes"), "class"),
    "govuk-checkboxes govuk-checkboxes--small"
  )
})

test_that("Labels are programmatically associated with inputs", {
  cb_labels <- c("Option 1", "Option 2", "Option 3")
  cb_ids <- c("op1", "op2", "op3")
  cbtag <- checkbox_Input(
    inputId = "cb_a11y",
    label = "Label",
    cb_labels = cb_labels,
    checkboxIds = cb_ids
  )
  option_items <- find_tag(cbtag, "govuk-checkboxes")$children[[1]]

  for (i in seq_along(cb_ids)) {
    item <- option_items[[i]]
    input_tag <- item$children[[1]]
    label_tag <- item$children[[2]]
    expect_identical(htmltools::tagGetAttribute(input_tag, "id"), cb_ids[i])
    expect_identical(htmltools::tagGetAttribute(label_tag, "for"), cb_ids[i])
  }
})

test_that("fieldset children appear in GOV.UK order", {
  cbtag <- checkbox_Input(
    inputId = "Id029",
    label = "Label",
    cb_labels = c("A", "B"),
    checkboxIds = c("A", "B"),
    error = TRUE,
    error_message = "Error Test"
  )

  fieldset <- find_tag(cbtag, "govuk-fieldset")
  expect_identical(
    child_classes(fieldset),
    c(
      "govuk-label",
      "govuk-hint",
      "govuk-error-message shinyjs-hide",
      "govuk-checkboxes"
    )
  )
})
