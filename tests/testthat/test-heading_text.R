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

test_that("level must be a whole number between 1 and 6", {
  expect_error(heading_text("x", level = 0))
  expect_error(heading_text("x", level = 7))
  expect_error(heading_text("x", level = TRUE))
  expect_error(heading_text("x", level = 2.5))
})

test_that("size must be one of xl, l, m, s", {
  # Reproduces the scenario from issue #254: a heading accidentally split
  # across two arguments instead of being paste()'d together.
  expect_error(heading_text("History", "and teachers"))
  expect_error(heading_text("x", size = "xxl"))
  expect_error(heading_text("x", size = 1))
  expect_error(heading_text("x", size = c("m", "l")))
})
