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
