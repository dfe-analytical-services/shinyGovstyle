
test_that("warnings for deprecated arguments work", {

  expect_warning(
  header(main_text = "test text"),
  paste("main_text is no longer supported")
  )


  header(
      main_text = "test text",
      secondary_text = "test text2",
      main_link = "test_link.com",
      secondary_link = "test_link.com",
      main_alt_text = "some alt text",
      secondary_alt_text = "some other alt text"
  ) |>
    expect_warning("main_text is no longer supported") |>
    expect_warning("secondary_text is no longer supported") |>
    expect_warning("main_link is no longer supported") |>
    expect_warning("secondary_link is no longer supported") |>
    expect_warning("main_alt_text is no longer supported") |>
    expect_warning("secondary_alt_text is no longer supported")

}
)


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
