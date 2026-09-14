test_that("banner renders type tag and string label", {
  out <- banner("bannerId", "alpha", "Banner test")

  expect_identical(
    htmltools::tagGetAttribute(out, "class"),
    "govuk-phase-banner"
  )

  expect_identical(htmltools::tagGetAttribute(out, "id"), "bannerId")

  expect_identical(
    tag_text(out, "govuk-phase-banner__content__tag"),
    "alpha"
  )

  expect_identical(
    tag_text(out, "govuk-phase-banner__text"),
    shiny::HTML("Banner test")
  )
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

test_that("feedback_url auto-generates the standard feedback text", {
  out <- banner(
    "bannerId",
    "beta",
    feedback_url = "https://example.com/feedback"
  )

  html <- as.character(out)
  expect_match(
    html,
    "This is a new service - your",
    fixed = TRUE
  )
  expect_match(html, "href=\"https://example.com/feedback\"", fixed = TRUE)
  expect_match(html, "feedback (opens in new tab)", fixed = TRUE)
  expect_match(html, "target=\"_blank\"", fixed = TRUE)
  expect_match(html, "rel=\"noopener noreferrer\"", fixed = TRUE)
  expect_match(html, "will help us to improve it.", fixed = TRUE)
})

test_that("mailto: feedback_url auto-generates contact text", {
  out <- banner(
    "bannerId",
    "beta",
    feedback_url = "mailto:feedback@example.com"
  )

  html <- as.character(out)
  expect_match(
    html,
    "This is a new service - please contact",
    fixed = TRUE
  )
  expect_match(html, "href=\"mailto:feedback@example.com\"", fixed = TRUE)
  expect_match(html, ">feedback@example.com</a>", fixed = TRUE)
  expect_match(
    html,
    "if you have any questions or feedback.",
    fixed = TRUE
  )
  expect_false(grepl("target=\"_blank\"", html, fixed = TRUE))
  expect_false(grepl("opens in new tab", html, fixed = TRUE))
})

test_that("mailto: feedback_url strips query params from displayed address", {
  out <- banner(
    "bannerId",
    "beta",
    feedback_url = "mailto:feedback@example.com?subject=Feedback"
  )

  html <- as.character(out)
  expect_match(
    html,
    "href=\"mailto:feedback@example.com?subject=Feedback\"",
    fixed = TRUE
  )
  expect_match(html, ">feedback@example.com</a>", fixed = TRUE)
})

test_that("banner errors when both label and feedback_url are given", {
  expect_error(
    banner(
      "bannerId",
      "beta",
      label = "This is a new service",
      feedback_url = "https://example.com/feedback"
    ),
    "Provide only one of"
  )
})

test_that("banner errors when neither label nor feedback_url are given", {
  expect_error(
    banner("bannerId", "beta"),
    "Either `label` or `feedback_url` must be provided"
  )
})
