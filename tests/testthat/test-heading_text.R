test_that("default", {
  head_text <- heading_text("Test Time")

  expect_identical(
    htmltools::tagGetAttribute(head_text, "class"),
    "govuk-heading-xl"
  )

  expect_identical(
    shiny::HTML("Test Time"),
    tag_text(head_text, "govuk-heading-xl")
  )
})

test_that("medium_works", {
  head_text <- heading_text("Test Time", "m")

  expect_identical(
    htmltools::tagGetAttribute(head_text, "class"),
    "govuk-heading-m"
  )

  expect_identical(
    shiny::HTML("Test Time"),
    tag_text(head_text, "govuk-heading-m")
  )
})
