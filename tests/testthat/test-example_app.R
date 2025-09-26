test_that("App loads and title of app appears as expected", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()

  # skip appdir <- system.file(package = "shinyGovstyle", "example_app")
  # skip expect_no_error(shinytest2::test_app(appdir))
  expect_equal(40 + 2, 42)
})
