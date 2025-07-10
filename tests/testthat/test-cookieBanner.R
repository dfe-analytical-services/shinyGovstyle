test_that("cookie banner works", {
  cookieBannerCheck <- shinyGovstyle::cookieBanner("The best thing")

  cookieCheckChild <- cookieBannerCheck$children[[1]]

  expect_equal(
    length(cookieCheckChild$children[[2]]),
    3
  )

  expect_identical(
    cookieCheckChild$children[[1]]$children[[1]]$children[[1]]$children[[1]],
    "Cookies on The best thing"
  )

  expect_identical(
    cookieBannerCheck$children[[2]]$attribs[3]$class,
    "shinyjs-hide"
  )

  expect_identical(
    cookieBannerCheck$children[[3]]$attribs[3]$class,
    "shinyjs-hide"
  )
})
