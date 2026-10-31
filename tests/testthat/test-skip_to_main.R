test_that("test skip_to_main_href", {
  expect_equal(htmltools::tagGetAttribute(skip_to_main(), "href"), "#main")
  expect_equal(
    htmltools::tagGetAttribute(skip_to_main("main_col"), "href"),
    "#main_col"
  )
})

test_that("skip_to_main attaches the GOV.UK stylesheet", {
  expect_true("stylecss" %in% dependency_names(skip_to_main()))
})
