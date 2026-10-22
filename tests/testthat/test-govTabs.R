test_that("tabs works", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")

  # One list item per tab in the source data
  expect_length(find_tags(tab_check, "govuk-tabs__list-item"), 4L)

  # The wrapper matches the GOV.UK tabs component and carries the inputId
  wrapper <- find_tag_required(tab_check, "govuk-tabs")
  expect_identical(htmltools::tagGetAttribute(wrapper, "id"), "tabsID")
})

test_that("only the first panel is visible on load", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")

  panels <- find_tags(tab_check, "govuk-tabs__panel")
  hidden <- vapply(
    panels,
    function(p) {
      "govuk-tabs__panel--hidden" %in%
        strsplit(htmltools::tagGetAttribute(p, "class"), "\\s+")[[1L]]
    },
    logical(1L)
  )
  expect_identical(hidden, c(FALSE, TRUE, TRUE, TRUE))

  # The visible panel is the one the selected tab controls
  selected <- find_tag_required(tab_check, "govuk-tabs__list-item--selected")
  selected_tab <- find_tag_required(selected, "govuk-tabs__tab")
  expect_identical(
    htmltools::tagGetAttribute(selected_tab, "aria-controls"),
    htmltools::tagGetAttribute(panels[[1L]], "id")
  )
  expect_length(find_tags(tab_check, "govuk-tabs__list-item--selected"), 1L)
})

test_that("tabs have correct ARIA roles", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")

  # Tab list (ul) should have role="tablist"
  tab_list <- find_tag_required(tab_check, "govuk-tabs__list")
  expect_identical(htmltools::tagGetAttribute(tab_list, "role"), "tablist")

  list_items <- find_tags(tab_check, "govuk-tabs__list-item")
  tab_links <- find_tags(tab_check, "govuk-tabs__tab")

  # Each tab list item (li) should have role="presentation"
  expect_identical(
    htmltools::tagGetAttribute(list_items[[1]], "role"),
    "presentation"
  )

  # Each tab link (a) should have role="tab"
  first_tab_link <- tab_links[[1]]
  expect_identical(htmltools::tagGetAttribute(first_tab_link, "role"), "tab")

  # First tab should have aria-selected="true"
  expect_identical(
    htmltools::tagGetAttribute(first_tab_link, "aria-selected"),
    "true"
  )

  # First tab should have aria-controls matching panel id
  expect_identical(
    htmltools::tagGetAttribute(first_tab_link, "aria-controls"),
    sub("^#", "", htmltools::tagGetAttribute(first_tab_link, "href"))
  )

  # First tab should have tabindex="0" (in tab order)
  expect_identical(htmltools::tagGetAttribute(first_tab_link, "tabindex"), "0")

  # Second tab should have aria-selected="false"
  second_tab_link <- tab_links[[2]]
  expect_identical(
    htmltools::tagGetAttribute(second_tab_link, "aria-selected"),
    "false"
  )

  # Second tab should have tabindex="-1" (removed from tab order)
  expect_identical(
    htmltools::tagGetAttribute(second_tab_link, "tabindex"),
    "-1"
  )

  # Tab panels should have role="tabpanel"
  first_panel <- find_tag(tab_check, "govuk-tabs__panel")
  expect_identical(htmltools::tagGetAttribute(first_panel, "role"), "tabpanel")
})

test_that("every tab and panel reference each other by id", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")
  tab_links <- find_tags(tab_check, "govuk-tabs__tab")
  panels <- find_tags(tab_check, "govuk-tabs__panel")
  expect_length(panels, length(tab_links))

  for (i in seq_along(tab_links)) {
    tab_id <- htmltools::tagGetAttribute(tab_links[[i]], "id")
    panel_id <- htmltools::tagGetAttribute(panels[[i]], "id")
    expect_identical(
      htmltools::tagGetAttribute(tab_links[[i]], "href"),
      paste0("#", panel_id)
    )
    expect_identical(
      htmltools::tagGetAttribute(tab_links[[i]], "aria-controls"),
      panel_id
    )
    expect_identical(
      htmltools::tagGetAttribute(panels[[i]], "aria-labelledby"),
      tab_id
    )
    expect_true(startsWith(tab_id, "tabsID-tab-"))
    expect_true(startsWith(panel_id, "tabsID-panel-"))
  }

  # The old document-wide name attributes are gone
  expect_null(htmltools::tagGetAttribute(tab_links[[1L]], "name"))
  expect_null(htmltools::tagGetAttribute(panels[[1L]], "name"))
})

test_that("two instances with the same data share no ids", {
  page <- htmltools::tagList(
    govTabs("first", shinyGovstyle::case_data, "tabs"),
    govTabs("second", shinyGovstyle::case_data, "tabs")
  )
  # Read every id from the rendered HTML so nothing is missed
  html <- as.character(page)
  ids <- regmatches(html, gregexpr('(?<= id=")[^"]+', html, perl = TRUE))[[1L]]
  # 2 wrappers + 2 x (4 tabs + 4 panels)
  expect_length(ids, 18L)
  expect_false(anyDuplicated(ids) > 0L)
})

test_that("rows within a panel keep their input order", {
  df <- data.frame(
    group = c("A", "B", "A", "A"),
    value = c("first", "only", "second", "third")
  )
  tab_check <- govTabs("order", df, "group")

  panel_a <- htmltools::tagQuery(tab_check)$find("#order-panel-a")
  cells <- panel_a$find(".govuk-table__cell")$selectedTags()
  expect_identical(
    unname(vapply(cells, function(x) x$children[[1L]], character(1L))),
    c("first", "second", "third")
  )
})

test_that("a single value column plus the group column works", {
  df <- data.frame(group = c("A", "B", "A"), value = c(1, 2, 3))
  tab_check <- govTabs("single", df, "group")

  headers <- find_tags(tab_check, "govuk-table__header")
  expect_identical(
    unname(vapply(headers, function(x) x$children[[1L]], character(1L))),
    c("value", "value")
  )
  panel_a <- htmltools::tagQuery(tab_check)$find("#single-panel-a")
  expect_length(panel_a$find(".govuk-table__row")$selectedTags(), 3L)
})

test_that("tab labels become unique, selector-safe ids", {
  df <- data.frame(
    group = c("Past day", "Past-day", "50% & over"),
    value = 1:3
  )
  tab_links <- find_tags(govTabs("x", df, "group"), "govuk-tabs__tab")
  expect_identical(
    vapply(
      tab_links,
      htmltools::tagGetAttribute,
      character(1L),
      attr = "id"
    ),
    c("x-tab-past-day", "x-tab-past-day-1", "x-tab-50-over")
  )
})
