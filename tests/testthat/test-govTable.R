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

test_that("caption_size must be one of xl, l, m, s", {
  expect_error(
    govTable(
      "bad_size",
      shinyGovstyle::transport_data_small,
      "Test",
      caption_size = "not a size"
    )
  )
})

test_that("caption renders as table caption text, defaulting to size l", {
  table_check <- govTable(
    "tab1",
    shinyGovstyle::transport_data_small,
    "Table caption"
  )
  expect_identical(
    tag_text(table_check, "govuk-table__caption"),
    "Table caption"
  )
  expect_has_tag(table_check, "govuk-table__caption--l")
})

test_that("caption_size sets the caption modifier class", {
  table_check <- govTable(
    "tab1",
    shinyGovstyle::transport_data_small,
    "Table caption",
    caption_size = "m"
  )
  expect_has_tag(table_check, "govuk-table__caption--m")
})

test_that("subtitle sits inside the native caption, under the headline", {
  table_check <- govTable(
    "tab1",
    shinyGovstyle::transport_data_small,
    "Bike and car costs were highest in March",
    subtitle = "Cost of bikes and cars (£), January to March"
  )

  caption <- find_tag_required(table_check, "govuk-table__caption")
  caption_children <- rendered_children(caption)
  expect_length(caption_children, 2L)
  expect_identical(
    caption_children[[1]],
    "Bike and car costs were highest in March"
  )

  # Inside <caption>, so it is part of the table's accessible name
  subtitle <- find_tag_required(caption, "govuk-caption-m")
  expect_identical(subtitle$name, "span")
  expect_identical(
    tag_text(caption, "govuk-caption-m"),
    "Cost of bikes and cars (£), January to March"
  )
})

test_that("govTable subtitle size follows caption_size", {
  xl_table <- govTable(
    "tab1",
    shinyGovstyle::transport_data_small,
    "Headline",
    caption_size = "xl",
    subtitle = "Subtitle"
  )
  expect_has_tag(xl_table, "govuk-caption-l")

  m_table <- govTable(
    "tab1",
    shinyGovstyle::transport_data_small,
    "Headline",
    caption_size = "m",
    subtitle = "Subtitle"
  )
  expect_has_tag(m_table, "govuk-caption-m")
})

test_that("govTable renders the same without a subtitle", {
  args <- list("tab1", shinyGovstyle::transport_data_small, "Headline")
  expect_identical(
    as.character(do.call(govTable, args)),
    as.character(do.call(govTable, c(args, list(subtitle = NULL))))
  )
  expect_no_tag(do.call(govTable, args), "govuk-caption-m")
})

test_that("govTable escapes a plain-text subtitle", {
  html <- as.character(
    govTable(
      "tab1",
      shinyGovstyle::transport_data_small,
      "Headline",
      subtitle = "Bikes < cars"
    )
  )
  expect_match(html, "Bikes &lt; cars</span>", fixed = TRUE)
})

test_that("govTable errors on an invalid subtitle", {
  for (bad in list("", NA_character_, c("a", "b"), 1)) {
    expect_error(
      govTable(
        "tab1",
        shinyGovstyle::transport_data_small,
        "Headline",
        subtitle = bad
      ),
      "`subtitle` must be a single, non-empty string",
      fixed = TRUE
    )
  }
})
