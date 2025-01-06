test_that("test default footer", {
  footer_check <- footer()

  expect_identical(
    footer_check$attribs$class,
    "govuk-footer "
  )
})

test_that("test default footer", {
  footer_check <- footer(TRUE)

  expect_identical(
    footer_check$attribs$class,
    "govuk-footer "
  )
})

test_that("footer links add correctly", {
  footer_with_links <- footer(
    links = c("Accessibility Statement", "Cookies")
  ) |>
    paste0()

  expected_html <- '<a class=\"action-button govuk-link govuk-footer__link\" href=\"#\" id=\"accessibility_statement\">Accessibility Statement</a>'
  expect_true(grepl(expected_html, footer_with_links, fixed = TRUE))

  expected_html <- '<a class=\"action-button govuk-link govuk-footer__link\" href=\"#\" id=\"cookies\">Cookies</a>'
  expect_true(grepl(expected_html, footer_with_links, fixed = TRUE))

  expected_html <- '<h2 class=\"govuk-visually-hidden\">Support links</h2>\n          <ul class=\"govuk-footer__inline-list\">\n            <li class=\"govuk-footer__inline-list-item\">'
  expect_true(grepl(expected_html, footer_with_links, fixed = TRUE))

  full_footer_with_links <- footer(
    TRUE,
    c("Privacy Notice", "Cookies")
  ) |>
    paste0()

  expected_html <- '<a class=\"action-button govuk-link govuk-footer__link\" href=\"#\" id=\"privacy_notice\">Privacy Notice</a>'
  expect_true(grepl(expected_html, full_footer_with_links, fixed = TRUE))

  expected_html <- '<a class=\"action-button govuk-link govuk-footer__link\" href=\"#\" id=\"cookies\">Cookies</a>'
  expect_true(grepl(expected_html, full_footer_with_links, fixed = TRUE))

  expected_html <- '<h2 class=\"govuk-visually-hidden\">Support links</h2>\n          <ul class=\"govuk-footer__inline-list\">\n            <li class=\"govuk-footer__inline-list-item\">'
  expect_true(grepl(expected_html, full_footer_with_links, fixed = TRUE))
})
