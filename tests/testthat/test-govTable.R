# headers/cells are indexed positionally because column order is semantically
# meaningful for a table: index i corresponds to column i of the source df.

data_cell_classes <- function(table) {
  rows <- find_tags(
    find_tag(table, "govuk-table__body"),
    "govuk-table__row"
  )
  lapply(rows, function(row) {
    cells <- find_tags(row, "govuk-table__cell")
    unname(vapply(
      cells,
      function(cell) htmltools::tagGetAttribute(cell, "class"),
      character(1L)
    ))
  })
}

numeric_cell <- "govuk-table__cell govuk-table__cell--numeric"

test_that("table with specified widths sets header width classes", {
  table_check <- govTable(
    "tab1",
    shinyGovstyle::transport_data_small,
    "Test",
    "l",
    num_col = c(2, 3),
    width_overwrite = c("one-half", "one-quarter", "one-quarter")
  )

  headers <- find_tags(table_check, "govuk-table__header")
  expect_identical(
    htmltools::tagGetAttribute(headers[[1]], "class"),
    "govuk-table__header govuk-!-width-one-half"
  )
  expect_identical(
    htmltools::tagGetAttribute(headers[[2]], "class"),
    paste(
      "govuk-table__header govuk-table__header--numeric",
      "govuk-!-width-one-quarter"
    )
  )
  expect_identical(
    htmltools::tagGetAttribute(headers[[3]], "class"),
    paste(
      "govuk-table__header govuk-table__header--numeric",
      "govuk-!-width-one-quarter"
    )
  )

  body_rows <- find_tags(
    find_tag(table_check, "govuk-table__body"),
    "govuk-table__row"
  )
  expect_length(body_rows, 3L)

  for (row_cells in data_cell_classes(table_check)) {
    expect_identical(row_cells, c(numeric_cell, numeric_cell))
  }
})

test_that("table with NULL width_overwrite omits width classes", {
  table_check <- govTable(
    "tab2",
    shinyGovstyle::transport_data_small,
    "Test",
    "l",
    num_col = c(2, 3),
    width_overwrite = NULL
  )

  headers <- find_tags(table_check, "govuk-table__header")
  expect_identical(
    htmltools::tagGetAttribute(headers[[1]], "class"),
    "govuk-table__header"
  )
  expect_identical(
    htmltools::tagGetAttribute(headers[[2]], "class"),
    "govuk-table__header govuk-table__header--numeric"
  )
  expect_identical(
    htmltools::tagGetAttribute(headers[[3]], "class"),
    "govuk-table__header govuk-table__header--numeric"
  )

  expect_length(
    find_tags(find_tag(table_check, "govuk-table__body"), "govuk-table__row"),
    3L
  )

  for (row_cells in data_cell_classes(table_check)) {
    expect_identical(row_cells, c(numeric_cell, numeric_cell))
  }
})

test_that("table with width_overwrite omitted (default) omits width classes", {
  table_check <- govTable(
    "tab2",
    shinyGovstyle::transport_data_small,
    "Test",
    "l",
    num_col = c(2, 3)
  )

  headers <- find_tags(table_check, "govuk-table__header")
  expect_identical(
    htmltools::tagGetAttribute(headers[[1]], "class"),
    "govuk-table__header"
  )
  expect_identical(
    htmltools::tagGetAttribute(headers[[2]], "class"),
    "govuk-table__header govuk-table__header--numeric"
  )
  expect_identical(
    htmltools::tagGetAttribute(headers[[3]], "class"),
    "govuk-table__header govuk-table__header--numeric"
  )

  expect_length(
    find_tags(find_tag(table_check, "govuk-table__body"), "govuk-table__row"),
    3L
  )

  for (row_cells in data_cell_classes(table_check)) {
    expect_identical(row_cells, c(numeric_cell, numeric_cell))
  }
})

test_that("large tables render without a recursion error", {
  # Regression test: tables beyond ~1200 rows previously failed with
  # "evaluation nested too deeply: infinite recursion". Rendering scales
  # linearly with row count, so this is skipped on CRAN to respect time limits.
  skip_on_cran()

  n <- 5000
  big_df <- data.frame(
    a = paste0("r", seq_len(n)),
    b = seq_len(n),
    c = seq_len(n)
  )

  # Tables this size also trigger the govReactable() recommendation warning
  expect_warning(
    big_table <- govTable("big", big_df, "Test"),
    "Consider govReactable"
  )
  expect_no_error(as.character(big_table))
})

test_that("govTable warns for large tables", {
  over_df <- data.frame(a = paste0("r", seq_len(51)), b = seq_len(51))
  expect_warning(
    govTable("over", over_df, "Test"),
    "Consider govReactable"
  )

  under_df <- data.frame(a = paste0("r", seq_len(50)), b = seq_len(50))
  expect_no_warning(govTable("under", under_df, "Test"))
})

test_that("rows render in dataframe order", {
  order_df <- data.frame(
    a = c("AAA", "BBB", "CCC"),
    b = 1:3
  )

  rendered <- as.character(govTable("ordered", order_df, "Test"))

  expect_true(regexpr(">AAA<", rendered) < regexpr(">BBB<", rendered))
  expect_true(regexpr(">BBB<", rendered) < regexpr(">CCC<", rendered))
})
