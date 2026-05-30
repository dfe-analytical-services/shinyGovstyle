test_that("label hint workss", {
  label_check <- label_hint("hintID", "Upper", "Lower")

  expect_identical(tag_text(label_check, "govuk-label"), shiny::HTML("Upper"))
  expect_identical(tag_text(label_check, "govuk-hint"), "Lower")
})
