# gov_page() carries lang/bs_theme as object attributes rather than in the
# rendered tag tree (that's how bslib::page_fluid() itself works: Shiny's
# page-rendering machinery reads attr(x, "lang") when building the final
# <html> document), so these tests check attr()/htmltools::renderTags()
# rather than searching the rendered HTML string for "<html lang=...>".

find_width_marker <- function(page) {
  divs <- find_tags_by_name(page, "div")
  has_marker <- function(d) {
    !is.null(htmltools::tagGetAttribute(d, "data-govuk-page-width"))
  }
  Filter(has_marker, divs)[[1]]
}

test_that("lang defaults to 'en'", {
  page <- gov_page(shiny::tags$p("hi"))
  expect_identical(attr(page, "lang"), "en")
})

test_that("a custom lang is passed through", {
  page <- gov_page(lang = "cy", shiny::tags$p("hi"))
  expect_identical(attr(page, "lang"), "cy")
})

test_that("description renders a meta tag when supplied", {
  page <- gov_page(description = "A test page", shiny::tags$p("hi"))
  head_html <- htmltools::renderTags(page)$head
  expect_match(
    as.character(head_html),
    '<meta name="description" content="A test page"/>',
    fixed = TRUE
  )
})

test_that("description is omitted when not supplied", {
  page <- gov_page(shiny::tags$p("hi"))
  head_html <- as.character(htmltools::renderTags(page)$head)
  expect_false(grepl("description", head_html, fixed = TRUE))
})

test_that("width sets the data-govuk-page-width marker for each tier", {
  expect_identical(
    htmltools::tagGetAttribute(
      find_width_marker(gov_page(width = "standard", shiny::tags$p("hi"))),
      "data-govuk-page-width"
    ),
    "standard"
  )
  expect_identical(
    htmltools::tagGetAttribute(
      find_width_marker(
        gov_page(width = "three-quarters", shiny::tags$p("hi"))
      ),
      "data-govuk-page-width"
    ),
    "three-quarters"
  )
  expect_identical(
    htmltools::tagGetAttribute(
      find_width_marker(gov_page(width = "full", shiny::tags$p("hi"))),
      "data-govuk-page-width"
    ),
    "full"
  )
})

test_that("width defaults to 'full' when not supplied", {
  expect_identical(
    htmltools::tagGetAttribute(
      find_width_marker(gov_page(shiny::tags$p("hi"))),
      "data-govuk-page-width"
    ),
    "full"
  )
})

test_that("a custom width sets the custom marker and CSS variable", {
  marker <- find_width_marker(
    gov_page(width = "1400px", shiny::tags$p("hi"))
  )
  expect_identical(
    htmltools::tagGetAttribute(marker, "data-govuk-page-width"),
    "custom"
  )
  expect_identical(
    htmltools::tagGetAttribute(marker, "style"),
    "--govuk-page-max-width: 1400px;"
  )
})

test_that("a child left at its own default is free to inherit", {
  # No explicit class on the child, so CSS's
  # [data-govuk-page-width="three-quarters"]
  # .govuk-width-container:not(...) rule is the only thing giving it a
  # width: that's the ambient mechanism.
  page <- gov_page(width = "three-quarters", footer())
  expect_no_tag(page, "govuk-width-container--standard")
  expect_no_tag(page, "govuk-width-container--three-quarters")
  expect_no_tag(page, "govuk-width-container--full")
})

test_that("a child component can opt out of the ambient width", {
  page <- gov_page(width = "three-quarters", footer(width = "standard"))
  marker <- find_width_marker(page)
  expect_identical(
    htmltools::tagGetAttribute(marker, "data-govuk-page-width"),
    "three-quarters"
  )
  expect_has_tag(page, "govuk-width-container--standard")
})

test_that("an invalid width errors with a clear message", {
  expect_error(gov_page(width = "massive"), "must be")
})

test_that("title is passed through to page_fluid", {
  page <- gov_page(title = "My app", shiny::tags$p("hi"))
  head_html <- as.character(htmltools::renderTags(page)$head)
  expect_match(head_html, "<title>My app</title>", fixed = TRUE)
})

test_that("gov_page carries the package's base dependencies", {
  page <- gov_page(shiny::tags$p("hi"))
  dep_names <- vapply(
    htmltools::findDependencies(page),
    function(x) x$name,
    character(1)
  )
  expect_true("stylecss" %in% dep_names)
  expect_true("width-overrides" %in% dep_names)
  expect_true("update_page_title" %in% dep_names)
})
