test_that("label hint works", {
  label_check <- label_hint("hintID", "Upper", "Lower")

  expect_identical(tag_text(label_check, "govuk-label"), shiny::HTML("Upper"))
  expect_identical(tag_text(label_check, "govuk-hint"), shiny::HTML("Lower"))
})

test_that("label accepts a shiny.tag", {
  label_check <- label_hint("hintID", shiny::tags$b("Bold label"))

  expect_identical(
    tag_text(label_check, "govuk-label"),
    shiny::tags$b("Bold label")
  )
})

test_that("hint accepts a raw HTML string and renders unescaped", {
  label_check <- label_hint(
    "hintID",
    "Upper",
    shiny::HTML('See <a href="#">guidance</a>')
  )

  expect_match(
    as.character(tag_text(label_check, "govuk-hint")),
    '<a href="#">guidance</a>',
    fixed = TRUE
  )
})

test_that("NULL hint still renders an empty hint div", {
  label_check <- label_hint("hintID", "Upper")

  hint <- find_tag_required(label_check, "govuk-hint")
  expect_identical(as.character(hint), '<div class="govuk-hint"></div>')
})
