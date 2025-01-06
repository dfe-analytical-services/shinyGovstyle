library(shinytest2)

test_that("App loads and title of app appears as expected", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()

  appdir <- system.file(package = "shinyGovstyle", "example_app")
  expect_no_error(test_app(appdir))
})

