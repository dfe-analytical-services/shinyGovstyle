test_that("govReactableOutput links the caption to the table region", {
  output_tag <- govReactableOutput("table", caption = "Example table")

  html <- htmltools::renderTags(output_tag)$html

  expect_match(
    html,
    '<h2 class="govuk-heading-l" id="example_table">Example table</h2>',
    fixed = TRUE
  )
  expect_match(
    html,
    '<div role="region" aria-labelledby="example_table">',
    fixed = TRUE
  )
})

test_that("govReactableOutput caption respects caption_size/heading_level", {
  output_tag <- govReactableOutput(
    "table",
    caption = "Example table",
    caption_size = "s",
    heading_level = 4
  )

  html <- htmltools::renderTags(output_tag)$html

  expect_match(
    html,
    '<h4 class="govuk-heading-s" id="example_table">Example table</h4>',
    fixed = TRUE
  )
})

test_that("govReactableOutput errors on an invalid heading_level", {
  expect_error(
    govReactableOutput(
      "table",
      caption = "Example table",
      heading_level = 0
    ),
    "heading_level must be an integer between 1 and 6"
  )
  expect_error(
    govReactableOutput(
      "table",
      caption = "Example table",
      heading_level = 7
    ),
    "heading_level must be an integer between 1 and 6"
  )
})

test_that("govReactableOutput errors on an invalid caption_size", {
  expect_error(
    govReactableOutput(
      "table",
      caption = "Example table",
      caption_size = "xxl"
    ),
    "`caption_size` must be one of",
    fixed = TRUE
  )
})

test_that("deprecated string heading_level still works with a warning", {
  rlang::local_options(lifecycle_verbosity = "warning")
  expect_warning(
    output_tag <- govReactableOutput(
      "table",
      caption = "Example table",
      heading_level = "h3"
    ),
    class = "lifecycle_warning_deprecated"
  )

  html <- htmltools::renderTags(output_tag)$html
  expect_match(
    html,
    '<h3 class="govuk-heading-l" id="example_table">Example table</h3>',
    fixed = TRUE
  )
})

test_that("deprecated string heading_level rejects malformed values", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_error(
    govReactableOutput(
      "table",
      caption = "Example table",
      heading_level = "h9"
    ),
    "heading_level must be an integer between 1 and 6"
  )
})
