test_that("backlink works", {
  expect_no_error(backlink_Input("backId"))
})

test_that("backlink HTML is as expected", {
  local_edition(3)
  expect_snapshot(backlink_Input("backId"))
})
