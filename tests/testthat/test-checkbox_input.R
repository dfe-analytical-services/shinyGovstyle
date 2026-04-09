test_that("Default", {
  choices <- c("A", "B", "C")
  cbtag <- checkbox_Input(
    inputId = "Id029",
    label = "Label",
    cb_labels = choices,
    checkboxIds = choices
  )
  choicestag <- cbtag$children[[1]]$children[[1]]$children[[4]]$children[[1]]
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
  choicestag <- cbtag$children[[1]]$children[[1]]$children[[4]]$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_true(all(!checked))

  err_msg <- cbtag$children[[1]]$children[[1]]$children[[3]]$children[[1]]
  expect_identical(err_msg, "Error Test")

  err_class <- paste(
    cbtag$children[[1]]$children[[1]]$children[[3]]$attribs[1]$class,
    cbtag$children[[1]]$children[[1]]$children[[3]]$attribs[3]$class
  )
  expect_identical(err_class, "govuk-error-message shinyjs-hide")
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
  choicestag <- cbtag$children[[1]]$children[[1]]$children[[4]]$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag,
    function(x) grepl(pattern = "checked", x = as.character(x))
  )
  checked <- unlist(checked)
  expect_true(all(!checked))

  small_check <- cbtag$children[[1]]$children[[1]]$children[[4]]$attribs$class
  expect_identical(small_check, "govuk-checkboxes govuk-checkboxes--small")
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
  option_items <- cbtag$children[[1]]$children[[1]]$children[[4]]$children[[1]]

  for (i in seq_along(cb_ids)) {
    item <- option_items[[i]]
    input_tag <- item$children[[1]]
    label_tag <- item$children[[2]]
    expect_identical(input_tag$attribs$id, cb_ids[i])
    expect_identical(label_tag$attribs$`for`, cb_ids[i])
  }
})
