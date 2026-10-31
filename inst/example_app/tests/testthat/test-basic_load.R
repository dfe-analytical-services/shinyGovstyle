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

test_that("Colour filter updates the reactive table's caption", {
  app$click("sn_tables_tabs")
  app$wait_for_idle()

  caption_id <- "tables_tabs-interactive_table_test-caption"
  caption_js <- sprintf(
    "document.getElementById('%s').textContent",
    caption_id
  )
  expect_equal(app$get_js(caption_js), "Blue vehicles by month")

  app$set_inputs("tables_tabs-colourFilter" = "Red")
  app$wait_for_idle()
  expect_equal(app$get_js(caption_js), "Red vehicles by month")

  # The table region must still be labelled by the (updated) caption
  expect_equal(
    app$get_js(
      sprintf(
        "document.querySelector('[aria-labelledby=\"%s\"]') !== null",
        caption_id
      )
    ),
    TRUE
  )
})

test_that("Table titles include their subtitles in the accessible name", {
  app$click("sn_tables_tabs")
  app$wait_for_idle()

  # govTable: the subtitle sits inside the native <caption>. Whitespace is
  # collapsed as it is when browsers compute the accessible name.
  expect_equal(
    app$get_js(
      paste0(
        "document.querySelector('#tables_tabs-tab1 caption')",
        ".textContent.replace(/\\s+/g, ' ').trim()"
      )
    ),
    paste(
      "Bike and car costs were highest in March",
      "Cost of bikes and cars (£), January to March, example data"
    )
  )

  # Static govReactable: the region is labelled by the headline and subtitle
  expect_equal(
    app$get_js(
      paste0(
        "(() => {",
        "  const heading = [...document.querySelectorAll('h2')].find(",
        "    h => h.textContent === ",
        "      'Costs peaked in March for every vehicle type'",
        "  );",
        "  const region = document.querySelector(",
        "    '[aria-labelledby^=\"' + heading.id + ' \"]'",
        "  );",
        "  return region.getAttribute('aria-labelledby').split(' ')",
        "    .map(id => document.getElementById(id).textContent).join(' | ');",
        "})()"
      )
    ),
    paste(
      "Costs peaked in March for every vehicle type |",
      "Cost of bikes, vans and buses by vehicle colour (£),",
      "January to May, example data"
    )
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

test_that("govReactable sort buttons sort once per keypress (#190)", {
  app$click("sn_tables_tabs")
  app$wait_for_idle()

  header_js <- "document.querySelector('.gov-table .bar-sort-header')"
  aria_sort <- function() {
    app$get_js(paste0(header_js, ".getAttribute('aria-sort')"))
  }

  # The button is the only tab stop; the columnheader around it isn't one
  expect_equal(
    app$get_js(paste0(header_js, ".getAttribute('tabindex')")),
    "-1"
  )
  expect_equal(aria_sort(), "none")

  # Send real key events, so both reactable's keypress handler and the
  # button's own activation get the chance to fire. One sort step per key
  # proves govreactable.js stops the double toggle.
  chrome <- app$get_chromote_session()
  press_key <- function(key, code, key_code, text) {
    chrome$Input$dispatchKeyEvent(
      type = "keyDown",
      key = key,
      code = code,
      windowsVirtualKeyCode = key_code,
      text = text
    )
    chrome$Input$dispatchKeyEvent(
      type = "keyUp",
      key = key,
      code = code,
      windowsVirtualKeyCode = key_code
    )
  }

  app$run_js(
    "document.querySelector('.gov-table .gov-sort-button').focus()"
  )
  press_key("Enter", "Enter", 13, "\r")
  app$wait_for_idle()
  expect_equal(aria_sort(), "ascending")

  press_key(" ", "Space", 32, " ")
  app$wait_for_idle()
  expect_equal(aria_sort(), "descending")

  # A click on the button bubbles up to reactable's header click handler
  app$run_js(
    "document.querySelector('.gov-table .gov-sort-button').click()"
  )
  app$wait_for_idle()
  expect_equal(aria_sort(), "ascending")
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

test_that("Each summary list Change button sets its own input", {
  app$click("sn_feedback_types")
  app$wait_for_idle()

  app$click("feedback_types-sumID_name")
  app$wait_for_idle()
  app$click("feedback_types-sumID_date_of_birth")
  app$click("feedback_types-sumID_date_of_birth")
  app$wait_for_idle()

  expect_equal(
    as.integer(app$get_value(input = "feedback_types-sumID_name")),
    1L
  )
  expect_equal(
    as.integer(app$get_value(input = "feedback_types-sumID_date_of_birth")),
    2L
  )
})
