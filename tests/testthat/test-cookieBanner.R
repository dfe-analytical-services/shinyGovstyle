test_that("cookie banner works", {
  cookie_banner_check <- shinyGovstyle::cookieBanner("The best thing")

  cookie_check_child <- cookie_banner_check$children[[1]]

  expect_equal(
    length(cookie_check_child$children[[2]]),
    3
  )

  expect_identical(
    cookie_check_child$children[[1]]$children[[1]]$children[[1]]$children[[1]],
    "Cookies on The best thing"
  )

  expect_identical(
    cookie_banner_check$children[[2]]$attribs[3]$class,
    "shinyjs-hide"
  )

  expect_identical(
    cookie_banner_check$children[[3]]$attribs[3]$class,
    "shinyjs-hide"
  )
})
