test_that("contents_link", {
  contents_check <- contents_link("Test content link", "test_content_link")

  expect_snapshot(contents_check)
})

test_that("subcontents in contents_link", {
  contents_check <- contents_link(
    "Test content link",
    "test_content_link",
    c("My test", "Subcontents", "Links")
  )

  expect_snapshot(contents_check)
})

test_that("custom subcontents in contents_link", {
  contents_check <- contents_link(
    "Test content link",
    "test_content_link",
    c("My test", "Subcontents", "Links"),
    c(NA, NA, "my_custom_link")
  )

  expect_snapshot(contents_check)
})
