test_that("panel_output() warns once, naming confirmation_panel()", {
  out <- expect_one_deprecation(
    panel_output("panel1", "Application complete", "Reference: ABC"),
    mentions = c(
      "panel_output()",
      "confirmation_panel()",
      "`title`",
      "`content`",
      "1.0.0"
    )
  )
  expect_same_output(
    out,
    confirmation_panel("panel1", "Application complete", "Reference: ABC")
  )
})

test_that("panel_output() named arguments map to title and content", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  body <- shiny::tagList("Reference: ", shiny::tags$strong("ABC123"))
  expect_same_output(
    panel_output(inputId = "panel1", main_text = "Done", sub_text = body),
    confirmation_panel(inputId = "panel1", title = "Done", content = body)
  )
})
