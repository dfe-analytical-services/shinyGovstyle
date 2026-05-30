#Test custom links
test_that("subcontents_links", {
  subcontents_check <-
    subcontents_links(c("Here are my", "Subcontents Links!"), c(NA, NA))

  links <- find_tags(subcontents_check, "govuk-link--no-visited-state")
  expect_identical(links[[2]]$attribs$href, "#subcontents_links")
})


# Test custom subcontents links
test_that("custom subcontents_links", {
  custom_subcontents_check <-
    subcontents_links(
      c("Here are my", "Subcontents Links!"),
      c(NA, "custom_link")
    )

  links <- find_tags(
    custom_subcontents_check,
    "govuk-link--no-visited-state"
  )
  expect_identical(links[[2]]$attribs$href, "#custom_link")
})
