test_that("secondary_text is deprecated", {
  rlang::local_options(lifecycle_verbosity = "error")
  expect_error(header(secondary_link = "test text"), class = "defunctError")
})


test_that("function still runs if using deprecated argument", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_silent(
    header(secondary_link = "test text")
  )
})


test_that("heading_text returns correct heading level", {
  # Test default level (should be h1)
  h1 <- heading_text("Test", size = "xl")
  expect_true(grepl("<h1", as.character(h1)))

  # Test level 2
  h2 <- heading_text("Test", size = "l", level = 2)
  expect_true(grepl("<h2", as.character(h2)))

  # Test level 3
  h3 <- heading_text("Test", size = "m", level = 3)
  expect_true(grepl("<h3", as.character(h3)))

  # Test invalid level throws error
  expect_error(
    heading_text("Test", level = 0),
    "level must be an integer between 1 and 6"
  )
  expect_error(
    heading_text("Test", level = 7),
    "level must be an integer between 1 and 6"
  )
})
