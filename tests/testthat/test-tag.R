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


test_that("deprecated colours are warned against", {

  expect_warning(
    tag_Input("tag2", "Complete", "light-blue"),
    paste("light-blue' is no longer a supported colour. Please select an alternative from: 'navy', 'grey', 'purple', 'turquoise', 'blue', 'yellow', 'orange', 'red', 'pink', or 'green'.")
  )


})


