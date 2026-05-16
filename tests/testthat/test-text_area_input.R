test_that("text area works", {
  text_area_check <- text_area_Input("input1", "Test area")

  expect_equal(
    as.numeric(htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-textarea"),
      "rows"
    )),
    5
  )

  expect_identical(
    tag_text(text_area_check, "govuk-label"),
    shiny::HTML("Test area")
  )
})


test_that("text area error works", {
  text_area_check <- text_area_Input(
    "input1",
    "Test area",
    error = TRUE,
    error_message = "Test error",
    row_no = 10
  )

  expect_equal(
    as.numeric(htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-textarea"),
      "rows"
    )),
    10
  )

  expect_hidden_error(text_area_check, "Test error")
})

test_that("text area word works", {
  text_area_check <- text_area_Input("input1", "Test area", word_limit = 300)

  hint <- find_tag(text_area_check, "govuk-character-count__message")

  expect_identical(
    htmltools::tagGetAttribute(hint, "class"),
    "govuk-hint govuk-character-count__message"
  )

  hint_html <- as.character(hint)
  expect_match(hint_html, "You have used", fixed = TRUE)
  expect_match(hint_html, "of the 300 allowed", fixed = TRUE)

  wc <- find_by_id_suffix(hint, "wc")[[1L]]
  wl <- find_by_id_suffix(hint, "wl")[[1L]]
  expect_match(as.character(wc), ">0<", fixed = TRUE)
  expect_match(as.character(wl), "of the 300 allowed", fixed = TRUE)
})

test_that("form group children appear in GOV.UK order", {
  text_area_check <- text_area_Input(
    "input1",
    "Test area",
    error = TRUE,
    error_message = "Test error",
    word_limit = 300
  )

  expect_identical(
    htmltools::tagGetAttribute(text_area_check, "class"),
    "govuk-form-group govuk-character-count"
  )
  expect_identical(
    child_classes(text_area_check),
    c(
      "govuk-label",
      "govuk-hint",
      "govuk-error-message shinyjs-hide",
      "govuk-textarea",
      "govuk-hint govuk-character-count__message"
    )
  )
})
