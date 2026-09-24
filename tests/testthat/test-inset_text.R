test_that("string content is wrapped with shiny::HTML", {
  inset <- inset_text("inset1", "Test inset")

  expect_identical(htmltools::tagGetAttribute(inset, "id"), "inset1")
  expect_identical(
    htmltools::tagGetAttribute(inset, "class"),
    "govuk-inset-text"
  )
  expect_match(as.character(inset), "Test inset", fixed = TRUE)
})

test_that("single shiny.tag content is rendered inside the inset", {
  tag <- shiny::tags$b("Bold inside")
  out <- inset_text("inset-tag", tag)

  html <- as.character(out)
  expect_match(html, "govuk-inset-text", fixed = TRUE)
  expect_match(html, "<b>Bold inside</b>", fixed = TRUE)
})

test_that("tagList content is rendered inside the inset", {
  content <- shiny::tagList(
    shiny::tags$b("A link: "),
    shiny::tags$a(href = "https://example.com", "link text")
  )
  out <- inset_text("inset-list", content)

  html <- as.character(out)
  expect_match(html, "<b>A link: </b>", fixed = TRUE)
  expect_match(html, "href=\"https://example.com\"", fixed = TRUE)
  expect_match(html, ">link text</a>", fixed = TRUE)
})

test_that("missing `content` errors", {
  expect_error(inset_text("inset-missing"), "`content` is required")
})
