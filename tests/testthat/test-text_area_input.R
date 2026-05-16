test_that("text area works", {
  text_area_check <- text_area_Input("input1", "Test area")

  expect_equal(
    htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-textarea"),
      "rows"
    ),
    "5"
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
    htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-textarea"),
      "rows"
    ),
    "10"
  )

  err <- find_tag(text_area_check, "govuk-error-message")
  expect_length(find_tags(text_area_check, "govuk-error-message"), 1L)
  expect_identical(
    htmltools::tagGetAttribute(err, "class"),
    "govuk-error-message shinyjs-hide"
  )

  expect_identical(err$children[[1]], "Test error")
})

test_that("text area word works", {
  text_area_check <- text_area_Input("input1", "Test area", word_limit = 300)

  hint <- find_tag(text_area_check, "govuk-character-count__message")
  expect_identical(
    paste(
      vapply(
        hint$children,
        function(c) as.character(c$children[[1]]),
        character(1L)
      ),
      collapse = " "
    ),
    "You have used 0 of the 300 allowed"
  )

  expect_identical(
    htmltools::tagGetAttribute(hint, "class"),
    "govuk-hint govuk-character-count__message"
  )
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
