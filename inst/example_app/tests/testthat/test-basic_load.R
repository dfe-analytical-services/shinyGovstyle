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

test_that("A tab change outside the nav moves the active link and title", {
  app$click("sn_select_types")
  app$wait_for_idle()
  expect_equal(current_links(), "sn_select_types")

  # Change the tab directly, as updateTabsetPanel() would
  app$set_inputs(`tab-container` = "feedback_types")
  app$wait_for_idle()
  expect_equal(current_links(), "sn_feedback_types")
  expect_equal(fallback_links(), "sn_feedback_types")
  expect_equal(
    app$get_js("document.title"),
    "Feedback types | shinyGovstyle"
  )
})

# Replays a message from the server, so a test can recreate the order Shiny
# sends them in: custom messages straight away, tab changes at the end
server_message <- function(message) {
  app$run_js(
    paste0(
      "Shiny.shinyapp.dispatchMessage(",
      jsonlite::toJSON(
        as.character(jsonlite::toJSON(message, auto_unbox = TRUE)),
        auto_unbox = TRUE
      ),
      ");"
    )
  )
}

test_that("navigate_to() the current panel doesn't pin the nav later on", {
  app$click("cookies_footer_link")
  app$wait_for_idle()
  # Already on cookies, so the tab doesn't change and no sync follows
  app$click("cookies_footer_link")
  app$wait_for_idle()

  app$set_inputs(`tab-container` = "feedback_types")
  app$wait_for_idle()
  expect_equal(current_links(), "sn_feedback_types")
  expect_equal(
    app$get_js("document.title"),
    "Feedback types | shinyGovstyle"
  )
})

test_that("a title set without a tab change isn't kept for a later one", {
  app$click("sn_select_types")
  app$wait_for_idle()
  # update_page_title() on its own, e.g. after a filter changes
  server_message(list(custom = list(update_page_title = "Filtered")))

  app$set_inputs(`tab-container` = "feedback_types")
  app$wait_for_idle()
  expect_equal(
    app$get_js("document.title"),
    "Feedback types | shinyGovstyle"
  )
})

test_that("a title set with the tab change is kept", {
  app$click("sn_select_types")
  app$wait_for_idle()
  # update_page_title() and updateTabsetPanel() in one observer
  server_message(list(custom = list(update_page_title = "Custom title")))
  server_message(list(
    inputMessages = list(
      list(id = "tab-container", message = list(value = "feedback_types"))
    )
  ))
  app$wait_for_idle()
  expect_equal(app$get_value(input = "tab-container"), "feedback_types")
  expect_equal(current_links(), "sn_feedback_types")
  expect_equal(app$get_js("document.title"), "Custom title")
})

test_that("update_service_navigation() with the tab change is kept", {
  app$click("sn_select_types")
  app$wait_for_idle()
  # e.g. keeping a parent link active on a sub-page
  server_message(list(
    custom = list(update_service_navigation = "sn_cookies")
  ))
  server_message(list(
    inputMessages = list(
      list(id = "tab-container", message = list(value = "text_types"))
    )
  ))
  app$wait_for_idle()
  expect_equal(app$get_value(input = "tab-container"), "text_types")
  expect_equal(current_links(), "sn_cookies")
})
