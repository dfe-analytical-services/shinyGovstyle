cb_items <- function(cbtag) {
  htmltools::tagQuery(cbtag)$find(".govuk-checkboxes__item")$selectedTags()
}

cb_group_div <- function(cbtag) {
  htmltools::tagQuery(cbtag)$find(".govuk-checkboxes")$selectedTags()[[1]]
}

test_that("Default", {
  choices <- c("A", "B", "C")
  cbtag <- checkbox_Input(
    inputId = "Id029",
    label = "Label",
    cb_labels = choices,
    checkboxIds = choices
  )
  items <- cb_items(cbtag)
  expect_length(items, length(choices))

  checked <- vapply(
    items,
    function(x) grepl(pattern = "checked", x = as.character(x)),
    logical(1)
  )
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
  items <- cb_items(cbtag)
  expect_length(items, length(choices))

  err_p <- htmltools::tagQuery(cbtag)$find(
    ".govuk-error-message"
  )$selectedTags()[[1]]
  expect_identical(err_p$children[[1]], "Error Test")
  err_html <- as.character(err_p)
  expect_match(err_html, "govuk-error-message")
  expect_match(err_html, "shinyjs-hide")
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
  items <- cb_items(cbtag)
  expect_length(items, length(choices))

  expect_identical(
    cb_group_div(cbtag)$attribs$class,
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
  items <- cb_items(cbtag)

  for (i in seq_along(cb_ids)) {
    tq <- htmltools::tagQuery(items[[i]])
    input_tag <- tq$find("input")$selectedTags()[[1]]
    label_tag <- tq$find("label")$selectedTags()[[1]]
    expect_identical(input_tag$attribs$id, cb_ids[i])
    expect_identical(label_tag$attribs$`for`, cb_ids[i])
  }
})

test_that("Fieldset and legend wrap checkbox group with default --m size", {
  cbtag <- checkbox_Input(
    inputId = "cb_fieldset",
    label = "Pick one",
    cb_labels = c("Yes", "No"),
    checkboxIds = c("y", "n")
  )
  fieldset <- htmltools::tagQuery(cbtag)$find("fieldset")$selectedTags()[[1]]
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
    cbtag <- checkbox_Input(
      inputId = "cb",
      label = "Q",
      cb_labels = c("a", "b"),
      checkboxIds = c("a", "b"),
      label_size = size
    )
    legend <- htmltools::tagQuery(cbtag)$find("legend")$selectedTags()[[1]]
    expect_identical(
      legend$attribs$class,
      paste0("govuk-fieldset__legend govuk-fieldset__legend--", size)
    )
  }
})

test_that("label_size rejects unknown values", {
  expect_error(
    checkbox_Input(
      inputId = "cb", label = "Q",
      cb_labels = c("a", "b"), checkboxIds = c("a", "b"),
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
  legend <- htmltools::tagQuery(cbtag)$find("legend")$selectedTags()[[1]]
  heading <- legend$children[[1]]
  expect_identical(heading$name, "h1")
  expect_identical(heading$attribs$class, "govuk-fieldset__heading")
  expect_identical(heading$children[[1]], "Q")
})

test_that("heading_level rejects invalid values", {
  expect_error(
    checkbox_Input(
      inputId = "cb", label = "Q",
      cb_labels = c("a", "b"), checkboxIds = c("a", "b"),
      heading_level = 0
    )
  )
  expect_error(
    checkbox_Input(
      inputId = "cb", label = "Q",
      cb_labels = c("a", "b"), checkboxIds = c("a", "b"),
      heading_level = 7
    )
  )
  expect_error(
    checkbox_Input(
      inputId = "cb", label = "Q",
      cb_labels = c("a", "b"), checkboxIds = c("a", "b"),
      heading_level = c(1, 2)
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
  fieldset <- htmltools::tagQuery(cbtag)$find("fieldset")$selectedTags()[[1]]
  expect_identical(
    fieldset$attribs$`aria-describedby`,
    "cb_aria-hint cb_aria-error"
  )

  hint <- htmltools::tagQuery(cbtag)$find(".govuk-hint")$selectedTags()[[1]]
  expect_identical(hint$attribs$id, "cb_aria-hint")

  err <- htmltools::tagQuery(cbtag)$find(
    ".govuk-error-message"
  )$selectedTags()[[1]]
  expect_identical(err$attribs$id, "cb_aria-error")
})

test_that("Fieldset has no aria-describedby when no hint or error", {
  cbtag <- checkbox_Input(
    inputId = "cb_plain",
    label = "Pick one",
    cb_labels = c("Yes", "No"),
    checkboxIds = c("y", "n")
  )
  fieldset <- htmltools::tagQuery(cbtag)$find("fieldset")$selectedTags()[[1]]
  expect_null(fieldset$attribs$`aria-describedby`)
})

test_that("Hint <div> is omitted when hint_label is NULL", {
  cbtag <- checkbox_Input(
    inputId = "cb_nohint",
    label = "Pick one",
    cb_labels = c("Yes", "No"),
    checkboxIds = c("y", "n")
  )
  hints <- htmltools::tagQuery(cbtag)$find(".govuk-hint")$selectedTags()
  expect_length(hints, 0)
})
