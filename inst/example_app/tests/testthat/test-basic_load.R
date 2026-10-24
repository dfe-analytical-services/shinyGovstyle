app <- AppDriver$new(name = "example_app")

# ids of the nav links marked as the current page
current_links <- function() {
  unlist(app$get_js(
    paste0(
      "Array.from(document.querySelectorAll(",
      "'.govuk-service-navigation__link[aria-current=\"page\"]'",
      ")).map(function (a) { return a.id; })"
    )
  ))
}

# ids of the nav links holding the GOV.UK active-fallback <strong>
fallback_links <- function() {
  unlist(app$get_js(
    paste0(
      "Array.from(document.querySelectorAll(",
      "'.govuk-service-navigation__active-fallback'",
      ")).map(function (s) {",
      " return s.closest('.govuk-service-navigation__link').id; })"
    )
  ))
}

test_that("App loads and title of app appears as expected", {
  expect_equal(
    app$get_text("title"),
    "Select Types | shinyGovstyle"
  )
})

test_that("The first nav link is the current page on load", {
  expect_equal(current_links(), "sn_select_types")
  expect_equal(fallback_links(), "sn_select_types")
})

test_that("Browser tab title updates when a nav link is clicked", {
  app$click("sn_text_types")
  app$wait_for_idle()
  expect_equal(
    app$get_js("document.title"),
    "Text Types | shinyGovstyle"
  )

  app$click("sn_feedback_types")
  app$wait_for_idle()
  expect_equal(
    app$get_js("document.title"),
    "Feedback types | shinyGovstyle"
  )
})

test_that("Footer cookies link sets the title via nav-link sync", {
  app$click("cookies_footer_link")
  app$wait_for_idle()
  expect_equal(
    app$get_js("document.title"),
    "Cookies | shinyGovstyle"
  )
})

test_that("Next button switches the panel and updates the title", {
  # Start from a known page so the next button is reachable.
  app$click("sn_select_types")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "tab-container"), "select_types")

  # The in-module next button uses navigate_to() with mismatched
  # inputId/panel value — this guards against regressing back to a state
  # where only the nav highlight and title update.
  app$click("select_types-text_types_next")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "tab-container"), "text_types")
  expect_equal(
    app$get_js("document.title"),
    "Text Types | shinyGovstyle"
  )
})

test_that("Cookie banner link switches to the cookies panel", {
  app$click("cookieLink")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "tab-container"), "panel-cookies")
  expect_equal(
    app$get_js("document.title"),
    "Cookies | shinyGovstyle"
  )
})

test_that("Active nav link is exposed to screen readers via aria-current", {
  # Direct click
  app$click("sn_action_types")
  app$wait_for_idle()
  expect_equal(current_links(), "sn_action_types")
  expect_equal(fallback_links(), "sn_action_types")

  # Programmatic navigation (navigate_to() -> update_service_navigation())
  app$click("cookies_footer_link")
  app$wait_for_idle()
  expect_equal(current_links(), "sn_cookies")
  expect_equal(fallback_links(), "sn_cookies")
})

# The visible govTabs table's scroll container, if it is currently focusable
visible_focusable_scroll <- paste0(
  "document.querySelector('",
  ".govuk-tabs__panel:not(.govuk-tabs__panel--hidden) ",
  ".shinygovstyle-table-scroll[tabindex]')"
)

# Scroll container state for the visible govTabs table, plus page overflow
table_scroll_state <- function() {
  app$get_js(
    paste0(
      "(function () {",
      " var c = Array.from(document.querySelectorAll(",
      "'.govuk-tabs__panel .shinygovstyle-table-scroll'",
      ")).find(function (e) { return e.offsetParent !== null; });",
      " return {",
      " tabindex: c.getAttribute('tabindex'),",
      " role: c.getAttribute('role'),",
      " labelledby: c.getAttribute('aria-labelledby'),",
      " pageOverflows: document.documentElement.scrollWidth >",
      " document.documentElement.clientWidth };",
      "})()"
    )
  )
}

test_that("Wide tables scroll in a keyboard-reachable region on phones", {
  app$click("sn_tables_tabs")
  app$wait_for_idle()

  # At 320px the govTabs table is wider than the screen: it scrolls inside
  # its container, which becomes a named, focusable region
  app$set_window_size(width = 320, height = 800)
  app$wait_for_js(paste(visible_focusable_scroll, "!== null"))
  state <- table_scroll_state()
  expect_identical(state$tabindex, "0")
  expect_identical(state$role, "region")
  expect_identical(state$labelledby, "tables_tabs-govTabs-heading-past-day")
  expect_false(state$pageOverflows)

  # At desktop width the table fits, so there is no extra tab stop
  app$set_window_size(width = 1200, height = 800)
  app$wait_for_js(paste(visible_focusable_scroll, "=== null"))
  state <- table_scroll_state()
  expect_null(state$tabindex)
  expect_null(state$role)
  expect_null(state$labelledby)
})

# ids of the visible panels in the govTabs with this id
visible_tab_panels <- function(tabs_id) {
  unlist(app$get_js(
    paste0(
      "Array.from(document.getElementById('",
      tabs_id,
      "')",
      ".querySelectorAll('.govuk-tabs__panel'))",
      ".filter(function (p) { return p.offsetParent !== null; })",
      ".map(function (p) { return p.id; })"
    )
  ))
}

# ids of the tabs marked aria-selected in the govTabs with this id
selected_tabs <- function(tabs_id) {
  unlist(app$get_js(
    paste0(
      "Array.from(document.getElementById('",
      tabs_id,
      "')",
      ".querySelectorAll('.govuk-tabs__tab[aria-selected=\"true\"]'))",
      ".map(function (a) { return a.id; })"
    )
  ))
}

test_that("govTabs show the first panel and switch independently", {
  app$click("sn_tables_tabs")
  app$wait_for_idle()

  first <- "tables_tabs-govTabs"
  second <- "tables_tabs-govTabs2"

  # The first panel of each instance is visible on load
  expect_equal(visible_tab_panels(first), paste0(first, "-panel-past-day"))
  expect_equal(visible_tab_panels(second), paste0(second, "-panel-past-day"))

  # Switching tabs in the second instance leaves the first unchanged
  app$click(selector = paste0("#", second, "-tab-past-week"))
  app$wait_for_idle()
  expect_equal(visible_tab_panels(second), paste0(second, "-panel-past-week"))
  expect_equal(selected_tabs(second), paste0(second, "-tab-past-week"))
  expect_equal(visible_tab_panels(first), paste0(first, "-panel-past-day"))
  expect_equal(selected_tabs(first), paste0(first, "-tab-past-day"))

  # Arrow keys move within the focused instance only
  app$run_js(paste0(
    "var t = document.getElementById('",
    first,
    "-tab-past-day');",
    "t.focus();",
    "t.dispatchEvent(new KeyboardEvent('keydown',",
    " { key: 'ArrowLeft', bubbles: true }));"
  ))
  app$wait_for_idle()
  expect_equal(visible_tab_panels(first), paste0(first, "-panel-past-year"))
  expect_equal(selected_tabs(first), paste0(first, "-tab-past-year"))
  expect_equal(visible_tab_panels(second), paste0(second, "-panel-past-week"))
})
