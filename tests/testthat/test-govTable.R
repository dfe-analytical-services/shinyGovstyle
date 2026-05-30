# headers/cells are indexed positionally because column order is semantically
# meaningful for a table: index i corresponds to column i of the source df.

data_cell_classes <- function(table) {
  rows <- find_tags(
    find_tag(table, "govuk-table__body"),
    "govuk-table__row"
  )
  lapply(rows, function(row) {
    cells <- find_tags(row, "govuk-table__cell")
    unname(vapply(cells, function(c) c$attribs$class, character(1L)))
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
    headers[[1]]$attribs$class,
    "govuk-table__header govuk-!-width-one-half"
  )
  expect_identical(
    headers[[2]]$attribs$class,
    paste(
      "govuk-table__header govuk-table__header--numeric",
      "govuk-!-width-one-quarter"
    )
  )
  expect_identical(
    headers[[3]]$attribs$class,
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
    headers[[1]]$attribs$class,
    "govuk-table__header"
  )
  expect_identical(
    headers[[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric"
  )
  expect_identical(
    headers[[3]]$attribs$class,
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
    headers[[1]]$attribs$class,
    "govuk-table__header"
  )
  expect_identical(
    headers[[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric"
  )
  expect_identical(
    headers[[3]]$attribs$class,
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
