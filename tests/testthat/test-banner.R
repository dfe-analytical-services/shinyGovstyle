test_that("banner check", {
  banner_check <- banner("bannerId", "alpha", "Banner test")

  expect_identical(
    banner_check$children[[1]]$children[[1]]$children[[1]]$children[[1]],
    "alpha"
  )

  expect_identical(
    banner_check$children[[1]]$children[[1]]$children[[2]]$children[[1]],
    shiny::HTML("Banner test")
  )
})
