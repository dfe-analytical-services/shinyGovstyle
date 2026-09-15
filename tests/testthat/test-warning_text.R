test_that("warning renders string text in the body", {
  out <- warning_text("warningId", "Test")

  html <- as.character(out)
  expect_match(html, "govuk-warning-text", fixed = TRUE)
  expect_match(html, "Test", fixed = TRUE)
})

test_that("text accepts a shiny.tag", {
  out <- warning_text("warningId", shiny::tags$b("Bold warning"))

  expect_match(as.character(out), "<b>Bold warning</b>", fixed = TRUE)
})

test_that("text accepts a tagList", {
  out <- warning_text(
    "warningId",
    shiny::tagList(
      "You can be fined up to ",
      shiny::tags$i("£5,000"),
      " if you do not register."
    )
  )

  html <- as.character(out)
  expect_match(html, "You can be fined up to", fixed = TRUE)
  expect_match(html, "<i>£5,000</i>", fixed = TRUE)
})
