#Test custom links
test_that("subcontents_links", {
  subcontents_check <-
    subcontents_links(c("Here are my", "Subcontents Links!"), c(NA, NA))

  expect_identical(
    subcontents_check$children[[1]][[2]]$children[[2]]$attribs$href,
    "#subcontents_links"
  )
})


# Test custom subcontents links
test_that("custom subcontents_links", {
  custom_subcontents_check <-
    subcontents_links(
      c("Here are my", "Subcontents Links!"),
      c(NA, "custom_link")
    )

  expect_identical(
    custom_subcontents_check$children[[1]][[2]]$children[[2]]$attribs$href,
    "#custom_link"
  )
})
