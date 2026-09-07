test_that("tag works", {
  tag_check <- shinyGovstyle::tag_Input("tag1", "Complete")

  expect_identical(
    htmltools::tagGetAttribute(tag_check, "class"),
    "govuk-tag"
  )

  expect_identical(
    tag_text(tag_check, "govuk-tag"),
    "Complete"
  )
})


test_that("tag colour works", {
  tag_check2 <- shinyGovstyle::tag_Input("tag1", "Complete", "yellow")

  expect_identical(
    htmltools::tagGetAttribute(tag_check2, "class"),
    "govuk-tag govuk-tag--yellow"
  )
})


test_that("deprecated colours are warned against", {
  expect_warning(
    tag_Input("tag2", "Complete", "light-blue"),
    paste(
      "'light-blue' is no longer a supported colour.
        Please select an alternative from:
       'navy', 'grey', 'purple', 'teal', 'blue', 'yellow',
        'orange', 'red', 'magenta', or 'green'."
    )
  )
})
