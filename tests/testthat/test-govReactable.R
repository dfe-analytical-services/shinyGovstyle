test_that("table works", {
  # Test table with sorting and pagination enabled
  table_check <- govReactable(
    df = shinyGovstyle::transport_data,
    right_col = c("colours", "bikes", "cars", "vans", "buses"),
    page_size = 5
  )

  # Ensure the function runs without errors
  expect_no_error(table_check)

  # Take snapshot of table HTML
  output_html <- htmltools::renderTags(table_check)$html

  # Prevent unnecessary changes due to random IDs
  stripped_ids <- gsub('"htmlwidget-[^"]*"', "", output_html)

  expect_snapshot(stripped_ids)
})

test_that("govReactable attaches the reactable-overrides stylesheet", {
  table <- govReactable(df = shinyGovstyle::transport_data)
  dep_names <- vapply(table$dependencies, `[[`, character(1), "name")
  expect_true("reactable-overrides" %in% dep_names)
  expect_true("stylecss" %in% dep_names)
})

test_that("govReactable sets an accessible name matching the visible header", {
  # reactable defaults to aria-label "Sort {name}", mismatching the visible
  # header text and breaking voice control activation (WCAG 2.5.3, #190).
  table <- govReactable(df = shinyGovstyle::transport_data)
  expect_equal(table$x$tag$attribs$language$sortLabel, "{name}")
})

test_that("govReactableOutput includes a sort hint by default", {
  html_tags <- govReactableOutput("table", caption = "Example table")
  hint <- htmltools::tagQuery(html_tags)$find("p.govuk-body")$selectedTags()
  expect_length(hint, 1)
  expect_match(
    as.character(hint[[1]]),
    "Select a column heading to sort the table"
  )
})

test_that("govReactableOutput omits the sort hint when disabled", {
  html_tags <- govReactableOutput(
    "table",
    caption = "Example table",
    show_sort_hint = FALSE
  )
  hint <- htmltools::tagQuery(html_tags)$find("p.govuk-body")$selectedTags()
  expect_length(hint, 0)
})

test_that("govReactableOutput errors on an invalid show_sort_hint", {
  expect_error(
    govReactableOutput(
      "table",
      caption = "Example table",
      show_sort_hint = "yes"
    ),
    "show_sort_hint must be TRUE or FALSE"
  )
})

test_that("gov_table_sort_hint returns the expected tag", {
  hint <- gov_table_sort_hint()
  expect_s3_class(hint, "shiny.tag")
  expect_equal(hint$attribs$class, "govuk-body")
  expect_match(
    as.character(hint),
    "Select a column heading to sort the table by that column"
  )
  expect_match(
    as.character(hint),
    "Select it again to reverse the sort order"
  )
})

test_that("govReactable handles large tables", {
  # Unlike the static govTable(), reactable serialises the full dataset once
  # and paginates client-side, so it scales to far larger tables.
  n <- 100000L
  big_df <- data.frame(
    id = paste0("row", seq_len(n)),
    value = seq_len(n)
  )

  html <- htmltools::renderTags(govReactable(big_df))$html

  # The entire dataset is embedded in the payload, not truncated to a page.
  expect_match(html, paste0("row", n), fixed = TRUE)
})
