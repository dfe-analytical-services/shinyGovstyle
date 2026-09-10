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

test_that("govReactable accepts a columns argument without erroring", {
  # Regression test for #243: passing `columns` (the standard reactable way
  # to set per-column formatting) used to collide with govReactable's own
  # internal `columns` argument and throw:
  # "formal argument \"columns\" matched by multiple actual arguments"
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  expect_no_error(
    govReactable(
      df,
      columns = list(
        percent = reactable::colDef(
          format = reactable::colFormat(digits = 1)
        )
      )
    )
  )
})

test_that("columns argument merges user format over GOV.UK defaults", {
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  table <- govReactable(
    df,
    right_col = c("count", "percent"),
    columns = list(
      percent = reactable::colDef(
        format = reactable::colFormat(digits = 1)
      )
    )
  )

  percent_col <- table$x$tag$attribs$columns[[
    which(
      vapply(
        table$x$tag$attribs$columns,
        function(col) identical(col$id, "percent"),
        logical(1)
      )
    )
  ]]

  # User-supplied field is applied
  expect_identical(percent_col$format$cell$digits, 1L)

  # GOV.UK defaults survive for the same column, since the user's colDef
  # only set `format`
  expect_true(percent_col$sortable)
  expect_true(percent_col$html)
  expect_identical(percent_col$na, "NA")
  expect_identical(percent_col$align, "right")
  expect_identical(percent_col$headerClassName, "bar-sort-header")
})

test_that("columns argument only affects the named column", {
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  table <- govReactable(
    df,
    columns = list(
      percent = reactable::colDef(
        format = reactable::colFormat(digits = 1)
      )
    )
  )

  count_col <- table$x$tag$attribs$columns[[
    which(
      vapply(
        table$x$tag$attribs$columns,
        function(col) identical(col$id, "count"),
        logical(1)
      )
    )
  ]]

  expect_null(count_col$format)
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
