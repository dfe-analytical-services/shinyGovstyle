test_that("govReactableOutput links the caption to the table region", {
  output_tag <- govReactableOutput("table", caption = "Example table")

  html <- htmltools::renderTags(output_tag)$html

  expect_match(
    html,
    '<h2 class="govuk-heading-l" id="table-caption">Example table</h2>',
    fixed = TRUE
  )
  expect_match(
    html,
    '<div role="region" aria-labelledby="table-caption">',
    fixed = TRUE
  )
})

test_that("govReactableOutput caption ids follow the (namespaced) output id", {
  # Output ids are already unique on a Shiny page, so captions that share
  # text, or have no letters at all, still get distinct ids.
  ns <- shiny::NS("mod")
  page <- htmltools::tagList(
    govReactableOutput("table_a", caption = "2025"),
    govReactableOutput("table_b", caption = "2025"),
    govReactableOutput(ns("table_a"), caption = "2025")
  )

  links <- caption_links(page)
  expect_identical(
    links$heading_ids,
    c("table_a-caption", "table_b-caption", "mod-table_a-caption")
  )
  expect_identical(links$labelledby, links$heading_ids)
})

test_that("govReactableOutput subtitle id follows the (namespaced) output id", {
  ns <- shiny::NS("mod")
  output_tag <- govReactableOutput(
    ns("table"),
    caption = "Costs peaked in March",
    subtitle = "Cost of vehicles (£), January to May"
  )

  subtitle <- find_tag_required(output_tag, "govuk-caption-m")
  expect_identical(
    htmltools::tagGetAttribute(subtitle, "id"),
    "mod-table-subtitle"
  )
  expect_identical(
    caption_links(output_tag)$labelledby,
    "mod-table-caption mod-table-subtitle"
  )
})

test_that("govReactableOutput markup is unchanged without a subtitle", {
  output_tag <- govReactableOutput("table", caption = "Example table")
  expect_no_tag(output_tag, "govuk-caption-m")
  expect_identical(caption_links(output_tag)$labelledby, "table-caption")
})

test_that("govReactableOutput errors on an invalid caption or subtitle", {
  expect_error(
    govReactableOutput("table", caption = ""),
    "`caption` must be a single, non-empty string",
    fixed = TRUE
  )
  expect_error(
    govReactableOutput("table", caption = "Headline", subtitle = NA_character_),
    "`subtitle` must be a single, non-empty string",
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
    '<h4 class="govuk-heading-s" id="table-caption">Example table</h4>',
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
    '<h3 class="govuk-heading-l" id="table-caption">Example table</h3>',
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
