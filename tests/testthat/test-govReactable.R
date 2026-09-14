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

test_that("govReactable without a caption returns the bare widget", {
  table <- govReactable(df = shinyGovstyle::transport_data)
  expect_s3_class(table, "reactable")
  expect_s3_class(table, "htmlwidget")
})

test_that("govReactable links a supplied caption to the table", {
  table <- govReactable(
    df = shinyGovstyle::transport_data,
    caption = "Transport data"
  )

  html <- htmltools::renderTags(table)$html

  expect_match(
    html,
    '<h2 class="govuk-heading-l" id="transport_data">Transport data</h2>',
    fixed = TRUE
  )
  expect_match(
    html,
    '<div role="region" aria-labelledby="transport_data">',
    fixed = TRUE
  )
})

test_that("govReactable caption respects caption_size and heading_level", {
  table <- govReactable(
    df = shinyGovstyle::transport_data,
    caption = "Transport data",
    caption_size = "xl",
    heading_level = 3
  )

  html <- htmltools::renderTags(table)$html

  expect_match(
    html,
    '<h3 class="govuk-heading-xl" id="transport_data">Transport data</h3>',
    fixed = TRUE
  )
})

test_that("govReactable errors on an invalid heading_level", {
  expect_error(
    govReactable(
      df = shinyGovstyle::transport_data,
      caption = "Transport data",
      heading_level = 0
    ),
    "heading_level must be an integer between 1 and 6"
  )
  expect_error(
    govReactable(
      df = shinyGovstyle::transport_data,
      caption = "Transport data",
      heading_level = 7
    ),
    "heading_level must be an integer between 1 and 6"
  )
})

test_that("govReactable errors on an invalid caption_size", {
  expect_error(
    govReactable(
      df = shinyGovstyle::transport_data,
      caption = "Transport data",
      caption_size = "xxl"
    ),
    "caption_size must be one of"
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
