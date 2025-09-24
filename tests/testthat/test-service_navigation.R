# Check subcontents in contents link
test_that("subcontents in contents_link", {
  service_nav_test <- service_navigation(c("Page 1", "Page 2", "Page 3"))
  expect_equal(
    "page_1",
    service_nav_test$children[[1]]$children[[1]]$children[[1]]$children[[
      2
    ]]$children[[1]][[1]]$children[[1]][[2]][1]$id
  )

  expect_equal(
    "Page 1",
    service_nav_test$children[[1]]$children[[1]]$children[[1]]$children[[
      2
    ]]$children[[1]][[1]]$children[[1]][[3]][[1]][[2]]
  )
})
