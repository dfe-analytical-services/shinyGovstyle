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

  summary_check <- gov_summary("sumID", headers, info, action = FALSE)

  expect_length(find_tags(summary_check, "govuk-summary-list__row"), 4L)

  summary_check <- gov_summary(
    "sumID",
    headers,
    info,
    action = TRUE,
    border = FALSE
  )

  # Action cell renders as a <button> styled with the govuk-link class.
  expect_identical(
    find_tag(summary_check, "govuk-link")$name,
    "button"
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

  out <- gov_summary("sumID", headers, info, action = FALSE)
  html <- as.character(out)

  expect_match(html, "Sarah Philips", fixed = TRUE)
  expect_match(html, "72 Guild Street", fixed = TRUE)
  expect_match(html, "<br/>", fixed = TRUE)
  expect_match(html, "SE23 6FH", fixed = TRUE)
})

test_that("info accepts a list containing a single shiny.tag value", {
  headers <- "Reference"
  info <- list(shiny::tags$strong("ABC-123"))

  out <- gov_summary("sumID", headers, info, action = FALSE)
  expect_match(as.character(out), "<strong>ABC-123</strong>", fixed = TRUE)
})

test_that("gov_summary attaches the GOV.UK stylesheet", {
  summary_check <- gov_summary("sumID", c("Name"), c("Sarah Philips"))
  expect_true("stylecss" %in% dependency_names(summary_check))
})

test_that("action buttons get one input ID per header", {
  headers <- c("Name", "Date of birth", "Contact details (email)")
  info <- c("Sarah Philips", "5 January 1978", "sarah@example.com")

  out <- gov_summary("sumID", headers, info, action = TRUE)
  buttons <- htmltools::tagQuery(out)$find("button.action-button")

  ids <- vapply(
    buttons$selectedTags(),
    function(tag) htmltools::tagGetAttribute(tag, "id"),
    character(1),
    USE.NAMES = FALSE
  )
  expect_identical(
    ids,
    c("sumID_name", "sumID_date_of_birth", "sumID_contact_details_email")
  )
  types <- vapply(
    buttons$selectedTags(),
    function(tag) htmltools::tagGetAttribute(tag, "type"),
    character(1),
    USE.NAMES = FALSE
  )
  expect_identical(types, rep("button", 3))
  expect_true(all(grepl(
    "govuk-link",
    vapply(
      buttons$selectedTags(),
      function(tag) htmltools::tagGetAttribute(tag, "class"),
      character(1)
    ),
    fixed = TRUE
  )))
})

test_that("two summary lists with the same headers do not clash", {
  headers <- c("Name", "Date of birth")
  info <- c("Sarah Philips", "5 January 1978")

  page <- shiny::tagList(
    gov_summary("applicant", headers, info, action = TRUE),
    gov_summary("partner", headers, info, action = TRUE)
  )
  query <- htmltools::tagQuery(page)

  expect_length(query$find("#applicant_name")$selectedTags(), 1)
  expect_length(query$find("#partner_name")$selectedTags(), 1)
  expect_length(query$find("#applicant_date_of_birth")$selectedTags(), 1)
  expect_length(query$find("#partner_date_of_birth")$selectedTags(), 1)
})

test_that("headers that give the same input ID error", {
  expect_error(
    gov_summary(
      "sumID",
      c("Date of birth", "Date-of-birth"),
      c("a", "b"),
      action = TRUE
    ),
    "unique input IDs"
  )
  expect_error(
    gov_summary("sumID", c("Name", "?"), c("a", "b"), action = TRUE),
    "letter or number"
  )
  # Duplicate headers are fine when there are no actions.
  expect_no_error(
    gov_summary("sumID", c("Name", "Name"), c("a", "b"), action = FALSE)
  )
})

test_that("action buttons include visually hidden header text", {
  out <- gov_summary(
    "sumID",
    c("Name", "Date of birth"),
    c("Sarah Philips", "5 January 1978"),
    action = TRUE
  )
  hidden <- htmltools::tagQuery(out)$find("#sumID_date_of_birth")$find(
    ".govuk-visually-hidden"
  )$selectedTags()

  expect_length(hidden, 1)
  expect_identical(
    as.character(hidden[[1]]),
    "<span class=\"govuk-visually-hidden\"> date of birth</span>"
  )
  name_button <- htmltools::tagQuery(out)$find("#sumID_name")$selectedTags()
  expect_match(
    gsub("\\s+", " ", as.character(name_button[[1]])),
    "Change <span class=\"govuk-visually-hidden\"> name</span>",
    fixed = TRUE
  )
})

