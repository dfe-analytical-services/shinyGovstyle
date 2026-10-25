test_that("service_navigation works", {
  expect_no_error(service_navigation(links = c("Page 1", "Page 2", "Page 3")))

  expect_no_error(
    service_navigation(
      service_name = "My app",
      c(
        "Page 1" = "p1",
        "Page 2" = "p2",
        "Page 3" = "p3"
      )
    )
  )

  expect_no_error(service_navigation("My app"))
})

test_that("service_navigation HTML is as expected", {
  local_edition(3)
  expect_snapshot(service_navigation(links = c("Page 1", "Page 2", "Page 3")))
  expect_snapshot(
    service_navigation(
      service_name = "My app",
      c(
        "Page 1" = "p1",
        "Page 2" = "p2",
        "Page 3" = "p3"
      )
    )
  )
})

test_that("service_navigation works with a single link", {
  expect_no_error(service_navigation(links = "Solo page"))
  local_edition(3)
  expect_snapshot(service_navigation(links = "Solo page"))
})

test_that("service_navigation errors with empty vector", {
  expect_error(service_navigation(links = character(0)))
})

test_that("service_navigation errors with NULL links", {
  expect_error(service_navigation(links = NULL))
})

test_that("service_navigation renders data-auto-page-title by default", {
  html <- as.character(service_navigation(links = c("Page 1", "Page 2")))
  expect_match(html, 'data-auto-page-title="true"', fixed = TRUE)
})

test_that("auto_page_title = FALSE omits the data attribute", {
  html <- as.character(
    service_navigation(
      links = c("Page 1", "Page 2"),
      auto_page_title = FALSE
    )
  )
  expect_false(grepl("data-auto-page-title", html, fixed = TRUE))
  expect_false(grepl("data-page-title-suffix", html, fixed = TRUE))
})

test_that("width defaults to standard, no three-quarters/full class", {
  nav <- service_navigation(links = c("Page 1", "Page 2"))
  container <- find_tag_required(nav, "govuk-width-container")
  expect_null(htmltools::tagGetAttribute(container, "style"))
  expect_no_tag(nav, "govuk-width-container--standard")
  expect_no_tag(nav, "govuk-width-container--three-quarters")
  expect_no_tag(nav, "govuk-width-container--full")
})

test_that("width = 'standard' explicitly still renders the standard class", {
  nav <- service_navigation(links = c("Page 1", "Page 2"), width = "standard")
  expect_has_tag(nav, "govuk-width-container--standard")
})

test_that("width = 'three-quarters' adds the three-quarters modifier class", {
  nav <- service_navigation(
    links = c("Page 1", "Page 2"),
    width = "three-quarters"
  )
  expect_has_tag(nav, "govuk-width-container--three-quarters")
})

test_that("a custom width sets an inline max-width style", {
  nav <- service_navigation(links = c("Page 1", "Page 2"), width = "90vw")
  container <- find_tag_required(nav, "govuk-width-container")
  expect_identical(
    htmltools::tagGetAttribute(container, "style"),
    "max-width: 90vw;"
  )
})

test_that("page_title_suffix is rendered to the data attribute", {
  html <- as.character(
    service_navigation(
      links = c("Page 1", "Page 2"),
      page_title_suffix = "My service"
    )
  )
  expect_match(html, 'data-page-title-suffix="My service"', fixed = TRUE)
})

test_that("page_title_suffix is dropped when auto_page_title is FALSE", {
  html <- as.character(
    service_navigation(
      links = c("Page 1", "Page 2"),
      auto_page_title = FALSE,
      page_title_suffix = "My service"
    )
  )
  expect_false(grepl("data-page-title-suffix", html, fixed = TRUE))
})

test_that("page_title_suffix = '' does not emit data-page-title-suffix", {
  html <- as.character(
    service_navigation(links = c("Page 1", "Page 2"), page_title_suffix = "")
  )
  expect_false(grepl("data-page-title-suffix", html, fixed = TRUE))
})

test_that("service_navigation_server errors on empty link_to_panel", {
  shiny::testServer(
    function(input, output, session) {
      expect_error(service_navigation_server(session, "tabs", character(0)))
      expect_error(service_navigation_server(session, "tabs", NULL))
    },
    expr = {}
  )
})

test_that("service_navigation_server errors on non-character link_to_panel", {
  shiny::testServer(
    function(input, output, session) {
      expect_error(service_navigation_server(session, "tabs", 1:3))
      expect_error(service_navigation_server(session, "tabs", list("a", "b")))
    },
    expr = {}
  )
})

