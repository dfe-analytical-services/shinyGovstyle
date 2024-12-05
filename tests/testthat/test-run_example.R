library(shinytest2)
test_that("App loads and title of app appears as expected", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()

  shiny_app <- run_example()
  app <- AppDriver$new(shiny_app, name = "showcase")

  expect_equal(
    app$get_text("title"),
    "ShinyGovstyle"
  )
})
