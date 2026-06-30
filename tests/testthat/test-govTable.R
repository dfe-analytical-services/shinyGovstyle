test_that("table works", {
  # test table with specified widths
  table_check <- govTable(
    "tab1",
    shinyGovstyle::transport_data_small,
    "Test",
    "l",
    num_col = c(2, 3),
    width_overwrite = c("one-half", "one-quarter", "one-quarter")
  )

  expect_identical(
    table_check$children[[2]]$children[[1]][[3]][[1]][[1]]$attribs$class,
    "govuk-table__header govuk-!-width-one-half"
  )

  expect_identical(
    table_check$children[[2]]$children[[1]][[3]][[1]][[2]]$attribs$class,
    paste(
      "govuk-table__header govuk-table__header--numeric",
      "govuk-!-width-one-quarter"
    )
  )

  expect_equal(
    length(table_check$children[[3]]),
    3
  )

  # test table with unspecified widths
  table_check2 <- govTable(
    "tab2",
    shinyGovstyle::transport_data_small,
    "Test",
    "l",
    num_col = c(2, 3),
    width_overwrite = NULL
  )

  expect_identical(
    table_check2$children[[2]]$children[[1]][[3]][[1]][[1]]$attribs$class,
    "govuk-table__header"
  )

  expect_identical(
    table_check2$children[[2]]$children[[1]][[3]][[1]][[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric"
  )

  expect_equal(
    length(table_check2$children[[3]]),
    3
  )

  # and if the argument isn't mentioned at all
  table_check3 <- govTable(
    "tab2",
    shinyGovstyle::transport_data_small,
    "Test",
    "l",
    num_col = c(2, 3)
  )

  expect_identical(
    table_check3$children[[2]]$children[[1]][[3]][[1]][[1]]$attribs$class,
    "govuk-table__header"
  )

  expect_identical(
    table_check3$children[[2]]$children[[1]][[3]][[1]][[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric"
  )

  expect_equal(
    length(table_check3$children[[3]]),
    3
  )
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