test_that("service_navigation_server routes each link to its panel value", {
  calls <- new.env(parent = emptyenv())
  calls$panels <- character()
  local_mocked_bindings(
    updateTabsetPanel = function(
      session,
      inputId, # nolint: object_name_linter.
      selected
    ) {
      calls$panels <- c(calls$panels, selected)
      invisible(NULL)
    },
    .package = "shiny"
  )
  local_mocked_bindings(
    observeEvent = function(
      eventExpr, # nolint: object_name_linter.
      handlerExpr, # nolint: object_name_linter.
      ...
    ) {
      # Force the promise so each loop iteration's updateTabsetPanel call
      # fires immediately — sidesteps the need to drive the reactive loop.
      force(handlerExpr)
      invisible(NULL)
    },
    .package = "shiny"
  )

  shiny::testServer(
    function(input, output, session) {
      service_navigation_server(
        session,
        tabset_id = "tabs",
        link_to_panel = c(sn_a = "panel_a", sn_b = "panel_b")
      )
    },
    expr = {
      # One updateTabsetPanel call per link, in the order given. Catches
      # a regression where names/values get swapped or the wrong index
      # is used in the wiring loop.
      expect_equal(calls$panels, c("panel_a", "panel_b"))
    }
  )
})

test_that("service_navigation_server accepts unnamed link_to_panel (1:1)", {
  shiny::testServer(
    function(input, output, session) {
      service_navigation_server(
        session,
        tabset_id = "tabs",
        link_to_panel = c("panel_a", "panel_b")
      )
    },
    expr = {
      expect_no_error(session$setInputs(panel_a = 1))
    }
  )
})

# Link inputIDs ---------------------------------------------------------------

nav_link_ids <- function(nav) {
  links <- find_tags(nav, "govuk-service-navigation__link")
  ids <- vapply(
    links,
    function(link) {
      id <- htmltools::tagGetAttribute(link, "id")
      if (is.null(id)) NA_character_ else id
    },
    character(1)
  )
  # The service name link has no id, only the nav list links do
  ids[!is.na(ids)]
}

test_that("supplied inputIDs are cleaned up like generated ones", {
  nav <- service_navigation(
    c(
      "First page" = "first",
      "Second page" = "Page-Two",
      "Third page" = "Third_Page",
      "Fourth page" = "sn.fourth"
    )
  )
  expect_identical(
    nav_link_ids(nav),
    c("first", "page_two", "third_page", "sn_fourth")
  )
})

test_that("unnamed links get generated, normalised inputIDs", {
  nav <- service_navigation(c("Summary data", "Detailed-Stats 1"))
  expect_identical(nav_link_ids(nav), c("summary_data", "detailed_stats_1"))
})

test_that("in a partly named vector names set the link text", {
  nav <- service_navigation(c("Summary" = "Sum-Mary", "User guide"))
  expect_identical(nav_link_ids(nav), c("sum_mary", "user_guide"))
  expect_identical(
    vapply(
      find_tags(nav, "action-label"),
      function(x) {
        label <- tag_text(x, "action-label")
        # The active (first) link's text sits inside the fallback <strong>
        if (inherits(label, "shiny.tag")) {
          tag_text(label, "govuk-service-navigation__active-fallback")
        } else {
          label
        }
      },
      character(1)
    ),
    c("Summary", "User guide")
  )
})

test_that("duplicate inputIDs error with the repeated id", {
  expect_error(
    service_navigation(c("Page 1", "Page-1")),
    "unique inputID.*\"page_1\""
  )
  expect_error(
    service_navigation(c("A" = "same", "B" = "same")),
    "\"same\""
  )
  # Distinct supplied ids that clean up to the same id also clash
  expect_error(
    service_navigation(c("A" = "Page-Two", "B" = "page_two")),
    "\"page_two\""
  )
})

test_that("links must be non-empty strings", {
  expect_error(service_navigation(1:2), "character vector")
  expect_error(service_navigation(c("Page 1", NA)), "non-empty strings")
  expect_error(service_navigation(c("Page 1" = "")), "non-empty strings")
})

# Initial active link --------------------------------------------------------

