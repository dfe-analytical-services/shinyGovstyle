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

test_that("govReactable sets an accessible name matching the visible header", {
  # reactable defaults to aria-label "Sort {name}", mismatching the visible
  # header text and breaking voice control activation (WCAG 2.5.3, #190).
  table <- govReactable(df = shinyGovstyle::transport_data)
  expect_equal(table$x$tag$attribs$language$sortLabel, "{name}")
})

test_that("govReactable attaches the sort button script", {
  table <- govReactable(df = shinyGovstyle::transport_data)
  dep <- Filter(
    function(d) identical(d$name, "reactable-overrides"),
    table$dependencies
  )
  expect_length(dep, 1)
  expect_identical(dep[[1]]$script, "js/govreactable.js")
  expect_identical(dep[[1]]$stylesheet, "css/reactable-overrides.css")
})

test_that("sortable headers render as a native button (#190)", {
  # reactable's columnheader div has no button role, so screen readers don't
  # announce it as selectable and voice control can't target it.
  table <- govReactable(df = shinyGovstyle::transport_data)
  header <- find_reactable_col(table, "months")$header

  expect_identical(header$name, "button")
  expect_identical(header$attribs$type, "button")
  expect_identical(header$attribs$className, "gov-sort-button")
  expect_identical(header$children[[1]], "months")
})

test_that("govReactable keeps other language settings", {
  table <- govReactable(
    df = shinyGovstyle::transport_data,
    language = reactable::reactableLang(pageNext = "Nesaf")
  )
  language <- table$x$tag$attribs$language
  expect_identical(language$pageNext, "Nesaf")
  expect_identical(language$sortLabel, "{name}")
})

test_that("govReactable respects the reactable.language option", {
  old <- options(
    reactable.language = reactable::reactableLang(pagePrevious = "Blaenorol")
  )
  on.exit(options(old), add = TRUE)

  table <- govReactable(df = shinyGovstyle::transport_data)
  language <- table$x$tag$attribs$language
  expect_identical(language$pagePrevious, "Blaenorol")
  expect_identical(language$sortLabel, "{name}")
})

test_that("govReactable warns when a sortLabel is overridden", {
  expect_warning(
    table <- govReactable(
      df = shinyGovstyle::transport_data,
      language = reactable::reactableLang(sortLabel = "Sort by {name}")
    ),
    "ignores `sortLabel`"
  )
  expect_identical(table$x$tag$attribs$language$sortLabel, "{name}")
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

  percent_col <- find_reactable_col(table, "percent")

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

  count_col <- find_reactable_col(table, "count")

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

  percent_col <- find_reactable_col(table, "percent")

  # User-supplied renamed fields are applied under their *output* names. The
  # header class is added alongside the fixed sort header class (#190).
  expect_identical(percent_col$className, "custom-percent-cell")
  expect_identical(
    percent_col$headerClassName,
    "bar-sort-header custom-percent-header"
  )

  # GOV.UK defaults survive for fields the user didn't touch
  expect_true(percent_col$sortable)
  expect_identical(percent_col$na, "NA")
})

test_that("columns headerClass can't remove the sort indicator class", {
  # The permanent sort chevron and click target hang off bar-sort-header, so
  # a user's headerClass must not replace it (#190). Repeating the class
  # shouldn't duplicate it either.
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  table <- govReactable(
    df,
    columns = list(
      count = reactable::colDef(headerClass = "bar-sort-header extra")
    )
  )

  count_col <- find_reactable_col(table, "count")

  expect_identical(count_col$headerClassName, "bar-sort-header extra")
})

test_that("columns sortable = FALSE drops the sort indicator class", {
  # An unsortable column shouldn't show a sort chevron it can't act on.
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  table <- govReactable(
    df,
    columns = list(
      count = reactable::colDef(sortable = FALSE),
      percent = reactable::colDef(sortable = FALSE, headerClass = "extra")
    )
  )

  expect_false(find_reactable_col(table, "count")$sortable)
  expect_null(find_reactable_col(table, "count")$headerClassName)
  expect_identical(
    find_reactable_col(table, "percent")$headerClassName,
    "extra"
  )
})

