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
      function(x) tag_text(x, "action-label"),
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

# Programmatic updates -----------------------------------------------------

test_that("update_service_navigation sends the id unchanged", {
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
  update_service_navigation(session, "page_two")
  expect_length(state$messages, 1)
  expect_identical(state$messages[[1]]$type, "update_service_navigation")
  expect_identical(state$messages[[1]]$message, "page_two")
})
