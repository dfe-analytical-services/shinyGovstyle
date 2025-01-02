app <- AppDriver$new(name = "example_app")

test_that("App loads and title of app appears as expected", {
  expect_equal(
    app$get_text("title"),
    "ShinyGovstyle"
  )
})