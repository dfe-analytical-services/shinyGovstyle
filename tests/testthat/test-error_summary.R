test_that("error_summary builds the documented structure", {
  summary_tag <- error_summary(
    "error1",
    "Error Title",
    c("error entry 1", "error entry 2")
  )

  expect_identical(htmltools::tagGetAttribute(summary_tag, "id"), "error1")
  expect_identical(
    htmltools::tagGetAttribute(summary_tag, "class"),
    "govuk-error-summary"
  )

  expect_identical(
    as.character(tag_text(summary_tag, "govuk-error-summary__title")),
    "Error Title"
  )

  body <- find_tag_required(summary_tag, "govuk-error-summary__body")
  expect_identical(htmltools::tagGetAttribute(body, "id"), "error1list")

  list_tag <- find_tag_required(summary_tag, "govuk-error-summary__list")
  expect_identical(
    htmltools::tagGetAttribute(list_tag, "class"),
    "govuk-list govuk-error-summary__list"
  )

  expect_identical(
    unname(tag_text_by_name(list_tag, "li")),
    c("error entry 1", "error entry 2")
  )
})
