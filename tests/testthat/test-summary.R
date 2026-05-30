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
      "72 Guild Street", shiny::tags$br(),
      "London", shiny::tags$br(),
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
