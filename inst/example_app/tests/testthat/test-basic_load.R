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
