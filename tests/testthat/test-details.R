test_that("details work", {
  check_details <- details("detailId", "Test Main", "Test Second")

  expect_identical(
    check_details$children[[1]]$children[[1]]$children[[1]],
    shiny::HTML("Test Main")
  )

  expect_identical(
    check_details$children[[2]]$children[[1]],
    "Test Second"
  )
})
