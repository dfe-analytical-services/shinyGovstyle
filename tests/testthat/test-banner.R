test_that("banner renders type tag and string label", {
  out <- banner("bannerId", "alpha", "Banner test")

  html <- as.character(out)
  expect_match(html, "govuk-phase-banner", fixed = TRUE)
  expect_match(html, "alpha", fixed = TRUE)
  expect_match(html, "Banner test", fixed = TRUE)
})

test_that("label accepts a shiny.tag", {
  out <- banner("bannerId", "beta", shiny::tags$b("Bold label"))

  expect_match(as.character(out), "<b>Bold label</b>", fixed = TRUE)
})

test_that("label accepts a tagList with an external link", {
  out <- banner(
    "bannerId",
    "beta",
    shiny::tagList(
      "This is a new service - your ",
      shiny::tags$a(href = "https://example.com", "feedback"),
      " will help us improve it."
    )
  )

  html <- as.character(out)
  expect_match(html, "This is a new service", fixed = TRUE)
  expect_match(html, "href=\"https://example.com\"", fixed = TRUE)
  expect_match(html, ">feedback</a>", fixed = TRUE)
})
