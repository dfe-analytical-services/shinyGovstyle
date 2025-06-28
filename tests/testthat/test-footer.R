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
  local_edition(3)

  footer_with_links <- footer(
    links = c("Accessibility Statement", "Cookies")
  )

  expect_snapshot(footer_with_links)

  full_footer_with_links <- footer(
    TRUE,
    c("Privacy Notice", "Cookies")
  )


  expect_snapshot(full_footer_with_links)

  full_footer_with_internal_external_links <- footer(
    TRUE,
    c(
      `Privacy Notice` = "privacy_notice_link",
      `GitHub repository` = "https://github.com/dfe-analytical-services/shinyGovstyle"
    )
  )

  expect_snapshot(full_footer_with_internal_external_links)

  full_footer_with_external_links <- footer(
    TRUE,
    c(
      `Privacy notice` = "https://github.com/dfe-analytical-services/shinyGovstyle",
      `GitHub repository` = "https://github.com/dfe-analytical-services/shinyGovstyle"
    )
  )

  expect_snapshot(full_footer_with_external_links)
})
