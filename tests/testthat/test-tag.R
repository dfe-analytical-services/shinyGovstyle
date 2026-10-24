test_that("tag_Input() warns once, naming gov_tag()", {
  out <- expect_one_deprecation(
    tag_Input("tag1", "Complete"),
    mentions = c("tag_Input()", "gov_tag()", "1.0.0")
  )
  expect_same_output(out, gov_tag("tag1", "Complete"))
})

test_that("tag_Input() positional and named calls match gov_tag()", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_same_output(
    tag_Input("tag1", "Incomplete", "red"),
    gov_tag("tag1", "Incomplete", "red")
  )
  expect_same_output(
    tag_Input(inputId = "tag1", text = "Incomplete", colour = "red"),
    gov_tag(inputId = "tag1", text = "Incomplete", colour = "red")
  )
})

test_that("tag_Input() still warns about unsupported colours", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_warning(
    tag_Input("tag1", "Complete", "pink"),
    "'pink' is no longer a supported colour"
  )
})
