test_that("text area works", {
  text_area_check <- text_area_Input("input1", "Test area")
  query <- htmltools::tagQuery(text_area_check)

  textarea <- query$find("textarea")$selectedTags()
  expect_length(textarea, 1)
  expect_equal(textarea[[1]]$attribs$rows, 5)

  label <- query$find(".govuk-label")$selectedTags()
  expect_length(label, 1)
  expect_identical(label[[1]]$children[[1]], shiny::HTML("Test area"))
})


test_that("text area error works", {
  text_area_check <- text_area_Input(
    "input1",
    "Test area",
    error = TRUE,
    error_message = "Test error",
    row_no = 10
  )
  query <- htmltools::tagQuery(text_area_check)

  textarea <- query$find("textarea")$selectedTags()
  expect_length(textarea, 1)
  expect_equal(textarea[[1]]$attribs$rows, 10)

  error_msg <- query$find("#input1error")$selectedTags()
  expect_length(error_msg, 1)
  # shinyjs::hidden() adds its own "class" attrib alongside ours, so the tag
  # ends up with two class entries rather than one space-separated value.
  error_classes <- error_msg[[1]]$attribs[
    names(error_msg[[1]]$attribs) == "class"
  ]
  expect_identical(
    paste(unlist(error_classes), collapse = " "),
    "govuk-error-message shinyjs-hide"
  )
  expect_identical(error_msg[[1]]$children[[1]], "Test error")
  expect_identical(error_msg[[1]]$attribs$role, "alert")
})

test_that("text area word works", {
  text_area_check <- text_area_Input("input1", "Test area", word_limit = 300)
  query <- htmltools::tagQuery(text_area_check)

  textarea <- query$find("textarea")$selectedTags()
  expect_identical(
    textarea[[1]]$attribs$`aria-describedby`,
    "input1-info"
  )

  info <- query$find("#input1-info")$selectedTags()
  expect_length(info, 1)
  expect_identical(info[[1]]$children[[1]], "You can enter up to 300 words")
  expect_match(info[[1]]$attribs$class, "govuk-visually-hidden")

  status <- query$find("#input1-status")$selectedTags()
  expect_length(status, 1)
  expect_identical(status[[1]]$attribs$`aria-hidden`, "true")
  expect_identical(
    status[[1]]$children[[1]],
    "You can enter up to 300 words"
  )
  expect_identical(
    status[[1]]$attribs$class,
    "govuk-hint govuk-character-count__message govuk-character-count__status"
  )

  sr_status <- query$find("#input1-sr-status")$selectedTags()
  expect_length(sr_status, 1)
  expect_identical(sr_status[[1]]$attribs$`aria-live`, "polite")
  expect_identical(sr_status[[1]]$attribs$`aria-atomic`, "true")
  expect_match(sr_status[[1]]$attribs$class, "govuk-visually-hidden")
})
