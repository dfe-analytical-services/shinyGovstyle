test_that("default", {
  head_text <- heading_text("Test Time")

  expect_identical(
    head_text$attribs$class,
    "govuk-heading-xl"
  )

  expect_identical(
    shiny::HTML("Test Time"),
    head_text$children[[1]]
  )
})

test_that("medium_works", {
  head_text <- heading_text("Test Time", "m")

  expect_identical(
    head_text$attribs$class,
    "govuk-heading-m"
  )

  expect_identical(
    shiny::HTML("Test Time"),
    head_text$children[[1]]
  )
})
