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

test_that("table sits in a scroll container labelled by its caption", {
  table_check <- govTable(
    "tab1",
    shinyGovstyle::transport_data_small,
    "Table caption"
  )

  # The scroll container is the outermost tag, with the table inside it
  expect_identical(
    htmltools::tagGetAttribute(table_check, "class"),
    "shinygovstyle-table-scroll"
  )
  table <- find_tag_required(table_check, "govuk-table")
  expect_identical(htmltools::tagGetAttribute(table, "id"), "tab1")

  # The caption names the container; table_scroll.js copies data-labelledby
  # to aria-labelledby only while the table scrolls
  caption <- find_tag_required(table_check, "govuk-table__caption")
  expect_identical(htmltools::tagGetAttribute(caption, "id"), "tab1-caption")
  expect_identical(
    htmltools::tagGetAttribute(table_check, "data-labelledby"),
    "tab1-caption"
  )

  # Not a tab stop or landmark until the script finds that it scrolls
  expect_null(htmltools::tagGetAttribute(table_check, "tabindex"))
  expect_null(htmltools::tagGetAttribute(table_check, "role"))
  expect_null(htmltools::tagGetAttribute(table_check, "aria-labelledby"))

  dep_names <- vapply(
    htmltools::findDependencies(table_check),
    function(dep) dep$name,
    character(1)
  )
  expect_true(all(c("table-scroll", "table-scroll-js") %in% dep_names))
})

test_that("one-column table keeps every row and the caption", {
  table_check <- govTable(
    "names",
    data.frame(Name = c("Alice", "Bob")),
    caption = "Names"
  )

  caption <- find_tag_required(table_check, "govuk-table__caption")
  expect_identical(caption$children[[1L]], "Names")

  body_rows <- find_tags(
    find_tag_required(table_check, "govuk-table__body"),
    "govuk-table__row"
  )
  expect_length(body_rows, 2L)

  # With one column, each row has only its row header and no data cells
  row_headers <- vapply(
    body_rows,
    function(row) {
      as.character(find_tag_required(row, "govuk-table__header")$children[[1L]])
    },
    character(1L)
  )
  expect_identical(row_headers, c("Alice", "Bob"))
  expect_length(find_tags(table_check, "govuk-table__cell"), 0L)
})

test_that("one-row table renders its header and cells", {
  table_check <- govTable(
    "one_row",
    data.frame(Area = "North", Count = 10, Rate = 0.5),
    caption = "One row",
    num_col = c(2, 3)
  )

  headers <- find_tags(
    find_tag_required(table_check, "govuk-table__head"),
    "govuk-table__header"
  )
  expect_length(headers, 3L)

  body_rows <- find_tags(
    find_tag_required(table_check, "govuk-table__body"),
    "govuk-table__row"
  )
  expect_length(body_rows, 1L)

  cells <- find_tags(body_rows[[1L]], "govuk-table__cell")
  cell_text <- vapply(
    cells,
    function(cell) as.character(cell$children[[1L]]),
    character(1L)
  )
  expect_identical(unname(cell_text), c("10", "0.5"))
  expect_identical(
    data_cell_classes(table_check),
    list(c(numeric_cell, numeric_cell))
  )
})

test_that("one-row, one-column table renders", {
  table_check <- govTable("single", data.frame(Name = "Alice"), "Single")

  body_rows <- find_tags(
    find_tag_required(table_check, "govuk-table__body"),
    "govuk-table__row"
  )
  expect_length(body_rows, 1L)
  expect_identical(
    as.character(
      find_tag_required(body_rows[[1L]], "govuk-table__header")$children[[1L]]
    ),
    "Alice"
  )
})
