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

# id or tag name of the focused element, e.g. "H1#..." or "BODY"
focused <- function() {
  app$get_js(
    paste0(
      "(function (el) { return el.tagName + (el.id ? '#' + el.id : ''); })",
      "(document.activeElement)"
    )
  )
}

# text of the focused element
focused_text <- function() {
  app$get_js("document.activeElement.textContent.trim()")
}

test_that("Next button moves focus to the new panel's heading", {
  app$click("sn_select_types")
  app$wait_for_idle()

  app$run_js("document.getElementById('select_types-text_types_next').focus()")
  app$click("select_types-text_types_next")
  app$wait_for_idle()
  app$wait_for_js("document.activeElement.tagName === 'H1'", timeout = 5000)

  expect_equal(app$get_js("document.activeElement.tagName"), "H1")
  expect_equal(focused_text(), "Text Types")
  expect_equal(
    app$get_js(
      paste0(
        "document.activeElement.closest('.tab-pane')",
        ".getAttribute('data-value')"
      )
    ),
    "text_types"
  )
  expect_equal(app$get_js("document.activeElement.tabIndex"), -1L)
})

test_that("Back link moves focus to the previous panel's heading", {
  app$click("text_types-select_types_back")
  app$wait_for_idle()
  app$wait_for_js(
    "document.activeElement.textContent.trim() === 'Select Types'",
    timeout = 5000
  )
  expect_equal(app$get_js("document.activeElement.tagName"), "H1")
})

test_that("Footer cookies link moves focus to the cookies heading", {
  app$click("cookies_footer_link")
  app$wait_for_idle()
  app$wait_for_js(
    "document.activeElement.textContent.trim() === 'Cookies'",
    timeout = 5000
  )
  expect_equal(app$get_js("document.activeElement.tagName"), "H1")
})

test_that("Accepting cookies moves focus to the confirmation alert", {
  app$click("cookieAccept")
  app$wait_for_idle()
  app$wait_for_js(
    "document.activeElement.id === 'cookieAcceptDiv'",
    timeout = 5000
  )
  expect_equal(focused(), "DIV#cookieAcceptDiv")
  expect_equal(
    app$get_js("document.activeElement.getAttribute('role')"),
    "alert"
  )

  # Hiding the message moves focus on to the main content
  app$click("hideAccept")
  app$wait_for_idle()
  app$wait_for_js("document.activeElement.id === 'main'", timeout = 5000)
  expect_equal(focused(), "MAIN#main")
})
