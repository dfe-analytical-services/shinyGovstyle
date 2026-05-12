test_that("service_name renders with correct class", {
  h <- header(org_name = "Test", service_name = "My Service")
  html <- as.character(h)
  expect_true(grepl("govuk-header__service-name", html))
  expect_true(grepl("My Service", html))
})


test_that("omitting service_name omits header__content div", {
  h <- header(org_name = "Test")
  html <- as.character(h)
  expect_false(grepl("govuk-header__content", html))
})


test_that("main_text is deprecated in favour of org_name", {
  rlang::local_options(lifecycle_verbosity = "error")
  expect_error(header(main_text = "Test"), class = "defunctError")
})


test_that("secondary_text is deprecated in favour of service_name", {
  rlang::local_options(lifecycle_verbosity = "error")
  expect_error(header(secondary_text = "My Service"), class = "defunctError")
})


test_that("secondary_link is deprecated", {
  rlang::local_options(lifecycle_verbosity = "error")
  expect_error(header(secondary_link = "test text"), class = "defunctError")
})


test_that("main_link is deprecated", {
  rlang::local_options(lifecycle_verbosity = "error")
  expect_error(header(main_link = "http://example.com"), class = "defunctError")
})


test_that("main_alt_text is deprecated", {
  rlang::local_options(lifecycle_verbosity = "error")
  expect_error(header(main_alt_text = "Alt text"), class = "defunctError")
})


test_that("function still runs if using deprecated argument", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_silent(
    header(secondary_link = "test text")
  )
})


test_that("warning when logo used without logo_alt_text", {
  expect_warning(
    header(org_name = "Test", logo = "test.png", logo_alt_text = NULL),
    "Please use logo_alt_text"
  )
})


test_that("crown logo renders SVG and no img", {
  h <- header(org_name = "Test", logo = "crown")
  html <- as.character(h)
  expect_true(grepl("<svg", html))
  expect_false(grepl("<img", html))
})


test_that("custom logo renders img with correct src and alt", {
  h <- header(
    org_name = "Test",
    logo = "path/to/logo.png",
    logo_alt_text = "My Logo"
  )
  html <- as.character(h)
  expect_true(grepl("<img", html))
  expect_true(grepl("path/to/logo.png", html))
  expect_true(grepl("My Logo", html))
})


test_that("NULL logo renders no img or svg", {
  h <- header(org_name = "Test", logo = NULL)
  html <- as.character(h)
  expect_false(grepl("<img", html))
  expect_false(grepl("<svg", html))
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
