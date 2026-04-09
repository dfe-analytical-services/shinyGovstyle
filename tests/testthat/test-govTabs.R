test_that("tabs works", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")

  expect_equal(length(tab_check$children[[2]]$children[[1]]), 4)

  expect_identical(
    tab_check$children[[3]][[1]][[1]][[1]][[2]][[2]]$class,
    "govuk-tabs__panel"
  )

  expect_identical(
    tab_check$children[[3]][[1]][[1]][[2]][[2]]$class,
    "govuk-tabs__panel govuk-tabs__panel--hidden"
  )
})
