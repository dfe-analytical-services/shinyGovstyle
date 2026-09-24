test_that("word_count() warns once, pointing to text_area_Input(word_limit)", {
  recorder <- make_call_recorder()
  local_mocked_bindings(html = recorder$record("html"), .package = "shinyjs")

  expect_one_deprecation(
    word_count("text_area", "three little words"),
    mentions = c(
      "word_count()",
      "0.3.0",
      "text_area_Input(word_limit = )",
      "observeEvent()",
      "1.0.0"
    )
  )

  # Behaviour is unchanged while the function remains
  calls <- recorder$get()
  expect_identical(recorded_arg(calls[[1]], "html", 2), 3L)
})
