test_that("error_summary builds the documented structure", {
  summary_tag <- error_summary(
    "error1",
    "Error Title",
    c("error entry 1", "error entry 2")
  )

  expect_identical(htmltools::tagGetAttribute(summary_tag, "id"), "error1")
  expect_identical(
    htmltools::tagGetAttribute(summary_tag, "class"),
    "govuk-error-summary"
  )

  expect_identical(
    as.character(tag_text(summary_tag, "govuk-error-summary__title")),
    "Error Title"
  )

  body <- find_tag_required(summary_tag, "govuk-error-summary__body")
  expect_identical(htmltools::tagGetAttribute(body, "id"), "error1list")

  list_tag <- find_tag_required(summary_tag, "govuk-error-summary__list")
  expect_identical(
    htmltools::tagGetAttribute(list_tag, "class"),
    "govuk-list govuk-error-summary__list"
  )

  expect_identical(
    unname(tag_text_by_name(list_tag, "li")),
    c("error entry 1", "error entry 2")
  )
})

# The <li> tags and the <a> tags inside them, found by selector rather than by
# position so a change to the wrapper markup does not break the lookups.
summary_items <- function(x) {
  htmltools::tagQuery(x)$find(".govuk-error-summary__list > li")$selectedTags()
}
summary_links <- function(x) {
  htmltools::tagQuery(x)$find(
    ".govuk-error-summary__list > li > a"
  )$selectedTags()
}
link_hrefs <- function(x) {
  vapply(
    summary_links(x),
    htmltools::tagGetAttribute,
    character(1L),
    attr = "href",
    USE.NAMES = FALSE
  )
}

test_that("error_summary wraps the title and body in role = alert", {
  summary_tag <- error_summary("error1", "Title", "Message")

  # tagQuery() has no attribute selectors, so filter the divs on role.
  alert <- htmltools::tagQuery(summary_tag)$find("div")$filter(function(x, i) {
    identical(x$attribs$role, "alert")
  })
  expect_length(alert$selectedTags(), 1L)
  expect_length(
    alert$children(".govuk-error-summary__title")$selectedTags(),
    1L
  )
  body <- alert$children(".govuk-error-summary__body")$selectedTags()
  expect_length(body, 1L)
  expect_identical(htmltools::tagGetAttribute(body[[1L]], "id"), "error1list")
})

test_that("error_summary keeps unnamed messages as plain text", {
  summary_tag <- error_summary("error1", "Title", c("one", "two"))

  expect_length(summary_items(summary_tag), 2L)
  expect_length(summary_links(summary_tag), 0L)
})

test_that("error_summary links named messages to their inputs", {
  summary_tag <- error_summary(
    "error1",
    "Title",
    c(name = "Enter your name", dob = "Enter your date of birth")
  )

  expect_identical(link_hrefs(summary_tag), c("#name", "#dob"))
  expect_identical(
    unname(tag_text_by_name(summary_tag, "a")),
    c("Enter your name", "Enter your date of birth")
  )
})

test_that("error_summary mixes linked and plain messages in order", {
  summary_tag <- error_summary(
    "error1",
    "Title",
    c(name = "Enter your name", "Check your answers", "Other")
  )

  items <- summary_items(summary_tag)
  expect_length(items, 3L)
  expect_identical(link_hrefs(summary_tag), "#name")
  # Only the first item holds a link; the empty-named ones are plain text.
  has_link <- vapply(
    items,
    function(li) length(htmltools::tagQuery(li)$find("a")$selectedTags()) > 0,
    logical(1L),
    USE.NAMES = FALSE
  )
  expect_identical(has_link, c(TRUE, FALSE, FALSE))
})

test_that("error_summary accepts a named list with tag messages", {
  summary_tag <- error_summary(
    "error1",
    "Title",
    list(name = shiny::tags$strong("Enter your name"), "Plain")
  )

  link <- summary_links(summary_tag)[[1L]]
  expect_identical(htmltools::tagGetAttribute(link, "href"), "#name")
  expect_length(htmltools::tagQuery(link)$find("strong")$selectedTags(), 1L)
})

test_that("error_summary escapes plain-string messages", {
  html <- as.character(
    error_summary("error1", "Title", c(name = "<b>bold</b> & more", "<i>x</i>"))
  )

  expect_match(html, "&lt;b&gt;bold&lt;/b&gt; &amp; more", fixed = TRUE)
  expect_match(html, "&lt;i&gt;x&lt;/i&gt;", fixed = TRUE)
  expect_no_match(html, "<b>bold</b>", fixed = TRUE)
})

test_that("error_summary attaches the link-focus script", {
  deps <- htmltools::findDependencies(error_summary("e", "T", "m"))
  dep_names <- vapply(deps, function(d) d$name, character(1L))
  expect_true("error_summary" %in% dep_names)
})

test_that("govuk_error_target_id maps each control type", {
  expect_identical(govuk_error_target_id("txt"), "txt")
  expect_identical(govuk_error_target_id("dob", "date"), "dob_day")
  expect_identical(govuk_error_target_id("rad", "radio"), "rad-1")
  expect_identical(
    govuk_error_target_id("cb", "checkbox", c("first", "second")),
    "first"
  )
  expect_null(govuk_error_target_id("cb", "checkbox", character(0)))
})

# The element a summary link for `id` points at, and the control its
# `data-govuk-error-target` names; error_summary.js follows the same steps.
# The component is wrapped in a div because tagQuery()$find() only searches
# descendants, and several components put `id` on their outermost tag.
error_link_target <- function(tag, id) {
  tag <- shiny::tags$div(tag)
  group <- htmltools::tagQuery(tag)$find(paste0("#", id))$selectedTags()
  expect_length(group, 1L)
  target_id <- htmltools::tagGetAttribute(
    group[[1L]],
    "data-govuk-error-target"
  )
  if (is.null(target_id)) {
    return(group[[1L]])
  }
  target <- htmltools::tagQuery(tag)$find(paste0("#", target_id))$selectedTags()
  expect_length(target, 1L)
  target[[1L]]
}

test_that("summary links reach the first control of each component", {
  date <- error_link_target(date_Input("dob", "Date of birth"), "dob")
  expect_identical(htmltools::tagGetAttribute(date, "id"), "dob_day")
  expect_identical(date$name, "input")

  radio <- error_link_target(
    radio_button_Input("rad", "Pick", choices = c("A", "B")),
    "rad"
  )
  expect_identical(htmltools::tagGetAttribute(radio, "value"), "A")
  expect_identical(htmltools::tagGetAttribute(radio, "type"), "radio")

  checkbox <- error_link_target(
    checkbox_Input("cb", c("One", "Two"), c("cb_one", "cb_two"), "Pick"),
    "cb"
  )
  expect_identical(htmltools::tagGetAttribute(checkbox, "id"), "cb_one")
  expect_identical(htmltools::tagGetAttribute(checkbox, "type"), "checkbox")

  text <- error_link_target(text_Input("txt", "Name"), "txt")
  expect_identical(text$name, "input")

  area <- error_link_target(text_area_Input("area", "Detail"), "area")
  expect_identical(area$name, "textarea")

  select <- error_link_target(
    select_Input("sel", "Pick", c("A", "B"), c("a", "b")),
    "sel"
  )
  expect_identical(select$name, "select")

  file <- error_link_target(file_Input("upload", "Upload"), "upload")
  expect_identical(htmltools::tagGetAttribute(file, "type"), "file")
})
