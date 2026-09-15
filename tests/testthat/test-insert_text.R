test_that("string content is wrapped with shiny::HTML", {
  insert_text <- insert_text("insert1", "Test insert")

  expect_identical(htmltools::tagGetAttribute(insert_text, "id"), "insert1")
  expect_identical(
    htmltools::tagGetAttribute(insert_text, "class"),
    "govuk-inset-text"
  )
  expect_match(as.character(insert_text), "Test insert", fixed = TRUE)
})

test_that("single shiny.tag content is rendered inside the inset", {
  tag <- shiny::tags$b("Bold inside")
  out <- insert_text("insert-tag", tag)

  html <- as.character(out)
  expect_match(html, "govuk-inset-text", fixed = TRUE)
  expect_match(html, "<b>Bold inside</b>", fixed = TRUE)
})

test_that("tagList content is rendered inside the inset", {
  content <- shiny::tagList(
    shiny::tags$b("A link: "),
    shiny::tags$a(href = "https://example.com", "link text")
  )
  out <- insert_text("insert-list", content)

  html <- as.character(out)
  expect_match(html, "<b>A link: </b>", fixed = TRUE)
  expect_match(html, "href=\"https://example.com\"", fixed = TRUE)
  expect_match(html, ">link text</a>", fixed = TRUE)
})

test_that("deprecated `text` argument still works with a warning", {
  rlang::local_options(lifecycle_verbosity = "warning")
  expect_warning(
    out <- insert_text("insert-dep", text = "Old style"),
    class = "lifecycle_warning_deprecated"
  )
  expect_match(as.character(out), "Old style", fixed = TRUE)
})

test_that("supplying both `content` and `text` errors", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_error(
    insert_text("insert-both", content = "new", text = "old"),
    "Supply only one"
  )
})

test_that("missing `content` errors", {
  expect_error(insert_text("insert-missing"), "`content` is required")
})
