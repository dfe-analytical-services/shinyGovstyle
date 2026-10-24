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

  textarea <- find_tag(text_area_check, "govuk-textarea")
  expect_identical(
    htmltools::tagGetAttribute(textarea, "aria-describedby"),
    "input1-info"
  )

  info <- find_by_id_suffix(text_area_check, "input1-info")
  expect_identical(
    htmltools::tagGetAttribute(info, "class"),
    "govuk-hint govuk-character-count__message govuk-visually-hidden"
  )
  expect_identical(
    tag_text_by_id_suffix(text_area_check, "input1-info"),
    "You can enter up to 300 words"
  )

  # "input1-status" (not just "-status"): "-sr-status" also ends in "-status".
  status <- find_by_id_suffix(text_area_check, "input1-status")
  expect_identical(htmltools::tagGetAttribute(status, "aria-hidden"), "true")
  expect_identical(
    htmltools::tagGetAttribute(status, "class"),
    "govuk-hint govuk-character-count__message govuk-character-count__status"
  )
  expect_identical(
    tag_text_by_id_suffix(text_area_check, "input1-status"),
    "You can enter up to 300 words"
  )

  sr_status <- find_by_id_suffix(text_area_check, "input1-sr-status")
  expect_identical(
    htmltools::tagGetAttribute(sr_status, "aria-live"),
    "polite"
  )
  expect_identical(
    htmltools::tagGetAttribute(sr_status, "aria-atomic"),
    "true"
  )
  expect_match(
    htmltools::tagGetAttribute(sr_status, "class"),
    "govuk-visually-hidden"
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
      "govuk-hint govuk-character-count__message govuk-visually-hidden",
      "govuk-error-message shinyjs-hide",
      "govuk-textarea govuk-js-character-count",
      # the word-limit info/status/sr-status divs, wrapped in a tagList
      "<list>"
    )
  )
})
