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

test_that("supplied inputIDs are kept verbatim, including namespace and case", {
  ns <- shiny::NS("mod")
  nav <- service_navigation(
    c(
      "First page" = ns("first"),
      "Second page" = "m-second",
      "Third page" = "Third_Page",
      "Fourth page" = "sn.fourth"
    )
  )
  expect_identical(
    nav_link_ids(nav),
    c("mod-first", "m-second", "Third_Page", "sn.fourth")
  )
})

test_that("unnamed links get generated, normalised inputIDs", {
  nav <- service_navigation(c("Summary data", "Detailed-Stats 1"))
  expect_identical(nav_link_ids(nav), c("summary_data", "detailed_stats_1"))
})

test_that("in a partly named vector only unnamed links get generated ids", {
  nav <- service_navigation(c("Summary" = "Sum-Mary", "User guide"))
  expect_identical(nav_link_ids(nav), c("Sum-Mary", "user_guide"))
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
})

test_that("links must be non-empty strings", {
  expect_error(service_navigation(1:2), "character vector")
  expect_error(service_navigation(c("Page 1", NA)), "non-empty strings")
  expect_error(service_navigation(c("Page 1" = "")), "non-empty strings")
})

# Programmatic updates -----------------------------------------------------

mock_nav_session <- function(ns = shiny::NS(NULL)) {
  state <- new.env(parent = emptyenv())
  state$messages <- list()
  list(
    ns = ns,
    sendCustomMessage = function(type, message) {
      state$messages <- c(
        state$messages,
        list(list(type = type, message = message))
      )
      invisible(NULL)
    },
    messages = function() state$messages
  )
}

test_that("update_service_navigation sends the id unchanged at top level", {
  session <- mock_nav_session()
  update_service_navigation(session, "Mixed-Case_id")
  msgs <- session$messages()
  expect_length(msgs, 1)
  expect_identical(msgs[[1]]$type, "update_service_navigation")
  expect_identical(msgs[[1]]$message$id, "Mixed-Case_id")
})

test_that("update_service_navigation namespaces the id in a module session", {
  session <- mock_nav_session(shiny::NS("mod"))
  update_service_navigation(session, "Second")
  msg <- session$messages()[[1]]$message
  expect_identical(msg$id, "mod-Second")
  # The raw id is sent too, for a nav bar that sits outside the module
  expect_identical(msg$fallback, "Second")
})

test_that("module link clicks route through the namespaced link id", {
  sent <- new.env(parent = emptyenv())
  sent$ids <- character()
  sent$panels <- character()
  local_mocked_bindings(
    updateTabsetPanel = function(
      session,
      inputId, # nolint: object_name_linter.
      selected
    ) {
      sent$panels <- c(sent$panels, session$ns(inputId), selected)
      invisible(NULL)
    },
    .package = "shiny"
  )

  nav_module_server <- function(id) {
    shiny::moduleServer(id, function(input, output, session) {
      service_navigation_server(
        session,
        tabset_id = "tabs",
        link_to_panel = c("Second" = "panel_2")
      )
    })
  }

  # The UI a module would render: the id the browser sends back on click
  ui_ids <- nav_link_ids(
    service_navigation(c("Second page" = shiny::NS("mod", "Second")))
  )
  expect_identical(ui_ids, "mod-Second")

  shiny::testServer(nav_module_server, args = list(id = "mod"), {
    # Run the observers' initial (ignored) flush, as a browser session does
    # before any click, then click: it arrives as the module input "Second"
    session$flushReact()
    session$setInputs(Second = 1)
    expect_identical(sent$panels, c("mod-tabs", "panel_2"))
    expect_identical(session$ns("Second"), ui_ids)
  })
})
