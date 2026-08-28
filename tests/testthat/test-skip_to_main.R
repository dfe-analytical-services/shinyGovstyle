test_that("test skip_to_main_href", {
  expect_equal(htmltools::tagGetAttribute(skip_to_main(), "href"), "#main")
  expect_equal(
    htmltools::tagGetAttribute(skip_to_main("main_col"), "href"),
    "#main_col"
  )
})
