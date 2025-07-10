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
