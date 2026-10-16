test_that("insert_text() warns once, naming inset_text()", {
  out <- expect_one_deprecation(
    insert_text("note", "Some text"),
    mentions = c("insert_text()", "inset_text()", "1.0.0")
  )
  expect_same_output(out, inset_text("note", "Some text"))
})

test_that("insert_text() named calls match inset_text()", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  content <- shiny::tagList(shiny::tags$b("Bold: "), "text")
  expect_same_output(
    insert_text(inputId = "note", content = content),
    inset_text(inputId = "note", content = content)
  )
})

test_that("deprecated `text` gives one warning naming inset_text(content)", {
  out <- expect_one_deprecation(
    insert_text("note", text = "Old style"),
    mentions = c("`text`", "`content`", "inset_text()")
  )
  expect_same_output(out, inset_text("note", "Old style"))
})

test_that("supplying both `content` and `text` errors", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_error(
    insert_text("note", content = "new", text = "old"),
    "Supply only one"
  )
})

test_that("missing `content` still errors", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_error(insert_text("note"), "`content` is required")
})
