test_that("cookie banner works", {
  cookie_banner_check <- shinyGovstyle::cookieBanner("The best thing")

  button_group <- find_tag(cookie_banner_check, "govuk-button-group")
  expect_equal(length(button_group$children), 3)

  expect_identical(
    tag_text(cookie_banner_check, "govuk-cookie-banner__heading"),
    "Cookies on The best thing"
  )

  # Body copy is rendered via gov_text(), so it carries the govuk-body class.
  bodies <- find_tags(cookie_banner_check, "govuk-body")
  expect_gte(length(bodies), 2)
  expect_match(
    paste(
      vapply(bodies, function(b) as.character(b), character(1L)),
      collapse = " "
    ),
    "We use some essential cookies to make this service work."
  )

  hidden_msgs <- Filter(
    function(t) {
      cls <- htmltools::tagGetAttribute(t, "class")
      !is.null(cls) && "shinyjs-hide" %in% strsplit(cls, "\\s+")[[1L]]
    },
    cookie_banner_check$children
  )
  expect_length(hidden_msgs, 2L)
  ids <- vapply(hidden_msgs, htmltools::tagGetAttribute, character(1L), "id")
  expect_setequal(ids, c("cookieAcceptDiv", "cookieRejectDiv"))
})

test_that("cookie banner link markup is as expected", {
  local_edition(3)

  expect_snapshot(cookieBanner("The best thing"))
})


test_that("width defaults to standard, no three-quarters/full class", {
  cookie_banner_check <- cookieBanner("The best thing")
  container <- find_tag_required(cookie_banner_check, "govuk-width-container")
  expect_null(htmltools::tagGetAttribute(container, "style"))
  expect_no_tag(cookie_banner_check, "govuk-width-container--standard")
  expect_no_tag(cookie_banner_check, "govuk-width-container--three-quarters")
  expect_no_tag(cookie_banner_check, "govuk-width-container--full")
})

test_that("width = 'standard' explicitly still renders the standard class", {
  cookie_banner_check <- cookieBanner("The best thing", width = "standard")
  expect_has_tag(cookie_banner_check, "govuk-width-container--standard")
})


test_that("width = 'full' adds the full modifier class to every message", {
  cookie_banner_check <- cookieBanner("The best thing", width = "full")
  full_containers <- find_tags(
    cookie_banner_check,
    "govuk-width-container--full"
  )
  expect_length(full_containers, 3L)
})


test_that("a custom width sets an inline max-width style", {
  cookie_banner_check <- cookieBanner("The best thing", width = "1400px")
  container <- find_tag_required(cookie_banner_check, "govuk-width-container")
  expect_identical(
    htmltools::tagGetAttribute(container, "style"),
    "max-width: 1400px;"
  )
})

test_that("the banner region has separate data-nosnippet and role attributes", {
  banner <- cookieBanner("The best thing")
  expect_true("data-nosnippet" %in% names(banner$attribs))
  expect_identical(htmltools::tagGetAttribute(banner, "role"), "region")
  expect_false("data-nosnippet role" %in% names(banner$attribs))
  expect_match(
    as.character(banner),
    'class="govuk-cookie-banner" data-nosnippet role="region"',
    fixed = TRUE
  )
})

test_that("confirmation messages are alerts that can take focus", {
  banner <- cookieBanner("The best thing")
  for (id in c("cookieAcceptDiv", "cookieRejectDiv")) {
    message <- htmltools::tagQuery(banner)$find(paste0("#", id))$selectedTags()
    expect_length(message, 1L)
    expect_identical(htmltools::tagGetAttribute(message[[1]], "role"), "alert")
    expect_identical(htmltools::tagGetAttribute(message[[1]], "tabindex"), "-1")
  }

  # The initial message is not an alert: it is there on page load
  main <- htmltools::tagQuery(banner)$find("#cookieMain")$selectedTags()[[1]]
  expect_null(htmltools::tagGetAttribute(main, "role"))
})

test_that("the cookie banner ships the focus-moving script", {
  deps <- htmltools::findDependencies(cookieBanner("The best thing"))
  scripts <- unlist(lapply(deps, function(d) d$script))
  expect_true(all(c("focus_management.js", "cookie_banner.js") %in% scripts))

  js_path <- system.file(
    "www",
    "js",
    "cookie_banner.js",
    package = "shinyGovstyle"
  )
  js <- paste(readLines(js_path, warn = FALSE), collapse = "\n")
  for (id in c("cookieAccept", "cookieReject", "hideAccept", "hideReject")) {
    expect_match(js, paste0("#", id), fixed = TRUE)
  }
  for (id in c("cookieAcceptDiv", "cookieRejectDiv", "cookieDiv")) {
    expect_match(js, paste0('"', id, '"'), fixed = TRUE)
  }
})
