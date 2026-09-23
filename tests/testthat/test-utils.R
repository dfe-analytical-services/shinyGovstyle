test_that("validate_gds_text_size accepts the GDS size scale", {
  expect_identical(validate_gds_text_size("xl"), "xl")
  expect_identical(validate_gds_text_size("l"), "l")
  expect_identical(validate_gds_text_size("m"), "m")
  expect_identical(validate_gds_text_size("s"), "s")
})

test_that("validate_gds_text_size rejects invalid values", {
  expect_error(validate_gds_text_size("xxl"))
  expect_error(validate_gds_text_size(1))
  expect_error(validate_gds_text_size(c("m", "l")))
  expect_error(validate_gds_text_size(NA))
})

test_that("validate_gds_text_size uses arg_name in the error message", {
  expect_error(validate_gds_text_size("bad", "caption_size"), "caption_size")
  expect_error(validate_gds_text_size("bad", "label_size"), "label_size")
})

test_that("govFieldset defaults label_size to m", {
  fieldset <- govFieldset("id1", "Label", shiny::tags$div())
  legend <- find_tag_required(fieldset, "govuk-fieldset__legend")
  expect_identical(
    htmltools::tagGetAttribute(legend, "class"),
    "govuk-fieldset__legend govuk-fieldset__legend--m"
  )
})

test_that("govFieldset rejects invalid label_size", {
  expect_error(
    govFieldset("id1", "Label", shiny::tags$div(), label_size = "bad"),
    "label_size"
  )
  expect_error(
    govFieldset(
      "id1",
      "Label",
      shiny::tags$div(),
      label_size = c("m", "bad")
    ),
    "label_size"
  )
})
