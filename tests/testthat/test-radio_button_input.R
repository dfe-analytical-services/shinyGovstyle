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
