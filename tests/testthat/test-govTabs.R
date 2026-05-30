test_that("tabs works", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")

  # One list item per tab in the source data
  expect_length(find_tags(tab_check, "govuk-tabs__list-item"), 4L)

  # The first panel is unhidden; every other panel keeps the --hidden token
  panels <- find_tags(tab_check, "govuk-tabs__panel")
  expect_identical(panels[[1]]$attribs$class, "govuk-tabs__panel")
  expect_length(find_tags(tab_check, "govuk-tabs__panel--hidden"), 3L)
})

test_that("tabs have correct ARIA roles", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")

  # Tab list (ul) should have role="tablist"
  tab_list <- find_tag_required(tab_check, "govuk-tabs__list")
  expect_identical(tab_list$attribs$role, "tablist")

  list_items <- find_tags(tab_check, "govuk-tabs__list-item")
  tab_links <- find_tags(tab_check, "govuk-tabs__tab")

  # Each tab list item (li) should have role="presentation"
  expect_identical(list_items[[1]]$attribs$role, "presentation")

  # Each tab link (a) should have role="tab"
  first_tab_link <- tab_links[[1]]
  expect_identical(first_tab_link$attribs$role, "tab")

  # First tab should have aria-selected="true"
  expect_identical(first_tab_link$attribs$`aria-selected`, "true")

  # First tab should have aria-controls matching panel id
  expect_identical(
    first_tab_link$attribs$`aria-controls`,
    sub("^#", "", first_tab_link$attribs$href)
  )

  # First tab should have tabindex="0" (in tab order)
  expect_identical(first_tab_link$attribs$tabindex, "0")

  # Second tab should have aria-selected="false"
  second_tab_link <- tab_links[[2]]
  expect_identical(second_tab_link$attribs$`aria-selected`, "false")

  # Second tab should have tabindex="-1" (removed from tab order)
  expect_identical(second_tab_link$attribs$tabindex, "-1")

  # Tab panels should have role="tabpanel"
  first_panel <- find_tag(tab_check, "govuk-tabs__panel")
  expect_identical(first_panel$attribs$role, "tabpanel")

  # Tab panels should have aria-labelledby referencing the tab
  expect_true(!is.null(first_panel$attribs$`aria-labelledby`))
})
