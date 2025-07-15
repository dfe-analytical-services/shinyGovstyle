test_that("label hint workss", {
  label_check <- label_hint("hintID", "Upper", "Lower")

  expect_identical(
    label_check$children[[1]]$children[[1]],
    shiny::HTML("Upper")
  )

  expect_identical(
    label_check$children[[2]]$children[[1]],
    "Lower"
  )
})