test_that("action = FALSE renders no actions column", {
  out <- gov_summary(
    "sumID",
    c("Name", "Date of birth"),
    c("Sarah Philips", "5 January 1978"),
    action = FALSE
  )
  query <- htmltools::tagQuery(out)

  expect_length(query$find(".govuk-summary-list__actions")$selectedTags(), 0)
  expect_length(query$find("button")$selectedTags(), 0)
})

## ---- breakpoint override (#89) ----------------------------------------------

test_that("gov_summary attaches the summary-overrides stylesheet", {
  out <- gov_summary("sumID", c("Name"), c("Sarah Philips"))
  deps <- htmltools::findDependencies(out)
  summary_dep <- Filter(function(d) identical(d$name, "summary"), deps)
  expect_length(summary_dep, 1)
  expect_identical(summary_dep[[1]]$stylesheet, "summary-overrides.css")
})

## ---- rows without actions ---------------------------------------------------

test_that("action = FALSE rows get the --no-actions class", {
  out <- gov_summary(
    "sumID",
    c("Name", "Date of birth"),
    c("Sarah Philips", "5 January 1978"),
    action = FALSE
  )
  expect_length(find_tags(out, "govuk-summary-list__row--no-actions"), 2)
})

test_that("action = TRUE rows don't get the --no-actions class", {
  out <- gov_summary(
    "sumID",
    c("Name", "Date of birth"),
    c("Sarah Philips", "5 January 1978"),
    action = TRUE
  )
  expect_no_tag(out, "govuk-summary-list__row--no-actions")
  expect_length(find_tags(out, "govuk-summary-list__actions"), 2)
})

test_that("a character vector of IDs sets each row's action", {
  out <- gov_summary(
    "sumID",
    c("Name", "Date of birth"),
    c("Sarah Philips", "5 January 1978"),
    action = c("edit_name", NA)
  )
  query <- htmltools::tagQuery(out)
  expect_length(query$find("button#edit_name")$selectedTags(), 1)
  expect_length(query$find("button")$selectedTags(), 1)
  expect_length(find_tags(out, "govuk-summary-list__row--no-actions"), 1)
})

## ---- rows API ---------------------------------------------------------------

test_that("rows API: a row without actions gets the --no-actions class", {
  out <- gov_summary(
    "sumID",
    rows = list(list(key = "Name", value = "Sarah", actions = list()))
  )
  expect_has_tag(out, "govuk-summary-list__row--no-actions")
  expect_no_tag(out, "govuk-summary-list__actions")
})

test_that("rows API: a row with an action has no --no-actions class", {
  out <- gov_summary(
    "sumID",
    rows = list(list(
      key = "Name",
      value = "Sarah",
      actions = list(
        list(id = "change_name", text = "Change", visually_hidden_text = "name")
      )
    ))
  )
  expect_no_tag(out, "govuk-summary-list__row--no-actions")
  # A single action is a button straight inside the actions cell, not a list
  expect_no_tag(out, "govuk-summary-list__actions-list")
  button <- htmltools::tagQuery(out)$find("button#change_name")$selectedTags()
  expect_length(button, 1)
  expect_match(
    gsub("\\s+", " ", as.character(button[[1]])),
    "Change <span class=\"govuk-visually-hidden\"> name</span>",
    fixed = TRUE
  )
})

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

test_that("rows API: multiple actions render as an actions list", {
  out <- gov_summary(
    "sumID",
    rows = list(list(
      key = "Contact",
      value = "Unknown",
      actions = list(
        list(id = "add_c", text = "Add", visually_hidden_text = "contact"),
        list(id = "change_c", text = "Change", visually_hidden_text = "contact")
      )
    ))
  )
  actions_list <- find_tag_required(out, "govuk-summary-list__actions-list")
  expect_identical(actions_list$name, "ul")
  items <- find_tags(actions_list, "govuk-summary-list__actions-list-item")
  expect_length(items, 2)
  ids <- vapply(
    find_tags(actions_list, "action-button"),
    function(tag) htmltools::tagGetAttribute(tag, "id"),
    character(1)
  )
  expect_identical(ids, c("add_c", "change_c"))
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
  expect_match(htmltools::tagGetAttribute(out, "class"), "govuk-summary-card")
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

test_that("gov_summary_card without card_actions has no actions list", {
  expect_no_tag(summary_card(), "govuk-summary-card__actions")
})

test_that("gov_summary_card card_actions render as list items", {
  out <- summary_card(
    card_actions = list(
      list(id = "del", text = "Delete", visually_hidden_text = "(Lead tenant)"),
      list(
        id = "wit",
        text = "Withdraw",
        visually_hidden_text = "(Lead tenant)"
      )
    )
  )
  actions <- find_tag_required(out, "govuk-summary-card__actions")
  expect_identical(actions$name, "ul")
  expect_length(find_tags(actions, "govuk-summary-card__action"), 2)
})
