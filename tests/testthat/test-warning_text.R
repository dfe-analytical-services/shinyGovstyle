test_that("warning works", {
  warn_check <- warning_text("warningId", "Test")

  expect_identical(
    warn_check$children[[2]]$children[[1]],
    "Test"
  )
})
