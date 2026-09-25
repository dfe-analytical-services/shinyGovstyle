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


test_that("header() with only current args produces no lifecycle warnings", {
  rlang::local_options(lifecycle_verbosity = "warning")
  expect_no_warning(header(org_name = "Test", logo = NULL))
  expect_no_warning(
    header(org_name = "Test", service_name = "Svc", logo = NULL)
  )
})


test_that("width defaults to standard, no three-quarters/full class", {
  h <- header(org_name = "Test")
  container <- find_tag_required(h, "govuk-width-container")
  expect_null(htmltools::tagGetAttribute(container, "style"))
  expect_no_tag(h, "govuk-width-container--standard")
  expect_no_tag(h, "govuk-width-container--three-quarters")
  expect_no_tag(h, "govuk-width-container--full")
})

test_that("width = 'standard' explicitly still renders the standard class", {
  # Distinguishing "left at default" from "explicitly standard" is what
  # lets an app inside gov_page(width = "three-quarters") opt one
  # component back down to standard width; see test-gov_page.R.
  h <- header(org_name = "Test", width = "standard")
  expect_has_tag(h, "govuk-width-container--standard")
})


test_that("width = 'three-quarters' adds the three-quarters modifier class", {
  h <- header(org_name = "Test", width = "three-quarters")
  expect_has_tag(h, "govuk-width-container--three-quarters")
})


test_that("a custom width sets an inline max-width style", {
  h <- header(org_name = "Test", width = "1400px")
  container <- find_tag_required(h, "govuk-width-container")
  expect_identical(
    htmltools::tagGetAttribute(container, "style"),
    "max-width: 1400px;"
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


test_that("no mirror logo is rendered when service_name is omitted", {
  h <- header(org_name = "Test")
  expect_no_tag(h, "govuk-header__logo--mirror")
})


test_that("mirror logo is rendered aria-hidden when service_name is set", {
  h <- header(org_name = "Test", service_name = "My Service")
  mirror <- expect_has_tag(h, "govuk-header__logo--mirror")
  expect_identical(htmltools::tagGetAttribute(mirror, "aria-hidden"), "true")
})


test_that("mirror logo repeats the same org_name and logo as the real one", {
  h <- header(
    org_name = "Test",
    service_name = "My Service",
    logo = "path/to/logo.png",
    logo_alt_text = "My Logo"
  )
  logos <- find_tags(h, "govuk-header__logo")
  expect_length(logos, 2L)
  expect_identical(
    as.character(logos[[1L]]$children),
    as.character(logos[[2L]]$children)
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


test_that("renamed header() arguments name their replacement", {
  expect_one_deprecation(
    header(main_text = "Org", logo = NULL),
    mentions = c("`main_text`", "`org_name`", "1.0.0")
  )
  expect_one_deprecation(
    header(secondary_text = "Service", logo = NULL),
    mentions = c("`secondary_text`", "`service_name`", "1.0.0")
  )
})

test_that("unused header() arguments say they have no effect", {
  for (arg in c(
    "main_link",
    "secondary_link",
    "main_alt_text",
    "secondary_alt_text"
  )) {
    args <- list(logo = NULL)
    args[[arg]] <- "value"
    expect_one_deprecation(
      do.call(header, args),
      mentions = c(paste0("`", arg, "`"), "no effect", "removed", "1.0.0")
    )
  }
})

test_that("deprecated header() arguments still map to their replacement", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_identical(
    as.character(header(main_text = "Org", secondary_text = "Svc")),
    as.character(header(org_name = "Org", service_name = "Svc"))
  )
})
