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

# ids referenced by the textarea's aria-describedby, as a character vector
text_area2_described_by <- function() {
  ids <- app$get_js(
    paste0(
      "(document.getElementById('text_types-text_area2')",
      ".getAttribute('aria-describedby') || '')"
    )
  )
  strsplit(ids, "\\s+")[[1]]
}

test_that("Error ids join aria-describedby only while the error shows", {
  app$click("sn_text_types")
  app$wait_for_idle()

  # Hidden on load, so screen readers must not be pointed at it yet.
  expect_equal(
    text_area2_described_by(),
    c("text_types-text_area2-info", "text_types-text_area2-hint")
  )

  # Blank submit raises the error; raising it twice must not duplicate it.
  app$set_inputs(`text_types-text_area2` = "")
  app$click("text_types-btn_error")
  app$wait_for_idle()
  app$click("text_types-btn_error")
  app$wait_for_idle()
  expect_equal(
    text_area2_described_by(),
    c(
      "text_types-text_area2-info",
      "text_types-text_area2-hint",
      "text_types-text_area2-error"
    )
  )

  # Fixing the answer clears the error and its reference, keeping the rest.
  app$set_inputs(`text_types-text_area2` = "Fine thanks")
  app$click("text_types-btn_error")
  app$wait_for_idle()
  expect_equal(
    text_area2_described_by(),
    c("text_types-text_area2-info", "text_types-text_area2-hint")
  )
})
