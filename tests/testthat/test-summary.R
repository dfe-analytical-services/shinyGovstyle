test_that("summary list works", {
  headers <- c(
    "Name",
    "Date of birth",
    "Contact information",
    "Contact details"
  )
  info <- c(
    "Sarah Philips",
    "5 January 1978",
    "72 Guild Street <br> London <br> SE23 6FH",
    "07700 900457 <br> sarah.phillips@example.com"
  )

  summary_check <- gov_summary("sumID", headers, info)

  expect_length(find_tags(summary_check, "govuk-summary-list__row"), 4L)
  query <- htmltools::tagQuery(summary_check)
  expect_length(query$find(".govuk-summary-list__actions")$selectedTags(), 0)
  expect_length(query$find("button")$selectedTags(), 0)

  summary_check <- gov_summary("sumID", headers, info, border = FALSE)

  expect_length(
    find_tags(summary_check, "govuk-summary-list--no-border"),
    1L
  )
})

test_that("info accepts a list of mixed string and tag values", {
  headers <- c("Name", "Address")
  info <- list(
    "Sarah Philips",
    shiny::tagList(
      "72 Guild Street",
      shiny::tags$br(),
      "London",
      shiny::tags$br(),
      "SE23 6FH"
    )
  )

  out <- gov_summary("sumID", headers, info)
  html <- as.character(out)

  expect_match(html, "Sarah Philips", fixed = TRUE)
  expect_match(html, "72 Guild Street", fixed = TRUE)
  expect_match(html, "<br/>", fixed = TRUE)
  expect_match(html, "SE23 6FH", fixed = TRUE)
})

test_that("info accepts a list containing a single shiny.tag value", {
  headers <- "Reference"
  info <- list(shiny::tags$strong("ABC-123"))

  out <- gov_summary("sumID", headers, info)
  expect_match(as.character(out), "<strong>ABC-123</strong>", fixed = TRUE)
})

test_that("gov_summary attaches the GOV.UK stylesheet", {
  summary_check <- gov_summary("sumID", c("Name"), c("Sarah Philips"))
  expect_true("stylecss" %in% dependency_names(summary_check))
})

test_that("gov_summary attaches the summary-overrides stylesheet", {
  out <- gov_summary("sumID", c("Name"), c("Sarah Philips"))
  deps <- htmltools::findDependencies(out)
  summary_dep <- Filter(function(d) identical(d$name, "summary"), deps)
  expect_length(summary_dep, 1)
  expect_identical(summary_dep[[1]]$stylesheet, "summary-overrides.css")
})

test_that("gov_summary wraps the list in its layout container", {
  out <- gov_summary("sumID", c("Name"), c("Sarah Philips"))
  expect_identical(
    htmltools::tagGetAttribute(out, "class"),
    "shinygovstyle-summary"
  )
  summary_dl <- find_tag_required(out, "govuk-summary-list")
  expect_identical(summary_dl$name, "dl")
  expect_identical(htmltools::tagGetAttribute(summary_dl, "id"), "sumID")
})

## ---- rows API ---------------------------------------------------------------

test_that("rows API: no_border = TRUE removes the row's border", {
  out <- gov_summary(
    "sumID",
    rows = list(
      list(key = "Name", value = "Sarah", no_border = TRUE),
      list(key = "Age", value = "38")
    )
  )
  expect_length(find_tags(out, "govuk-summary-list__row--no-border"), 1)
})

test_that("rows API: a tag passed as key is rendered as-is", {
  out <- gov_summary(
    "sumID",
    rows = list(list(
      key = shiny::tags$span(class = "custom-key", "My key"),
      value = "val"
    ))
  )
  key_cell <- find_tag_required(out, "govuk-summary-list__key")
  expect_identical(tag_text(key_cell, "custom-key"), "My key")
})

## ---- gov_summary_card -------------------------------------------------------

summary_card <- function(...) {
  gov_summary_card(
    inputId = "cardID",
    title = "Lead tenant",
    rows = list(list(key = "Age", value = "38")),
    ...
  )
}

test_that("gov_summary_card wraps the list in the card structure", {
  out <- summary_card()
  expect_identical(
    htmltools::tagGetAttribute(out, "class"),
    "govuk-summary-card shinygovstyle-summary"
  )
  # The card is the layout container, so its list isn't wrapped in another
  expect_length(find_tags(out, "shinygovstyle-summary"), 1)
  content <- find_tag_required(out, "govuk-summary-card__content")
  expect_has_tag(content, "govuk-summary-list")
  expect_true("summary" %in% dependency_names(content))
})

test_that("gov_summary_card title defaults to an h2", {
  title <- find_tag_required(summary_card(), "govuk-summary-card__title")
  expect_identical(title$name, "h2")
  expect_identical(tag_text(title, "govuk-summary-card__title"), "Lead tenant")
})

test_that("gov_summary_card heading_level sets the title's tag name", {
  out <- summary_card(heading_level = 3L)
  expect_identical(
    find_tag_required(out, "govuk-summary-card__title")$name,
    "h3"
  )
})

test_that("gov_summary_card errors on an invalid heading_level", {
  expect_error(summary_card(heading_level = 7L), "heading_level")
})

test_that("gov_summary_card errors on a missing or non-string title", {
  expect_error(
    gov_summary_card("cardID", title = "", rows = list()),
    "`title` must be a single, non-empty string"
  )
  expect_error(
    gov_summary_card("cardID", title = c("A", "B"), rows = list()),
    "`title`"
  )
})
