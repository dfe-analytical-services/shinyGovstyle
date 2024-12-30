test_that("Default", {

  choices <- c("A", "B", "C")
  rtag <- radio_button_Input(
    inputId = "Id029",
    label = "Label",
    choices = choices,
    selected = "A"
  )
  choicestag <- rtag$children[[1]]$children[[4]]$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag, function(x) grepl(pattern = "checked", x = as.character(x)))
  checked <- unlist(checked)
  expect_equal(which(checked), 1)
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
  choicestag <- rtag$children[[1]]$children[[4]]$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag, function(x) grepl(pattern = "checked", x = as.character(x)))
  checked <- unlist(checked)
  expect_equal(which(checked), 1)

  err_msg <- rtag$children[[1]]$children[[3]]$children[[1]]
  expect_identical(err_msg, "Error Test")

  err_class <- paste(rtag$children[[1]]$children[[3]]$attribs$class,
                     rtag$children[[1]]$children[[3]]$attribs[3]$class)
  expect_identical(err_class, "govuk-error-message shinyjs-hide")
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
  choicestag <- rtag$children[[1]]$children[[4]]$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag, function(x) grepl(pattern = "checked", x = as.character(x)))
  checked <- unlist(checked)
  expect_equal(which(checked), 1)

  small_class <- rtag$children[[1]]$children[[4]]$attribs$class
  expect_identical(small_class, "govuk-radios govuk-radios--small")

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
  choicestag <- rtag$children[[1]]$children[[4]]$children[[1]]
  expect_length(choicestag, length(choices))

  checked <- lapply(
    choicestag, function(x) grepl(pattern = "checked", x = as.character(x)))
  checked <- unlist(checked)
  expect_equal(which(checked), 1)

  inline_class <- rtag$children[[1]]$children[[4]]$attribs$class
  expect_identical(inline_class, "govuk-radios govuk-radios--inline")

})