test_that("the first link is the current page when the app loads", {
  nav <- service_navigation(c("Summary data", "User guide"))

  active_items <- find_tags(nav, "govuk-service-navigation__item--active")
  expect_length(active_items, 1)
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag_required(active_items[[1]], "govuk-service-navigation__link"),
      "id"
    ),
    "summary_data"
  )

  current_ids <- unlist(lapply(
    find_tags(nav, "govuk-service-navigation__link"),
    function(link) {
      if (identical(htmltools::tagGetAttribute(link, "aria-current"), "page")) {
        htmltools::tagGetAttribute(link, "id")
      }
    }
  ))
  expect_identical(current_ids, "summary_data")

  expect_length(
    find_tags(nav, "govuk-service-navigation__active-fallback"),
    1
  )
  expect_identical(
    tag_text(nav, "govuk-service-navigation__active-fallback"),
    "Summary data"
  )
})

# Service name link -----------------------------------------------------------

test_that("the service name is text, not a link, without service_url", {
  nav <- service_navigation(c("Page 1", "Page 2"), service_name = "My app")
  service_name <- find_tag_required(
    nav,
    "govuk-service-navigation__service-name"
  )
  expect_identical(
    tag_text(service_name, "govuk-service-navigation__text"),
    "My app"
  )
  expect_no_tag(service_name, "govuk-service-navigation__link")
  expect_false(grepl("href=", as.character(service_name), fixed = TRUE))
})

test_that("service_url makes the service name a link", {
  nav <- service_navigation(
    c("Page 1", "Page 2"),
    service_name = "My app",
    service_url = "/my-app/"
  )
  service_name <- find_tag_required(
    nav,
    "govuk-service-navigation__service-name"
  )
  link <- find_tag_required(service_name, "govuk-service-navigation__link")
  expect_identical(link$name, "a")
  expect_identical(htmltools::tagGetAttribute(link, "href"), "/my-app/")
  expect_identical(tag_text(link, "govuk-service-navigation__link"), "My app")
})

test_that("service_url must be a single, non-empty string", {
  for (bad in list("", NA_character_, c("/a", "/b"), 1)) {
    expect_error(
      service_navigation("Page 1", service_name = "App", service_url = bad),
      "`service_url` must be a single, non-empty string"
    )
  }
})

# Links to URLs ---------------------------------------------------------------

test_that("named values that are URLs become ordinary links", {
  nav <- service_navigation(c(
    "Summary" = "summary",
    "Guidance" = "https://www.gov.uk/guidance",
    "Help" = "/help",
    "Contact" = "mailto:team@example.gov.uk"
  ))
  links <- find_tags(nav, "govuk-service-navigation__link")
  hrefs <- vapply(
    links,
    function(link) {
      href <- htmltools::tagGetAttribute(link, "href")
      if (is.null(href)) NA_character_ else href
    },
    character(1)
  )
  # The in-app link keeps Shiny's actionLink href; URL links keep their URL
  expect_identical(
    hrefs[-1],
    c("https://www.gov.uk/guidance", "/help", "mailto:team@example.gov.uk")
  )
  # URL links are not Shiny inputs, so have no inputID or action-button class
  expect_identical(nav_link_ids(nav), "summary")
  expect_length(find_tags(nav, "action-button"), 1)
  expect_identical(
    vapply(
      links[-1],
      function(l) tag_text(l, "govuk-service-navigation__link"),
      character(1)
    ),
    c("Guidance", "Help", "Contact")
  )
})

test_that("a URL link is never the current page", {
  nav <- service_navigation(c(
    "Guidance" = "https://www.gov.uk/guidance",
    "Summary" = "summary"
  ))
  active_items <- find_tags(nav, "govuk-service-navigation__item--active")
  expect_length(active_items, 1)
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag_required(active_items[[1]], "govuk-service-navigation__link"),
      "id"
    ),
    "summary"
  )

  # With only URL links, nothing is current
  only_urls <- service_navigation(c("A" = "/a", "B" = "/b"))
  expect_no_tag(only_urls, "govuk-service-navigation__item--active")
})

test_that("a URL link needs link text", {
  expect_error(
    service_navigation(c("Summary", "https://www.gov.uk")),
    "need link text"
  )
})

test_that("URL links don't count towards duplicate inputIDs", {
  expect_no_error(
    service_navigation(c("A" = "/same", "B" = "/same", "Summary" = "summary"))
  )
})

# Programmatic updates -----------------------------------------------------

test_that("update_service_navigation sends the cleaned inputID", {
  state <- new.env(parent = emptyenv())
  state$messages <- list()
  session <- list(
    sendCustomMessage = function(type, message) {
      state$messages <- c(
        state$messages,
        list(list(type = type, message = message))
      )
      invisible(NULL)
    }
  )
  # Already-clean ids pass through unchanged
  update_service_navigation(session, "page_two")
  # Supplied ids are cleaned the same way service_navigation() cleans them
  update_service_navigation(session, "Page-Two")
  expect_length(state$messages, 2)
  expect_identical(state$messages[[1]]$type, "update_service_navigation")
  expect_identical(state$messages[[1]]$message, "page_two")
  expect_identical(state$messages[[2]]$message, "page_two")
})

