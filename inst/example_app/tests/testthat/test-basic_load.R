app <- AppDriver$new(name = "example_app")

test_that("App loads and title of app appears as expected", {
  expect_equal(
    app$get_text("title"),
    "Select Types | shinyGovstyle"
  )
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
