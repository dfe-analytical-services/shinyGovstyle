test_that("tabs works", {
  tabs <- c(
    rep("Past Day", 3),
    rep("Past Week", 3),
    rep("Past Month", 3),
    rep("Past Year", 3)
  )
  case_manager <- rep(c("David Francis", "Paul Farmer", "Rita Patel"), 4)
  cases_open <- c(3, 1, 2, 24, 16, 24, 98, 122, 126, 1380, 1129, 1539)
  cases_closed <- c(0, 0, 0, 18, 20, 27, 95, 131, 142, 1472, 1083, 1265)
  data <- data.frame(tabs, case_manager, cases_open, cases_closed)

  tab_check <- govTabs("tabsID", data, "tabs")

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
