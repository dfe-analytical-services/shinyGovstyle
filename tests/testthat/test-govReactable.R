test_that("table works", {
  # Test table with sorting and pagination enabled
  table_check <- govReactable(
    df = shinyGovstyle::transport_data,
    right_col = c("colours", "bikes", "cars", "vans", "buses"),
    page_size = 5
  )

  # Ensure the function runs without errors
  expect_no_error(table_check)

  # Take snapshot of table HTML
  output_html <- htmltools::renderTags(table_check)$html

  # Prevent unnecessary changes due to random IDs
  stripped_ids <- gsub('"htmlwidget-[^"]*"', "", output_html)

  expect_snapshot(stripped_ids)
})

test_that("govReactable attaches the reactable-overrides stylesheet", {
  table <- govReactable(df = shinyGovstyle::transport_data)
  dep_names <- vapply(table$dependencies, `[[`, character(1), "name")
  expect_true("reactable-overrides" %in% dep_names)
  expect_true("stylecss" %in% dep_names)
})

test_that("govReactable without a caption returns the bare widget", {
  table <- govReactable(df = shinyGovstyle::transport_data)
  expect_s3_class(table, "reactable")
  expect_s3_class(table, "htmlwidget")
})

test_that("govReactable links a supplied caption to the table", {
  table <- govReactable(
    df = shinyGovstyle::transport_data,
    caption = "Transport data"
  )

  expect_identical(
    tag_text(table, "govuk-heading-l"),
    "Transport data"
  )
  expect_identical(find_tag_required(table, "govuk-heading-l")$name, "h2")

  links <- caption_links(table)
  expect_length(links$labelledby, 1L)
  expect_true(nzchar(links$heading_ids))
  expect_identical(links$labelledby, links$heading_ids)
})

test_that("govReactable caption respects caption_size and heading_level", {
  table <- govReactable(
    df = shinyGovstyle::transport_data,
    caption = "Transport data",
    caption_size = "xl",
    heading_level = 3
  )

  heading <- find_tag_required(table, "govuk-heading-xl")
  expect_identical(heading$name, "h3")
  expect_identical(
    tag_text(table, "govuk-heading-xl"),
    "Transport data"
  )
})

test_that("each captioned govReactable is linked to its own caption", {
  # Captions that differ only by digits, or have no letters at all, used to
  # collapse to the same (or an empty) slug id, pointing the tables at the
  # wrong caption, or at none.
  page <- htmltools::tagList(
    govReactable(shinyGovstyle::transport_data, caption = "Table 1"),
    govReactable(shinyGovstyle::transport_data, caption = "Table 2"),
    govReactable(shinyGovstyle::transport_data, caption = "2025"),
    govReactable(shinyGovstyle::transport_data, caption = "Table 1")
  )

  links <- caption_links(page)
  expect_length(links$heading_ids, 4L)
  expect_false(anyDuplicated(links$heading_ids) > 0)
  expect_true(all(nzchar(links$heading_ids)))
  expect_identical(links$labelledby, links$heading_ids)
})

test_that("govReactable uses a supplied caption_id", {
  table <- govReactable(
    shinyGovstyle::transport_data,
    caption = "Transport data",
    caption_id = "transport-caption"
  )

  links <- caption_links(table)
  expect_identical(links$heading_ids, "transport-caption")
  expect_identical(links$labelledby, "transport-caption")
})

test_that("govReactable subtitle is part of the table's accessible name", {
  table <- govReactable(
    shinyGovstyle::transport_data,
    caption = "Costs peaked in March",
    subtitle = "Cost of bikes, vans and buses (£), January to May",
    caption_id = "costs"
  )

  heading <- find_tag_required(table, "govuk-heading-l")
  expect_identical(htmltools::tagGetAttribute(heading, "id"), "costs")
  expect_match(
    htmltools::tagGetAttribute(heading, "class"),
    "govuk-!-margin-bottom-1",
    fixed = TRUE
  )

  subtitle <- find_tag_required(table, "govuk-caption-m")
  expect_identical(subtitle$name, "p")
  expect_identical(htmltools::tagGetAttribute(subtitle, "id"), "costs-subtitle")
  expect_identical(
    tag_text(table, "govuk-caption-m"),
    "Cost of bikes, vans and buses (£), January to May"
  )

  expect_identical(caption_links(table)$labelledby, "costs costs-subtitle")
})

test_that("generated caption ids give each subtitle its own id", {
  page <- htmltools::tagList(
    govReactable(
      shinyGovstyle::transport_data,
      caption = "Table 1",
      subtitle = "Same subtitle"
    ),
    govReactable(
      shinyGovstyle::transport_data,
      caption = "Table 2",
      subtitle = "Same subtitle"
    )
  )

  subtitle_ids <- vapply(
    find_tags(page, "govuk-caption-m"),
    htmltools::tagGetAttribute,
    character(1),
    attr = "id",
    USE.NAMES = FALSE
  )
  expect_false(anyDuplicated(subtitle_ids) > 0)

  links <- caption_links(page)
  expect_identical(
    links$labelledby,
    paste(links$heading_ids, subtitle_ids)
  )
})