# Server wiring with uncleaned inputIds ---------------------------------------

test_that("service_navigation_server cleans inputIds, not panel values", {
  calls <- new.env(parent = emptyenv())
  calls$panels <- character()
  local_mocked_bindings(
    updateTabsetPanel = function(
      session,
      inputId, # nolint: object_name_linter.
      selected
    ) {
      calls$panels <- c(calls$panels, selected)
      invisible(NULL)
    },
    .package = "shiny"
  )

  shiny::testServer(
    function(input, output, session) {
      service_navigation_server(
        session,
        tabset_id = "tabs",
        link_to_panel = c("Page-Two" = "Panel-2", "Page-Three")
      )
    },
    expr = {
      # Run the observers' initial (ignoreInit) pass before clicking
      session$flushReact()
      # The UI link for "Page-Two" has inputID page_two
      session$setInputs(page_two = 1)
      expect_identical(calls$panels, "Panel-2")

      # Unnamed: the cleaned id is watched, the raw value is the panel
      session$setInputs(page_three = 1)
      expect_identical(calls$panels, c("Panel-2", "Page-Three"))
    }
  )
})

# Following the tabset --------------------------------------------------------

# Runs service_navigation_server() with a session that records custom
# messages (MockShinySession drops them). Starts on the first panel, then
# moves to each of `tab_changes`. `ns` stands in for a module's namespace.
sync_messages <- function(
  link_to_panel,
  tab_changes = character(),
  ns = shiny::NS(NULL)
) {
  state <- new.env(parent = emptyenv())
  state$messages <- list()
  local_mocked_bindings(
    updateTabsetPanel = function(
      session,
      inputId, # nolint: object_name_linter.
      selected
    ) {
      invisible(NULL)
    },
    .package = "shiny"
  )

  shiny::testServer(
    function(input, output, session) {
      recording_session <- list(
        input = session$input,
        ns = ns,
        sendCustomMessage = function(type, message) {
          state$messages <- c(
            state$messages,
            list(list(type = type, message = message))
          )
          invisible(NULL)
        }
      )
      service_navigation_server(
        recording_session,
        tabset_id = "tabs",
        link_to_panel = link_to_panel
      )
    },
    expr = {
      for (panel in c(unname(link_to_panel[[1]]), tab_changes)) {
        session$setInputs(tabs = panel) # nolint: object_usage_linter.
      }
    }
  )
  state$messages
}

test_that("a programmatic tab change moves the active link to that panel", {
  messages <- sync_messages(
    c(sn_one = "one", sn_two = "two"),
    tab_changes = "two"
  )

  expect_length(messages, 1)
  expect_identical(messages[[1]]$type, "sync_service_navigation")
  expect_identical(messages[[1]]$message$tabset, "tabs")
  # A list, so one link is still a JSON array
  expect_identical(messages[[1]]$message$links, list("sn_two"))
})

test_that("the starting panel does not send a sync message", {
  messages <- sync_messages(c(sn_one = "one", sn_two = "two"))
  expect_length(messages, 0)
})

test_that("panels without a nav link send an empty sync to clear the nav", {
  messages <- sync_messages(
    c(sn_one = "one", sn_two = "two"),
    tab_changes = "accessibility_panel"
  )
  # Empty, so the browser clears the nav
  expect_length(messages, 1)
  expect_identical(messages[[1]]$type, "sync_service_navigation")
  expect_identical(messages[[1]]$message$links, list())
})

test_that("every link sharing a panel is sent, in link_to_panel order", {
  messages <- sync_messages(
    c(sn_one = "one", sn_two = "shared", sn_three = "shared"),
    tab_changes = "shared"
  )
  expect_identical(messages[[1]]$message$links, list("sn_two", "sn_three"))
})

test_that("synced links use the cleaned inputIDs", {
  messages <- sync_messages(
    c("Page-One" = "one", "Page-Two" = "Panel-2"),
    tab_changes = "Panel-2"
  )
  expect_identical(messages[[1]]$message$links, list("page_two"))
})

test_that("the synced tabset id is namespaced, as the browser sees it", {
  messages <- sync_messages(
    c(sn_one = "one", sn_two = "two"),
    tab_changes = "two",
    ns = shiny::NS("module")
  )
  expect_identical(messages[[1]]$message$tabset, "module-tabs")
})
