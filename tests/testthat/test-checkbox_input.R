test_that("Default", {
  choices <- c("A", "B", "C")
  cbtag <- checkbox_Input(
    inputId = "Id029",
    label = "Label",
    cb_labels = choices,
    checkboxIds = choices
  )
  choicestag <- find_tags(cbtag, "govuk-checkboxes__item")
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
  choicestag <- find_tags(cbtag, "govuk-checkboxes__item")
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
  choicestag <- find_tags(cbtag, "govuk-checkboxes__item")
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
  option_items <- find_tags(cbtag, "govuk-checkboxes__item")

  for (i in seq_along(cb_ids)) {
    item <- option_items[[i]]
    input_tag <- find_tag(item, "govuk-checkboxes__input")
    label_tag <- find_tag(item, "govuk-label")
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
      "govuk-fieldset__legend govuk-fieldset__legend--m",
      "govuk-error-message shinyjs-hide",
      "govuk-checkboxes"
    )
  )
})

test_that("Fieldset and legend wrap checkbox group with default --m size", {
  cbtag <- checkbox_Input(
    inputId = "cb_fieldset",
    label = "Pick one",
    cb_labels = c("Yes", "No"),
    checkboxIds = c("y", "n")
  )
  fieldset <- find_tag(cbtag, "govuk-fieldset")
  expect_identical(
    htmltools::tagGetAttribute(fieldset, "class"),
    "govuk-fieldset"
  )

  legend <- find_tag(fieldset, "govuk-fieldset__legend")
  expect_identical(
    htmltools::tagGetAttribute(legend, "class"),
    "govuk-fieldset__legend govuk-fieldset__legend--m"
  )
  expect_identical(legend$children[[1]], "Pick one")
})

test_that("label_size sets the legend size modifier", {
  for (size in c("s", "m", "l", "xl")) {
    cbtag <- checkbox_Input(
      inputId = "cb",
      label = "Q",
      cb_labels = c("a", "b"),
      checkboxIds = c("a", "b"),
      label_size = size
    )
    legend <- find_tag(cbtag, "govuk-fieldset__legend")
    expect_identical(
      htmltools::tagGetAttribute(legend, "class"),
      paste0("govuk-fieldset__legend govuk-fieldset__legend--", size)
    )
  }
})

test_that("label_size rejects unknown values", {
  expect_error(
    checkbox_Input(
      inputId = "cb",
      label = "Q",
      cb_labels = c("a", "b"),
      checkboxIds = c("a", "b"),
      label_size = "huge"
    )
  )
})

test_that("heading_level wraps the legend text in an <hN>", {
  cbtag <- checkbox_Input(
    inputId = "cb",
    label = "Q",
    cb_labels = c("a", "b"),
    checkboxIds = c("a", "b"),
    label_size = "l",
    heading_level = 1
  )
  legend <- find_tag(cbtag, "govuk-fieldset__legend")
  heading <- legend$children[[1]]
  expect_identical(heading$name, "h1")
  expect_identical(heading$attribs$class, "govuk-fieldset__heading")
  expect_identical(heading$children[[1]], "Q")
})

test_that("heading_level rejects invalid values", {
  expect_error(
    checkbox_Input(
      inputId = "cb",
      label = "Q",
      cb_labels = c("a", "b"),
      checkboxIds = c("a", "b"),
      heading_level = 0
    )
  )
  expect_error(
    checkbox_Input(
      inputId = "cb",
      label = "Q",
      cb_labels = c("a", "b"),
      checkboxIds = c("a", "b"),
      heading_level = 7
    )
  )
  expect_error(
    checkbox_Input(
      inputId = "cb",
      label = "Q",
      cb_labels = c("a", "b"),
      checkboxIds = c("a", "b"),
      heading_level = c(1, 2)
    )
  )
  expect_error(
    checkbox_Input(
      inputId = "cb",
      label = "Q",
      cb_labels = c("a", "b"),
      checkboxIds = c("a", "b"),
      heading_level = TRUE
    )
  )
  expect_error(
    checkbox_Input(
      inputId = "cb",
      label = "Q",
      cb_labels = c("a", "b"),
      checkboxIds = c("a", "b"),
      heading_level = 2.5
    )
  )
})

test_that("Fieldset aria-describedby references hint and error ids", {
  cbtag <- checkbox_Input(
    inputId = "cb_aria",
    label = "Pick one",
    cb_labels = c("Yes", "No"),
    checkboxIds = c("y", "n"),
    hint_label = "Choose wisely",
    error = TRUE,
    error_message = "Required"
  )
  fieldset <- find_tag(cbtag, "govuk-fieldset")
  expect_identical(
    htmltools::tagGetAttribute(fieldset, "aria-describedby"),
    "cb_aria-hint cb_aria-error"
  )

  hint <- find_tag(cbtag, "govuk-hint")
  expect_identical(htmltools::tagGetAttribute(hint, "id"), "cb_aria-hint")

  err <- find_tag(cbtag, "govuk-error-message")
  expect_identical(htmltools::tagGetAttribute(err, "id"), "cb_aria-error")
})

test_that("Fieldset has no aria-describedby when no hint or error", {
  cbtag <- checkbox_Input(
    inputId = "cb_plain",
    label = "Pick one",
    cb_labels = c("Yes", "No"),
    checkboxIds = c("y", "n")
  )
  fieldset <- find_tag(cbtag, "govuk-fieldset")
  expect_null(htmltools::tagGetAttribute(fieldset, "aria-describedby"))
})

test_that("Hint <div> is omitted when hint_label is NULL", {
  cbtag <- checkbox_Input(
    inputId = "cb_nohint",
    label = "Pick one",
    cb_labels = c("Yes", "No"),
    checkboxIds = c("y", "n")
  )
  expect_no_tag(cbtag, "govuk-hint")
})
