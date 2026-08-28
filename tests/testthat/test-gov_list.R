# Check list length
test_that("list length", {
  gov_list_check <- gov_list(list = c("a", "b", "c"))

  expect_equal(3, length(gov_list(list = c("a", "b", "c"))$children[[1]]))
})

# Check list type
test_that("bulleted list type", {
  gov_list_check <- gov_list(list = c("a", "b", "c"))

  expect_equal("ul", gov_list_check[[1]])
})

# Check list class
test_that("bulleted list class", {
  gov_list_check <- gov_list(list = c("a", "b", "c"))

  expect_equal("govuk-list ", gov_list_check$attribs$class[[1]])
})

# Check bullet list type
test_that("bulleted list type", {
  gov_list_check <- gov_list(list = c("a", "b", "c"), style = "bullet")

  expect_equal("ul", gov_list_check[[1]])
})

# Check bullet list class
test_that("bulleted list class", {
  gov_list_check <- gov_list(list = c("a", "b", "c"), style = "bullet")

  expect_equal(
    "govuk-list govuk-list--bullet",
    gov_list_check$attribs$class[[1]]
  )
})


# Check numbered list type
test_that("numbered list type", {
  gov_list_check <- gov_list(list = c("a", "b", "c"), style = "number")

  expect_equal("ol", gov_list_check[[1]])
})

# Check numbered list class
test_that("numbered list class", {
  gov_list_check <- gov_list(list = c("a", "b", "c"), style = "number")

  expect_equal(
    "govuk-list govuk-list--number",
    gov_list_check$attribs$class[[1]]
  )
})

# Check string items still render as plain text
test_that("string items render in list items", {
  html <- as.character(gov_list(list = c("a", "b")))

  expect_match(html, "<li>a</li>", fixed = TRUE)
  expect_match(html, "<li>b</li>", fixed = TRUE)
})

# Check a shiny.tag item (e.g. a link) renders
test_that("list items accept a shiny.tag", {
  html <- as.character(
    gov_list(
      list = list("Plain", shiny::tags$a(href = "https://www.gov.uk", "Link")),
      style = "bullet"
    )
  )

  expect_match(html, '<a href="https://www.gov.uk">Link</a>', fixed = TRUE)
})

# Check a tagList item renders
test_that("list items accept a tagList", {
  html <- as.character(
    gov_list(
      list = list(shiny::tagList("Item with ", shiny::tags$b("bold")))
    )
  )

  expect_match(html, "Item with", fixed = TRUE)
  expect_match(html, "<b>bold</b>", fixed = TRUE)
})

# Check a raw HTML string item renders unescaped
test_that("list items accept a raw HTML string", {
  html <- as.character(
    gov_list(list = list(shiny::HTML("<b>raw</b>")))
  )

  expect_match(html, "<li><b>raw</b></li>", fixed = TRUE)
})
