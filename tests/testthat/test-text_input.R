test_that("text box works", {
  text_check <- text_Input("txtId", "Text test")

  expect_identical(
    tag_text(text_check, "govuk-label"),
    shiny::HTML("Text test")
  )
})

test_that("text width change", {
  text_check <- text_Input("txtId", "Text test", width = 30)

  expect_identical(
    htmltools::tagGetAttribute(find_tag(text_check, "govuk-input"), "class"),
    "govuk-input govuk-input--width-30"
  )
})


test_that("text box error works", {
  text_check <- text_Input(
    "txtId",
    "Text test",
    error = TRUE,
    error_message = "Error test"
  )

  expect_hidden_error(text_check, "Error test")
})

test_that("text box prefix works", {
  text_check <- text_Input("txtId", "Text test", prefix = "£")

  expect_identical(
    tag_text(text_check, "govuk-input__prefix"),
    "£"
  )
})

test_that("text box suffix works", {
  text_check <- text_Input("txtId", "Text test", suffix = ".00")

  expect_identical(
    tag_text(text_check, "govuk-input__suffix"),
    ".00"
  )
})

test_that("text box prefix suffix works", {
  text_check <- text_Input("txtId", "Text test", prefix = "£", suffix = ".00")

  expect_identical(
    tag_text(text_check, "govuk-input__prefix"),
    "£"
  )
  expect_identical(
    tag_text(text_check, "govuk-input__suffix"),
    ".00"
  )
})

test_that("form group children appear in GOV.UK order", {
  text_check <- text_Input(
    "txtId",
    "Text test",
    error = TRUE,
    error_message = "Error test"
  )

  expect_identical(
    htmltools::tagGetAttribute(text_check, "class"),
    "govuk-form-group"
  )
  expect_identical(
    child_classes(text_check),
    c(
      "govuk-label",
      "govuk-error-message shinyjs-hide",
      "govuk-input"
    )
  )
})

test_that("label accepts a shiny.tag", {
  html <- as.character(text_Input("txtId", shiny::tags$b("Bold label")))

  expect_match(html, "<b>Bold label</b>", fixed = TRUE)
})

test_that("hint accepts a raw HTML string and renders unescaped", {
  html <- as.character(
    text_Input(
      "txtId",
      "Text test",
      hint_label = shiny::HTML('See <a href="#">guidance</a>')
    )
  )

  expect_match(html, '<a href="#">guidance</a>', fixed = TRUE)
})

test_that("NULL hint renders no hint div", {
  text_check <- text_Input("txtId", "Text test")

  expect_no_tag(text_check, "govuk-hint")
})

test_that("label is programmatically associated with the input", {
  text_check <- text_Input("txtId", "Text test")

  label <- find_tag_required(text_check, "govuk-label")
  input <- find_tag_required(text_check, "govuk-input")
  expect_identical(htmltools::tagGetAttribute(label, "for"), "txtId")
  expect_identical(htmltools::tagGetAttribute(input, "id"), "txtId")
})

test_that("hint is referenced by aria-describedby only when given", {
  with_hint <- text_Input("txtId", "Text test", hint_label = "Hint")
  without_hint <- text_Input("txtId", "Text test")

  hint <- find_tag_required(with_hint, "govuk-hint")
  expect_identical(htmltools::tagGetAttribute(hint, "id"), "txtId-hint")
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag(with_hint, "govuk-input"),
      "aria-describedby"
    ),
    "txtId-hint"
  )
  expect_null(
    htmltools::tagGetAttribute(
      find_tag(without_hint, "govuk-input"),
      "aria-describedby"
    )
  )
})

test_that("hidden error id is never in the rendered aria-describedby", {
  # The error paragraph renders hidden; referencing it would make screen
  # readers announce an error before error_on() has raised one.
  text_check <- text_Input(
    "txtId",
    "Text test",
    hint_label = "Hint",
    error = TRUE,
    error_message = "Error test"
  )

  expect_identical(
    htmltools::tagGetAttribute(
      find_tag(text_check, "govuk-input"),
      "aria-describedby"
    ),
    "txtId-hint"
  )
})

test_that("prefix and suffix variants keep the label and hint wiring", {
  variants <- list(
    text_Input("txtId", "Text test", hint_label = "Hint", prefix = "£"),
    text_Input("txtId", "Text test", hint_label = "Hint", suffix = ".00"),
    text_Input(
      "txtId",
      "Text test",
      hint_label = "Hint",
      prefix = "£",
      suffix = ".00"
    )
  )

  for (text_check in variants) {
    input <- find_tag_required(text_check, "govuk-input")
    expect_identical(htmltools::tagGetAttribute(input, "id"), "txtId")
    expect_identical(
      htmltools::tagGetAttribute(input, "aria-describedby"),
      "txtId-hint"
    )
    expect_identical(
      htmltools::tagGetAttribute(
        find_tag(text_check, "govuk-label"),
        "for"
      ),
      "txtId"
    )
  }
})
