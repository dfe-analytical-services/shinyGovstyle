# Check contents link
test_that("contents_link", {
  contents_check <- contents_link("Test content link", "test_content_link")

  expect_equal("test_content_link", contents_check$children[[1]]$attribs$id)
})


# Check subcontents in contents link
test_that("subcontents in contents_link", {
  contents_check <- contents_link(
    "Test content link",
    "test_content_link",
    c("My test", "Subcontents", "Links")
  )

  expect_equal(
    "#my_test",
    contents_check$children[[2]]$children[[1]][[1]]$children[[2]]$attribs$href
  )
})

# Check custom subcontents links
test_that("custom subcontents in contents_link", {
  contents_check <- contents_link(
    "Test content link",
    "test_content_link",
    c("My test", "Subcontents", "Links"),
    c(NA, NA, "my_custom_link")
  )

  expect_equal(
    "#my_custom_link",
    contents_check$children[[2]]$children[[1]][[3]]$children[[2]]$attribs$href
  )
})
