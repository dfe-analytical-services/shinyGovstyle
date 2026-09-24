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
