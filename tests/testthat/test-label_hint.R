test_that("label hint works", {
  html <- as.character(label_hint("hintID", "Upper", "Lower"))

  expect_match(html, '<label class="govuk-label">Upper</label>', fixed = TRUE)
  expect_match(html, '<div class="govuk-hint">Lower</div>', fixed = TRUE)
})

test_that("label accepts a shiny.tag", {
  html <- as.character(label_hint("hintID", shiny::tags$b("Bold label")))

  expect_match(html, "<b>Bold label</b>", fixed = TRUE)
})

test_that("hint accepts a raw HTML string and renders unescaped", {
  html <- as.character(
    label_hint("hintID", "Upper", shiny::HTML('See <a href="#">guidance</a>'))
  )

  expect_match(html, '<a href="#">guidance</a>', fixed = TRUE)
})

test_that("NULL hint still renders an empty hint div", {
  html <- as.character(label_hint("hintID", "Upper"))

  expect_match(html, '<div class="govuk-hint"></div>', fixed = TRUE)
})
