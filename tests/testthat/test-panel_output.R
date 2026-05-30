test_that("string sub_text renders inside the panel body", {
  out <- panel_output("panelId", "Main", "Second")

  html <- as.character(out)
  expect_match(html, "govuk-panel--confirmation", fixed = TRUE)
  expect_match(html, "Main", fixed = TRUE)
  expect_match(html, "Second", fixed = TRUE)
})

test_that("sub_text accepts a shiny.tag", {
  out <- panel_output(
    "panelId",
    main_text = "Main",
    sub_text = shiny::tags$b("Bold body")
  )

  expect_match(as.character(out), "<b>Bold body</b>", fixed = TRUE)
})

test_that("sub_text accepts a tagList", {
  out <- panel_output(
    "panelId",
    main_text = "Main",
    sub_text = shiny::tagList(
      "Reference: ",
      shiny::tags$strong("ABC123")
    )
  )

  html <- as.character(out)
  expect_match(html, "Reference: ", fixed = TRUE)
  expect_match(html, "<strong>ABC123</strong>", fixed = TRUE)
})
