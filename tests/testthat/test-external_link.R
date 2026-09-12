# external_link() inlines a hidden span into the rendered HTML via paste0(),
# so the link text and hidden warning live in a single htmltools::HTML() child
# rather than as separate tags. Assertions therefore work against the rendered
# child string with expect_identical(), which is exact-match without being a
# snapshot.

link_text <- function(link) as.character(tag_text(link, "govuk-link"))

test_link <- external_link("https://shiny.posit.co/", "R Shiny")

test_that("Returns shiny.tag object", {
  expect_s3_class(test_link, "shiny.tag")
})

test_that("Default link has the visible 'opens in new tab' suffix", {
  expect_identical(link_text(test_link), "R Shiny (opens in new tab)")
})

test_that("attributes are attached properly", {
  expect_identical(
    htmltools::tagGetAttribute(test_link, "rel"),
    "noopener noreferrer"
  )
  expect_identical(htmltools::tagGetAttribute(test_link, "target"), "_blank")
  expect_identical(
    htmltools::tagGetAttribute(test_link, "href"),
    "https://shiny.posit.co/"
  )
  expect_identical(htmltools::tagGetAttribute(test_link, "class"), "govuk-link")
})

test_that("Rejects dodgy link text", {
  expect_error(external_link("https://shiny.posit.co/", "Click here"))
  expect_error(external_link("https://shiny.posit.co/", "here"))
  expect_error(external_link("https://shiny.posit.co/", "PDF"))
  expect_error(external_link("https://shiny.posit.co/", "Full stop."))
  expect_error(
    external_link("https://shiny.posit.co/", "https://shiny.posit.co/")
  )
  expect_error(
    external_link("https://shiny.posit.co/", "http://shiny.posit.co/")
  )
  expect_error(external_link("https://shiny.posit.co/", "www.google.com"))
})

test_that("Rejects invalid values for add_warning", {
  expect_error(
    external_link(
      "https://shiny.posit.co/",
      "R Shiny",
      add_warning = "Funky non-boolean"
    ),
    'add_warning must be TRUE, FALSE, or "icon"',
    fixed = TRUE
  )
})

test_that("add_warning = TRUE/FALSE (default and opposite) add no svg", {
  expect_false(grepl("<svg", link_text(test_link), fixed = TRUE))

  hidden_link <-
    external_link("https://shiny.posit.co/", "R Shiny", add_warning = FALSE)
  expect_false(grepl("<svg", link_text(hidden_link), fixed = TRUE))
})

test_that("add_warning = 'icon' adds a decorative svg after the link text", {
  icon_link <- external_link(
    "https://shiny.posit.co/",
    "R Shiny",
    add_warning = "icon"
  )
  rendered <- link_text(icon_link)

  expect_true(grepl("<svg", rendered, fixed = TRUE))
  expect_true(grepl('aria-hidden="true"', rendered, fixed = TRUE))
  expect_true(grepl('focusable="false"', rendered, fixed = TRUE))
  # The sr-only warning text (same as add_warning = FALSE) still comes
  # before the decorative icon, so screen readers still get the warning
  expect_true(
    grepl(
      "R Shiny<span class=\"sr-only\"> (opens in new tab)</span><svg",
      rendered,
      fixed = TRUE
    )
  )
})

test_that("add_warning = FALSE adds a hidden span instead of visible suffix", {
  hidden_link <-
    external_link("https://shiny.posit.co/", "R Shiny", add_warning = FALSE)

  expect_identical(
    link_text(hidden_link),
    "R Shiny<span class=\"sr-only\"> (opens in new tab)</span>"
  )
})

test_that("Surrounding whitespace shrubbery is trimmed", {
  trimmed_visible <- function(text) {
    link_text(external_link("https://shiny.posit.co/", text))
  }
  trimmed_hidden <- function(text) {
    link_text(
      external_link("https://shiny.posit.co/", text, add_warning = FALSE)
    )
  }
  hidden_suffix <- "<span class=\"sr-only\"> (opens in new tab)</span>"

  expect_identical(
    trimmed_visible("   R Shiny"),
    "R Shiny (opens in new tab)"
  )
  expect_identical(
    trimmed_visible("R Shiny      "),
    "R Shiny (opens in new tab)"
  )
  expect_identical(
    trimmed_visible("   R Shiny   "),
    "R Shiny (opens in new tab)"
  )
  expect_identical(
    trimmed_hidden("   R Shiny"),
    paste0("R Shiny", hidden_suffix)
  )
  expect_identical(
    trimmed_hidden("R Shiny   "),
    paste0("R Shiny", hidden_suffix)
  )
  expect_identical(
    trimmed_hidden("   R Shiny   "),
    paste0("R Shiny", hidden_suffix)
  )
})

test_that("Warning appears for short link text and not for long text", {
  expect_warning(
    external_link("https://shiny.posit.co/", "R"),
    paste0(
      "the link_text: R, is shorter than 7 characters, this is",
      " unlikely to be descriptive for users, consider having more detailed",
      " link text"
    )
  )

  expect_no_warning(external_link("https://shiny.posit.co/", "R Shiny"))
})

test_that("Footer flag works as expected", {
  expect_identical(
    htmltools::tagGetAttribute(
      external_link("www.test-link.co.uk", "test link", footer = FALSE),
      "class"
    ),
    "govuk-link"
  )

  expect_identical(
    htmltools::tagGetAttribute(
      external_link("www.test-link.co.uk", "test link", footer = TRUE),
      "class"
    ),
    "govuk-link govuk-footer__link"
  )

  expect_error(
    external_link("www.test-link.co.uk", "test link", footer = "TRUE"),
    paste0(
      "The footer parameter should logical TRUE/FALSE. Received:\n",
      "character: TRUE"
    )
  )

  expect_error(
    external_link("www.test-link.co.uk", "test link", footer = 0),
    paste0(
      "The footer parameter should logical TRUE/FALSE. Received:\n",
      "numeric: 0"
    )
  )
})

test_that("external_link() also attaches the base shinyGovstyle dependencies", {
  # So update_page_title() works in apps that use external_link() without
  # any other shinyGovstyle component.
  dep_names <- vapply(
    htmltools::findDependencies(test_link),
    function(x) x$name,
    character(1)
  )
  expect_true("stylecss" %in% dep_names)
  expect_true("update_page_title" %in% dep_names)
  expect_true("sr-only" %in% dep_names)
})
