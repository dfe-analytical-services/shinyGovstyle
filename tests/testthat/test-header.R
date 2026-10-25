test_that("service_name renders with correct class", {
  h <- header(org_name = "Test", service_name = "My Service")
  html <- as.character(h)
  expect_true(grepl("shinygovstyle-header__service-name", html))
  expect_true(grepl("My Service", html))
})


test_that("omitting service_name omits the service title", {
  h <- header(org_name = "Test")
  html <- as.character(h)
  expect_false(grepl("shinygovstyle-header__service-name", html))
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


test_that("a logo beside the organisation name is decorative by default", {
  h <- expect_no_warning(header(org_name = "Test", logo = "test.png"))
  image <- find_tag_required(h, "shinygovstyle-header__image")
  expect_identical(image$attribs$alt, "")

  h <- expect_no_warning(
    header(org_name = "Test", logo = "test.png", logo_alt_text = NULL)
  )
  image <- find_tag_required(h, "shinygovstyle-header__image")
  expect_identical(image$attribs$alt, "")
})


test_that("an image-only identity needs alternative text by default", {
  expect_error(
    header(org_name = NULL, logo = "test.png"),
    "name the homepage link"
  )
})


test_that("crown shortcut errors with migration guidance", {
  expect_error(
    header(org_name = "Test", logo = "crown"),
    "use `logo = NULL`.*own logo path"
  )
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

test_that("Generic header has one landmark and one linked identity", {
  h <- header("Organisation", "Service", attributes = list(id = "site-header"))
  expect_identical(h$name, "header")
  expect_identical(h$attribs$role, "banner")
  expect_has_tag(h, "govuk-generic-header")
  expect_has_tag(h, "govuk-generic-header__container")
  expect_has_tag(h, "govuk-generic-header__logo")
  expect_length(find_tags_by_name(h, "header"), 1L)
  expect_length(find_tags_by_name(h, "a"), 1L)
  expect_no_tag(h, "govuk-header")
  link <- find_tag_required(h, "govuk-generic-header__homepage-link")
  expect_identical(link$attribs$href, "/")
  expect_identical(
    tag_text(link, "shinygovstyle-header__organisation"),
    "Organisation"
  )
  expect_no_tag(link, "shinygovstyle-header__service-name")
  expect_identical(tag_text(h, "shinygovstyle-header__service-name"), "Service")
  expect_length(find_tags_by_name(h, "img"), 0L)
  expect_identical(h$attribs$id, "site-header")
})

test_that("the organisation identity is never duplicated", {
  h <- header("Organisation", "Service", logo = "logo.png", logo_alt_text = "")
  expect_length(find_tags(h, "shinygovstyle-header__organisation"), 1L)
  expect_length(find_tags_by_name(h, "img"), 1L)
  expect_false(grepl("mirror", as.character(h), fixed = TRUE))
})

test_that("homepage and custom attributes are configurable and escaped", {
  h <- header(
    '<Organisation> & "name"',
    '<Service> & "name"',
    homepage_url = '/my-app/?a=1&b="two"',
    classes = "my-header brand-header",
    attributes = list(id = "site-header", `data-brand` = '<brand> & "name"')
  )
  expect_has_tag(h, "my-header")
  expect_has_tag(h, "brand-header")
  expect_identical(h$attribs$`data-brand`, '<brand> & "name"')
  html <- as.character(h)
  expect_match(html, "&lt;Organisation&gt; &amp;", fixed = TRUE)
  expect_match(html, "&lt;Service&gt; &amp;", fixed = TRUE)
  expect_match(html, 'href="/my-app/?a=1&amp;b=&quot;two&quot;"', fixed = TRUE)
  expect_match(
    html,
    'data-brand="&lt;brand&gt; &amp; &quot;name&quot;"',
    fixed = TRUE
  )
})

test_that("image-only and text-only identities name the link", {
  image <- header(
    NULL,
    logo = "logo.png",
    logo_alt_text = "Example organisation"
  )
  expect_no_tag(image, "shinygovstyle-header__organisation")
  expect_identical(
    find_tag_required(image, "shinygovstyle-header__image")$attribs$alt,
    "Example organisation"
  )
  text <- header("Example organisation", logo = NULL)
  expect_identical(
    tag_text(text, "shinygovstyle-header__organisation"),
    "Example organisation"
  )
  expect_error(header(NULL, logo = NULL), "name the homepage link")
  expect_error(
    header("", logo = "logo.png", logo_alt_text = ""),
    "name the homepage link"
  )
  expect_error(
    header(" ", logo = "logo.png", logo_alt_text = " "),
    "name the homepage link"
  )
})

test_that("image dimensions belong to each image, with no global inline CSS", {
  h1 <- header("One", logo = "one.png", logo_width = 100, logo_height = 50)
  h2 <- header(
    "Two",
    logo = "two.png",
    logo_width = "5rem",
    logo_height = "2rem"
  )
  expect_match(
    find_tag_required(h1, "shinygovstyle-header__image")$attribs$style,
    "width:100px;height:50px;",
    fixed = TRUE
  )
  expect_match(
    find_tag_required(h2, "shinygovstyle-header__image")$attribs$style,
    "width:5rem;height:2rem;",
    fixed = TRUE
  )
  expect_length(find_tags_by_name(h1, "style"), 0L)
  expect_length(find_tags_by_name(h2, "style"), 0L)
})

test_that("header widths inherit from gov_page unless explicitly supplied", {
  for (page_width in c("standard", "three-quarters", "full", "1400px")) {
    page <- gov_page(header("Organisation", "Service"), width = page_width)
    container <- find_tag_required(page, "govuk-generic-header__container")
    expect_null(container$attribs$style)
    expect_false(grepl(
      "govuk-width-container--",
      container$attribs$class,
      fixed = TRUE
    ))
    explicit <- gov_page(
      header("Organisation", width = "standard"),
      width = page_width
    )
    expect_has_tag(explicit, "govuk-width-container--standard")
  }
  expect_has_tag(header(width = "full"), "govuk-width-container--full")
  expect_error(header(width = "invalid"), "must be")
})

test_that("header class attributes have no stray whitespace", {
  tidy <- "^\\S+( \\S+)*$"
  pages <- list(
    header("Organisation"),
    header("Organisation", "Service"),
    header("Organisation", classes = "my-header", width = "full"),
    gov_page(header("Organisation", "Service"), width = "full")
  )
  for (page in pages) {
    outer <- find_tag_required(page, "govuk-generic-header")
    expect_match(outer$attribs$class, tidy)
    container <- find_tag_required(page, "govuk-generic-header__container")
    expect_match(container$attribs$class, tidy)
  }
})

test_that("customisation hooks reject ambiguous attributes", {
  for (url in list(NULL, "", " ", NA_character_, c("/", "/app/"), 42)) {
    expect_error(header(homepage_url = url), "non-empty URL string")
  }
  expect_error(header(classes = c("one", "two")), "single string")
  expect_error(header(attributes = "id"), "named list")
  expect_error(header(attributes = list("id")), "named list")
  expect_error(header(attributes = list(id = "one", id = "two")), "named list")
  expect_error(header(attributes = list(class = "custom")), "Use `classes`")
  expect_error(
    header(attributes = list(role = "navigation")),
    "banner role is fixed"
  )
})

# GOV.UK branding ------------------------------------------------------------

test_that("branding = 'govuk' renders the GOV.UK header and logotype", {
  h <- header(service_name = "My service", branding = "govuk")

  expect_identical(htmltools::tagGetAttribute(h, "role"), "banner")
  expect_has_tag(h, "govuk-header")
  expect_has_tag(h, "govuk-header__container")
  expect_no_tag(h, "govuk-generic-header")

  link <- find_tag_required(h, "govuk-header__homepage-link")
  expect_identical(
    htmltools::tagGetAttribute(link, "href"),
    "https://www.gov.uk/"
  )

  logo <- find_tag_required(h, "govuk-header__logotype")
  expect_identical(logo$name, "svg")
  expect_identical(htmltools::tagGetAttribute(logo, "role"), "img")
  expect_identical(htmltools::tagGetAttribute(logo, "aria-label"), "GOV.UK")
  expect_identical(htmltools::tagGetAttribute(logo, "viewBox"), "0 0 324 60")
  expect_has_tag(logo, "govuk-logo-dot")

  # The service title is kept as the shinyGovstyle extension
  expect_identical(
    tag_text(h, "shinygovstyle-header__service-name"),
    "My service"
  )
  expect_no_tag(h, "shinygovstyle-header__organisation")
})

test_that("GOV.UK header keeps a custom homepage_url", {
  h <- header(branding = "govuk", homepage_url = "/my-service/")
  link <- find_tag_required(h, "govuk-header__homepage-link")
  expect_identical(htmltools::tagGetAttribute(link, "href"), "/my-service/")
})

test_that("GOV.UK header warns that org_name and logo are ignored", {
  expect_warning(
    header(org_name = "Department", branding = "govuk"),
    "`org_name` and `logo` are ignored"
  )
  expect_warning(
    header(logo = "shinyGovstyle/images/moj_logo.png", branding = "govuk"),
    "ignored"
  )
  expect_no_warning(header(branding = "govuk"))
})

test_that("branding must be generic or govuk", {
  expect_error(header("Org", branding = "crown"), "should be one of")
})

test_that("crown shortcut points to branding = 'govuk'", {
  expect_error(
    header(org_name = "Test", logo = "crown"),
    'branding = "govuk"'
  )
})
