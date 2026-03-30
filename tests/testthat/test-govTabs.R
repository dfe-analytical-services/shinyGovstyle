test_that("tabs works", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")

  expect_equal(length(tab_check$children[[2]]$children[[1]]), 4)

  expect_identical(
    tab_check$children[[3]][[1]][[1]][[1]][[2]][[2]]$class,
    "govuk-tabs__panel"
  )

  expect_identical(
    tab_check$children[[3]][[1]][[1]][[2]][[2]]$class,
    "govuk-tabs__panel govuk-tabs__panel--hidden"
  )
})

test_that("tabs have correct ARIA roles", {
  tab_check <- govTabs("tabsID", shinyGovstyle::case_data, "tabs")

  # Tab list (ul) should have role="tablist"
  tab_list <- tab_check$children[[2]]
  expect_identical(tab_list$attribs$role, "tablist")

  # Each tab list item (li) should have role="presentation"
  first_li <- tab_list$children[[1]][[1]]
  expect_identical(first_li$attribs$role, "presentation")

  # Each tab link (a) should have role="tab"
  first_tab_link <- first_li$children[[1]]
  expect_identical(first_tab_link$attribs$role, "tab")

  # First tab should have aria-selected="true"
  expect_identical(first_tab_link$attribs$`aria-selected`, "true")

  # First tab should have aria-controls matching panel id
  expect_identical(
    first_tab_link$attribs$`aria-controls`,
    sub("^#", "", first_tab_link$attribs$href)
  )

  # Second tab should have aria-selected="false"
  second_tab_link <- tab_list$children[[1]][[2]]$children[[1]]
  expect_identical(second_tab_link$attribs$`aria-selected`, "false")

  # Tab panels should have role="tabpanel" (accessed as plain list element)
  first_panel <- tab_check$children[[3]][[1]][[1]][[1]][[2]][[2]]
  expect_identical(first_panel$role, "tabpanel")

  # Tab panels should have aria-labelledby referencing the tab
  expect_true(!is.null(first_panel$`aria-labelledby`))
})