test_that("govReactable subtitle size follows caption_size", {
  xl_table <- govReactable(
    shinyGovstyle::transport_data,
    caption = "Headline",
    subtitle = "Subtitle",
    caption_size = "xl"
  )
  expect_has_tag(xl_table, "govuk-caption-l")

  for (size in c("l", "m", "s")) {
    table <- govReactable(
      shinyGovstyle::transport_data,
      caption = "Headline",
      subtitle = "Subtitle",
      caption_size = size
    )
    expect_has_tag(table, "govuk-caption-m")
  }
})

test_that("govReactable markup is unchanged without a subtitle", {
  table <- govReactable(
    shinyGovstyle::transport_data,
    caption = "Headline",
    caption_id = "headline"
  )
  expect_no_tag(table, "govuk-caption-m")
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag_required(table, "govuk-heading-l"),
      "class"
    ),
    "govuk-heading-l"
  )
  expect_identical(caption_links(table)$labelledby, "headline")
})

test_that("govReactable escapes a plain-text subtitle", {
  table <- govReactable(
    shinyGovstyle::transport_data,
    caption = "Headline",
    subtitle = "Bikes < buses"
  )
  html <- htmltools::renderTags(table)$html
  expect_match(html, ">Bikes &lt; buses</p>", fixed = TRUE)
})

test_that("govReactable subtitle needs a caption", {
  expect_error(
    govReactable(shinyGovstyle::transport_data, subtitle = "Subtitle"),
    "`subtitle` needs a `caption`",
    fixed = TRUE
  )
})

test_that("govReactable errors on an invalid subtitle", {
  for (bad in list("", NA_character_, c("a", "b"), 1)) {
    expect_error(
      govReactable(
        shinyGovstyle::transport_data,
        caption = "Headline",
        subtitle = bad
      ),
      "`subtitle` must be a single, non-empty string",
      fixed = TRUE
    )
  }
})

test_that("govReactable errors on an invalid caption_id", {
  for (bad_id in list("", "two words", NA_character_, c("a", "b"), 1)) {
    expect_error(
      govReactable(
        shinyGovstyle::transport_data,
        caption = "Transport data",
        caption_id = bad_id
      ),
      "`caption_id` must be a single, non-empty string with no spaces.",
      fixed = TRUE
    )
  }
})

test_that("govReactable escapes a plain-text caption", {
  table <- govReactable(
    shinyGovstyle::transport_data,
    caption = "Bikes < buses & vans"
  )

  html <- htmltools::renderTags(table)$html
  expect_match(html, ">Bikes &lt; buses &amp; vans</h2>", fixed = TRUE)
})

test_that("govReactable accepts tags and HTML as the caption", {
  tag_table <- govReactable(
    shinyGovstyle::transport_data,
    caption = shiny::tags$span("Transport ", shiny::tags$abbr("data"))
  )
  expect_has_tag(tag_table, "govuk-heading-l")
  expect_identical(unname(tag_text_by_name(tag_table, "abbr")), "data")

  html_table <- govReactable(
    shinyGovstyle::transport_data,
    caption = shiny::HTML("Transport <em>data</em>")
  )
  expect_identical(
    tag_text(html_table, "govuk-heading-l"),
    shiny::HTML("Transport <em>data</em>")
  )
})

test_that("govReactable errors on an invalid heading_level", {
  expect_error(
    govReactable(
      df = shinyGovstyle::transport_data,
      caption = "Transport data",
      heading_level = 0
    ),
    "heading_level must be an integer between 1 and 6"
  )
  expect_error(
    govReactable(
      df = shinyGovstyle::transport_data,
      caption = "Transport data",
      heading_level = 7
    ),
    "heading_level must be an integer between 1 and 6"
  )
})

test_that("govReactable errors on an invalid caption_size", {
  expect_error(
    govReactable(
      df = shinyGovstyle::transport_data,
      caption = "Transport data",
      caption_size = "xxl"
    ),
    "`caption_size` must be one of",
    fixed = TRUE
  )
})

# Column alignment by id, from the column definitions reactable will render
column_aligns <- function(table) {
  cols <- table$x$tag$attribs$columns
  stats::setNames(
    vapply(cols, function(col) col$align, character(1)),
    vapply(cols, function(col) col$id, character(1))
  )
}

test_that("govReactable right-aligns numeric columns by default", {
  df <- data.frame(
    region = c("North", "South"),
    count = c(1234L, 56L),
    percent = c(4.7, 12.34),
    cost = c("£85", "£75")
  )

  expect_identical(
    column_aligns(govReactable(df)),
    c(region = "left", count = "right", percent = "right", cost = "left")
  )
})

