test_that("string label and help_text render as HTML inside the details", {
  out <- details("detailId", "Test Main", "Test Second")

  html <- as.character(out)
  expect_match(html, "govuk-details", fixed = TRUE)
  expect_match(html, "Test Main", fixed = TRUE)
  expect_match(html, "Test Second", fixed = TRUE)
})

test_that("help_text accepts a tagList", {
  out <- details(
    "detailId",
    label = "Label",
    help_text = shiny::tagList(
      shiny::tags$p("Paragraph one."),
      shiny::tags$p("Paragraph two.")
    )
  )

  html <- as.character(out)
  expect_match(html, "<p>Paragraph one.</p>", fixed = TRUE)
  expect_match(html, "<p>Paragraph two.</p>", fixed = TRUE)
})

test_that("help_text accepts a single shiny.tag", {
  out <- details(
    "detailId",
    label = "Label",
    help_text = shiny::tags$p("Just a paragraph.")
  )

  expect_match(as.character(out), "<p>Just a paragraph.</p>", fixed = TRUE)
})
