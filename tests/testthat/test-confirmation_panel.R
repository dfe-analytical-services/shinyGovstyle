test_that("string content renders inside the panel body", {
  out <- confirmation_panel("panelId", "Main", "Second")

  html <- as.character(out)
  expect_match(html, "govuk-panel--confirmation", fixed = TRUE)
  expect_match(html, "Main", fixed = TRUE)
  expect_match(html, "Second", fixed = TRUE)
})

test_that("content accepts a shiny.tag", {
  out <- confirmation_panel(
    "panelId",
    title = "Main",
    content = shiny::tags$b("Bold body")
  )

  expect_match(as.character(out), "<b>Bold body</b>", fixed = TRUE)
})

test_that("content accepts a tagList", {
  out <- confirmation_panel(
    "panelId",
    title = "Main",
    content = shiny::tagList(
      "Reference: ",
      shiny::tags$strong("ABC123")
    )
  )

  html <- as.character(out)
  expect_match(html, "Reference: ", fixed = TRUE)
  expect_match(html, "<strong>ABC123</strong>", fixed = TRUE)
})