test_that("columns sortable = FALSE drops the sort button", {
  df <- data.frame(count = c(1234, 56, 789), percent = c(4, 4.7, 12.34))

  table <- govReactable(
    df,
    columns = list(
      count = reactable::colDef(sortable = FALSE),
      percent = reactable::colDef(sortable = FALSE, header = "Percentage")
    )
  )

  # No custom header, so reactable shows the plain column name
  expect_null(find_reactable_col(table, "count")$header)
  # The user's own header is kept, without a button around it
  expect_identical(find_reactable_col(table, "percent")$header, "Percentage")
})

test_that("columns header strings and functions go inside the sort button", {
  df <- data.frame(
    count = c(1234, 56, 789),
    percent = c(4, 4.7, 12.34),
    rate = c(1, 2, 3)
  )

  table <- govReactable(
    df,
    columns = list(
      count = reactable::colDef(header = "Number of things"),
      percent = reactable::colDef(
        header = function(value) paste(value, "(%)")
      ),
      rate = reactable::colDef(
        header = function(value, name) paste0(value, " [", name, "]")
      )
    )
  )

  count_header <- find_reactable_col(table, "count")$header
  expect_identical(count_header$name, "button")
  expect_identical(count_header$attribs$className, "gov-sort-button")
  expect_identical(count_header$children[[1]], "Number of things")

  percent_header <- find_reactable_col(table, "percent")$header
  expect_identical(percent_header$name, "button")
  expect_identical(percent_header$children[[1]], "percent (%)")

  rate_header <- find_reactable_col(table, "rate")$header
  expect_identical(rate_header$name, "button")
  expect_identical(rate_header$children[[1]], "rate [rate]")
})

test_that("columns header set with JS() errors on a sortable column", {
  df <- data.frame(count = c(1234, 56, 789))

  expect_error(
    govReactable(
      df,
      columns = list(
        count = reactable::colDef(
          header = reactable::JS("function(column) { return column.name }")
        )
      )
    ),
    "can't add its accessible sort button to a JS\\(\\) header"
  )

  # Unsortable columns have no button, so a JS() header is fine there
  expect_no_error(
    govReactable(
      df,
      columns = list(
        count = reactable::colDef(
          sortable = FALSE,
          header = reactable::JS("function(column) { return column.name }")
        )
      )
    )
  )
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

test_that("heading_level defaults to an h2 caption", {
  output <- govReactableOutput("table", caption = "Test")
  heading <- find_tag_required(output, "govuk-heading-l")
  expect_identical(heading$name, "h2")
})

test_that("integer heading_level sets the caption's tag name", {
  for (level in 2:5) {
    output <- govReactableOutput(
      "table",
      caption = "Test",
      heading_level = level
    )
    heading <- find_tag_required(output, "govuk-heading-l")
    expect_identical(heading$name, paste0("h", level))
  }
  # Whole-number doubles are accepted too, e.g. heading_level = 3
  output <- govReactableOutput("table", caption = "Test", heading_level = 3)
  expect_identical(find_tag_required(output, "govuk-heading-l")$name, "h3")
})

test_that("string heading_level still works, with a warning to use integers", {
  for (level in 2:5) {
    legacy <- paste0("h", level)
    output <- expect_one_deprecation(
      govReactableOutput("table", caption = "Test", heading_level = legacy),
      mentions = c(
        "must be an integer",
        paste0("`heading_level = \"", legacy, "\"`"),
        paste0("`heading_level = ", level, "L`"),
        "1.0.0"
      )
    )
    heading <- find_tag_required(output, "govuk-heading-l")
    expect_identical(heading$name, legacy)
  }
})

test_that("invalid heading_level values error", {
  bad_levels <- list(1L, 6L, 2.5, "h1", "h6", "3", c(2L, 3L), NA_integer_, NULL)
  for (level in bad_levels) {
    expect_error(
      govReactableOutput("table", caption = "Test", heading_level = level),
      "`heading_level` must be a single integer from 2 to 5"
    )
  }
})
