test_that("multiplication works", {
  insert_text <- insert_text("insert1", "Test insert")

  expect_identical(
    insert_text$attribs$id,
    "insert1"
  )

  expect_identical(
    insert_text$attribs$class,
    "govuk-inset-text"
  )

  expect_identical(
    shiny::HTML("Test insert"),
    insert_text$children[[1]]
  )
})
