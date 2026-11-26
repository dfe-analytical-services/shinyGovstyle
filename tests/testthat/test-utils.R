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

test_that("validate_heading_level accepts whole numbers from 1 to 6", {
  for (level in 1:6) {
    expect_no_error(validate_heading_level(level))
    # A plain number works as well as an integer, e.g. 3 as well as 3L
    expect_no_error(validate_heading_level(as.numeric(level)))
  }
})

test_that("validate_heading_level rejects anything else", {
  for (bad in list(0, 7, 2.5, "h2", "2", NA, NA_real_, NULL)) {
    expect_error(validate_heading_level(bad), "`heading_level` must be")
  }
  expect_error(
    validate_heading_level(c(2, 3)),
    "`heading_level` must be a single value, not length 2.",
    fixed = TRUE
  )
  expect_error(
    validate_heading_level(7),
    "`heading_level` must be an integer between 1 and 6.",
    fixed = TRUE
  )
})

test_that("validate_heading_level uses arg_name in the error message", {
  expect_error(
    validate_heading_level(7, arg_name = "level"),
    "`level` must be an integer between 1 and 6.",
    fixed = TRUE
  )
})

test_that("build_heading_tag makes the same tag for 3 and 3L", {
  integer_tag <- build_heading_tag(3L, "Title", "govuk-heading-m", "title-id")
  number_tag <- build_heading_tag(3, "Title", "govuk-heading-m", "title-id")

  expect_identical(integer_tag$name, "h3")
  expect_identical(number_tag, integer_tag)
  expect_identical(
    htmltools::tagGetAttribute(integer_tag, "class"),
    "govuk-heading-m"
  )
  expect_identical(htmltools::tagGetAttribute(integer_tag, "id"), "title-id")
})

test_that("govuk_markup_html escapes plain strings", {
  expect_identical(
    govuk_markup_html("<b>A</b> & B"),
    "&lt;b&gt;A&lt;/b&gt; &amp; B"
  )
})

test_that("govuk_markup_html passes markup through as a string", {
  expect_identical(govuk_markup_html(shiny::HTML("<b>A</b>")), "<b>A</b>")
  expect_identical(govuk_markup_html(shiny::tags$b("A")), "<b>A</b>")
})

test_that("validate_single_content accepts text and markup", {
  expect_no_error(validate_single_content("Title", "caption"))
  expect_no_error(validate_single_content(shiny::HTML("<b>T</b>"), "caption"))
  expect_no_error(validate_single_content(shiny::tags$b("T"), "caption"))
  expect_no_error(validate_single_content(NULL, "caption"))
})

test_that("validate_single_content rejects empty or ambiguous values", {
  for (bad in list("", NA_character_, c("a", "b"), 1, TRUE)) {
    expect_error(
      validate_single_content(bad, "subtitle"),
      "`subtitle` must be a single, non-empty string",
      fixed = TRUE
    )
  }
  expect_error(
    validate_single_content(NULL, "caption", allow_null = FALSE),
    "`caption` must be a single, non-empty string",
    fixed = TRUE
  )
})

test_that("subtitle_class keeps the subtitle smaller than the headline", {
  expect_identical(subtitle_class("xl"), "govuk-caption-l")
  expect_identical(subtitle_class("l"), "govuk-caption-m")
  expect_identical(subtitle_class("m"), "govuk-caption-m")
  expect_identical(subtitle_class("s"), "govuk-caption-m")
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

test_that("govuk_described_by() lists visible ids and never the error id", {
  expect_null(govuk_described_by("x"))
  expect_identical(govuk_described_by("x", hint_label = "Hint"), "x-hint")
  expect_identical(
    govuk_described_by("x", hint_label = "Hint", extra_ids = "x-info"),
    "x-info x-hint"
  )
})

test_that("govuk_error_describedby_js() applies the module namespace", {
  # shinyjs namespaces ids itself inside modules; runjs() does not, so the
  # helper has to, or error_on() would miss controls built with shiny::NS().
  session <- list(ns = shiny::NS("mod"))
  js <- govuk_error_describedby_js("txt", show = TRUE, session = session)

  expect_match(js, "var id = \"mod-txt\";", fixed = TRUE)
  expect_match(js, "var errorId = \"mod-txt-error\";", fixed = TRUE)
})
