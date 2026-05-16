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

  expect_length(
    find_tags(find_tag(table_check, "govuk-table__body"), "govuk-table__row"),
    3L
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

  headers2 <- find_tags(table_check2, "govuk-table__header")
  expect_identical(
    headers2[[1]]$attribs$class,
    "govuk-table__header"
  )
  expect_identical(
    headers2[[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric"
  )

  expect_length(
    find_tags(find_tag(table_check2, "govuk-table__body"), "govuk-table__row"),
    3L
  )

  # and if the argument isn't mentioned at all
  table_check3 <- govTable(
    "tab2",
    shinyGovstyle::transport_data_small,
    "Test",
    "l",
    num_col = c(2, 3)
  )

  headers3 <- find_tags(table_check3, "govuk-table__header")
  expect_identical(
    headers3[[1]]$attribs$class,
    "govuk-table__header"
  )
  expect_identical(
    headers3[[2]]$attribs$class,
    "govuk-table__header govuk-table__header--numeric"
  )

  expect_length(
    find_tags(find_tag(table_check3, "govuk-table__body"), "govuk-table__row"),
    3L
  )
})