test_that("right_col right-aligns numbers stored as text", {
  df <- data.frame(region = c("North", "South"), cost = c("£85", "£75"))

  expect_identical(
    column_aligns(govReactable(df, right_col = "cost")),
    c(region = "left", cost = "right")
  )
})

test_that("columns can left-align a numeric column", {
  df <- data.frame(year = c(2024L, 2025L), count = c(1234L, 56L))

  table <- govReactable(
    df,
    columns = list(year = reactable::colDef(align = "left"))
  )

  expect_identical(
    column_aligns(table),
    c(year = "left", count = "right")
  )
})

test_that("govReactable accepts a columns argument without erroring", {
  # Regression test for #243: passing `columns` (the standard reactable way
  # to set per-column formatting) used to collide with govReactable's own
  # internal `columns` argument and throw:
  # "formal argument \"columns\" matched by multiple actual arguments"
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  expect_no_error(
    govReactable(
      df,
      columns = list(
        percent = reactable::colDef(
          format = reactable::colFormat(digits = 1)
        )
      )
    )
  )
})

test_that("columns argument merges user format over GOV.UK defaults", {
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  table <- govReactable(
    df,
    right_col = c("count", "percent"),
    columns = list(
      percent = reactable::colDef(
        format = reactable::colFormat(digits = 1)
      )
    )
  )

  percent_col <- table$x$tag$attribs$columns[[
    which(
      vapply(
        table$x$tag$attribs$columns,
        function(col) identical(col$id, "percent"),
        logical(1)
      )
    )
  ]]

  # User-supplied field is applied
  expect_identical(percent_col$format$cell$digits, 1L)

  # GOV.UK defaults survive for the same column, since the user's colDef
  # only set `format`
  expect_true(percent_col$sortable)
  expect_true(percent_col$html)
  expect_identical(percent_col$na, "NA")
  expect_identical(percent_col$align, "right")
  expect_identical(percent_col$headerClassName, "bar-sort-header")
})

test_that("columns argument only affects the named column", {
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  table <- govReactable(
    df,
    columns = list(
      percent = reactable::colDef(
        format = reactable::colFormat(digits = 1)
      )
    )
  )

  count_col <- table$x$tag$attribs$columns[[
    which(
      vapply(
        table$x$tag$attribs$columns,
        function(col) identical(col$id, "count"),
        logical(1)
      )
    )
  ]]

  expect_null(count_col$format)
})

test_that("columns argument merges user class/headerClass over defaults", {
  # Regression test: reactable::colDef() renames `class`, `headerClass`,
  # `footerClass`, and `defaultSortOrder` to `className`, `headerClassName`,
  # `footerClassName`, and `defaultSortDesc` respectively in its returned
  # object. Passing any of these through `columns` used to error with
  # "unused argument (headerClassName = ...)" because the already-renamed
  # field was fed back into reactable::colDef() as if it were an input
  # argument (#243).
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  table <- govReactable(
    df,
    columns = list(
      percent = reactable::colDef(
        class = "custom-percent-cell",
        headerClass = "custom-percent-header"
      )
    )
  )

  percent_col <- table$x$tag$attribs$columns[[
    which(
      vapply(
        table$x$tag$attribs$columns,
        function(col) identical(col$id, "percent"),
        logical(1)
      )
    )
  ]]

  # User-supplied renamed fields are applied under their *output* names
  expect_identical(percent_col$className, "custom-percent-cell")
  expect_identical(percent_col$headerClassName, "custom-percent-header")

  # GOV.UK defaults survive for fields the user didn't touch
  expect_true(percent_col$sortable)
  expect_identical(percent_col$na, "NA")
})

test_that("govReactable handles large tables", {
  # Unlike the static govTable(), reactable serialises the full dataset once
  # and paginates client-side, so it scales to far larger tables.
  n <- 100000L
  big_df <- data.frame(
    id = paste0("row", seq_len(n)),
    value = seq_len(n)
  )

  html <- htmltools::renderTags(govReactable(big_df))$html

  # The entire dataset is embedded in the payload, not truncated to a page.
  expect_match(html, paste0("row", n), fixed = TRUE)
})

test_that("govReactableOutput errors on invalid caption_size", {
  expect_error(
    govReactableOutput("table", caption = "Test", caption_size = "not a size")
  )
})

test_that("caption renders as heading text, defaulting to size l", {
  output <- govReactableOutput("table", caption = "Table caption")
  expect_identical(
    tag_text(output, "govuk-heading-l"),
    "Table caption"
  )
})

test_that("caption_size sets the heading size class", {
  output <- govReactableOutput("table", caption = "Test", caption_size = "m")
  expect_has_tag(output, "govuk-heading-m")
})

test_that("heading_level sets the caption's tag name", {
  output <- govReactableOutput("table", caption = "Test", heading_level = 3)
  heading <- find_tag_required(output, "govuk-heading-l")
  expect_identical(heading$name, "h3")
})
