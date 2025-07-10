test_that("select works", {
  choices <- c("A", "B", "C")
  select_test <- select_Input("slt1", "Select test", choices, choices)

  expect_equal(
    length(select_test$children[[2]]$children[[1]]),
    length(choices)
  )

  expect_identical(
    select_test$children[[2]]$attribs$class,
    "govuk-select"
  )
})
