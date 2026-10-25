test_that("test default footer", {
  footer_check <- footer()

  expect_identical(
    htmltools::tagGetAttribute(footer_check, "class"),
    "govuk-footer "
  )
})

test_that("test default footer", {
  footer_check <- footer(TRUE)

  expect_identical(
    htmltools::tagGetAttribute(footer_check, "class"),
    "govuk-footer "
  )
})

test_that("footer links add correctly", {
  footer_with_links <- footer(
    links = c("Accessibility Statement", "Cookies")
  )

  expect_snapshot(footer_with_links)

  full_footer_with_links <- footer(
    TRUE,
    c("Privacy Notice", "Cookies")
  )

  expect_snapshot(full_footer_with_links)

  full_with_mixed_links <- footer(
    TRUE,
    c(
      `Privacy Notice` = "privacy_notice_link",
      `GitHub repository` = paste0(
        "https://github.com/dfe-analytical-services/shinyGovstyle"
      )
    )
  )

  expect_snapshot(full_with_mixed_links)

  full_with_ext_links <- footer(
    TRUE,
    c(
      `Privacy notice` = paste0(
        "https://github.com/dfe-analytical-services/shinyGovstyle"
      ),
      `GitHub repository` = paste0(
        "https://github.com/dfe-analytical-services/shinyGovstyle"
      )
    )
  )

  expect_snapshot(full_with_ext_links)
})


test_that("width defaults to standard, no three-quarters/full class", {
  footer_check <- footer()
  container <- find_tag_required(footer_check, "govuk-width-container")
  expect_null(htmltools::tagGetAttribute(container, "style"))
  expect_no_tag(footer_check, "govuk-width-container--standard")
  expect_no_tag(footer_check, "govuk-width-container--three-quarters")
  expect_no_tag(footer_check, "govuk-width-container--full")
})

test_that("width = 'standard' explicitly still renders the standard class", {
  footer_check <- footer(width = "standard")
  expect_has_tag(footer_check, "govuk-width-container--standard")
})


test_that("width = 'full' adds the full modifier class", {
  footer_check <- footer(width = "full")
  expect_has_tag(footer_check, "govuk-width-container--full")
})


test_that("a custom width sets an inline max-width style", {
  footer_check <- footer(width = "90vw")
  container <- find_tag_required(footer_check, "govuk-width-container")
  expect_identical(
    htmltools::tagGetAttribute(container, "style"),
    "max-width: 90vw;"
  )
})

test_that("branding = 'govuk' adds the decorative GOV.UK crown", {
  f <- footer(full = TRUE, branding = "govuk")
  crown <- find_tag_required(f, "govuk-footer__crown")
  expect_identical(crown$name, "svg")
  expect_identical(htmltools::tagGetAttribute(crown, "role"), "presentation")
  expect_identical(htmltools::tagGetAttribute(crown, "viewBox"), "0 0 64 60")
  expect_null(htmltools::tagGetAttribute(crown, "aria-label"))
  # The crown alone, without the GOV.UK wordmark
  expect_no_tag(crown, "govuk-logo-dot")
  # The licence and copyright are unchanged
  expect_has_tag(f, "govuk-footer__licence-description")
  expect_has_tag(f, "govuk-footer__copyright-logo")
})

test_that("the default footer has no GOV.UK crown", {
  expect_no_tag(footer(full = TRUE), "govuk-footer__crown")
  expect_error(footer(branding = "crown"), "should be one of")
})
