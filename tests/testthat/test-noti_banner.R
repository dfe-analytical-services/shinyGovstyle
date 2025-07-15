test_that("noti banner works", {
  noti_check <- shinyGovstyle::noti_banner(
    inputId = "banner",
    title_txt = "Important",
    body_txt = "Example text"
  )

  expect_identical(
    noti_check$children[[1]]$children[[1]]$children[[1]],
    "Important"
  )

  expect_identical(
    noti_check$children[[2]]$children[[1]]$children[[1]],
    shiny::HTML("Example text")
  )
})

test_that("noti success banner works", {
  noti_check <- shinyGovstyle::noti_banner(
    inputId = "banner",
    title_txt = "Important",
    body_txt = "Example text",
    type = "success"
  )

  expect_identical(
    noti_check$children[[1]]$children[[1]]$children[[1]],
    "Important"
  )

  expect_identical(
    noti_check$children[[2]]$children[[1]]$children[[1]],
    shiny::HTML("Example text")
  )
})
