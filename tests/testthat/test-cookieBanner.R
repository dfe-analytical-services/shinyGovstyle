test_that("cookie banner works", {
  banner <- shinyGovstyle::cookieBanner("The best thing")
  query <- htmltools::tagQuery(banner)

  # The banner heading keeps its banner-specific class and shows the service
  # name (heading_text() is deliberately not used here as it cannot reproduce
  # the govuk-cookie-banner__heading class).
  heading <- query$find(".govuk-cookie-banner__heading")$selectedTags()
  expect_length(heading, 1)
  expect_match(as.character(heading[[1]]), "Cookies on The best thing")

  # Body copy is rendered via gov_text(), so it carries the govuk-body class.
  bodies <- query$find(".govuk-body")$selectedTags()
  expect_gte(length(bodies), 2)
  expect_match(
    paste(vapply(bodies, as.character, character(1)), collapse = " "),
    "We use some essential cookies to make this service work."
  )

  # The accept / reject confirmation panels exist and are hidden by shinyjs.
  accept <- query$find("#cookieAcceptDiv")$selectedTags()
  expect_length(accept, 1)
  expect_match(as.character(accept[[1]]), "shinyjs-hide")

  reject <- query$find("#cookieRejectDiv")$selectedTags()
  expect_length(reject, 1)
  expect_match(as.character(reject[[1]]), "shinyjs-hide")
})
