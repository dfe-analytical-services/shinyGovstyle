test_that("select works", {
  choices <- c("A", "B", "C")
  select_test <- select_Input("slt1", "Select test", choices, choices)

  select <- find_tag_required(select_test, "govuk-select")
  expect_identical(select$attribs$class, "govuk-select")

  # <option> tags carry no class, so match them by tag name
  expect_length(find_tags_by_name(select_test, "option"), length(choices))
})
