test_that("tag works", {
  tag_check <- shinyGovstyle::tag_Input("tag1", "Complete")
  expect_identical(
    tag_check$children[[1]],
    "Complete"
  )

  expect_identical(
    tag_check$attribs$class,
    "govuk-tag"
  )
})


test_that("tag colour works", {
  tag_check2 <- shinyGovstyle::tag_Input("tag1", "Complete", "yellow")

  expect_identical(
    tag_check2$attribs$class,
    "govuk-tag govuk-tag--yellow"
  )
})
