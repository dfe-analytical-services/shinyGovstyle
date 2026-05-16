test_that("banner check", {
  banner_check <- banner("bannerId", "alpha", "Banner test")

  expect_identical(
    tag_text(banner_check, "govuk-phase-banner__content__tag"),
    "alpha"
  )

  expect_identical(
    tag_text(banner_check, "govuk-phase-banner__text"),
    shiny::HTML("Banner test")
  )
})
