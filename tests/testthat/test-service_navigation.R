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
    observeEvent = function(eventExpr, handlerExpr, ...) {
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
