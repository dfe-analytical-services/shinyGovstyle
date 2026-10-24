# Stand-in for a Shiny session that records custom messages by type
fake_session <- function(calls, ns = shiny::NS(NULL)) {
  calls$messages <- list()
  list(
    ns = ns,
    sendCustomMessage = function(type, message) {
      calls$messages[[type]] <- message
      invisible(NULL)
    }
  )
}

test_that("navigate_to switches the tabset to the requested panel", {
  calls <- new.env(parent = emptyenv())
  local_mocked_bindings(
    updateTabsetPanel = function(
      session,
      inputId, # nolint: object_name_linter.
      selected
    ) {
      calls$tabset <- list(inputId = inputId, selected = selected)
      invisible(NULL)
    },
    .package = "shiny"
  )
  local_mocked_bindings(
    update_service_navigation = function(
      session,
      inputId # nolint: object_name_linter.
    ) {
      calls$nav <- list(inputId = inputId)
      invisible(NULL)
    },
    focus_panel = function(session, tabset_id, panel) invisible(NULL)
  )

  navigate_to(session = NULL, "tabs", "page_two")

  expect_equal(calls$tabset$inputId, "tabs")
  expect_equal(calls$tabset$selected, "page_two")
})

test_that("navigate_to updates the active service nav link", {
  calls <- new.env(parent = emptyenv())
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
  local_mocked_bindings(
    update_service_navigation = function(
      session,
      inputId # nolint: object_name_linter.
    ) {
      calls$nav <- list(inputId = inputId)
      invisible(NULL)
    },
    focus_panel = function(session, tabset_id, panel) invisible(NULL)
  )

  navigate_to(session = NULL, "tabs", "page_two")

  expect_equal(calls$nav$inputId, "page_two")
})

test_that("navigate_to passes the supplied tabset_id and inputId through", {
  calls <- new.env(parent = emptyenv())
  local_mocked_bindings(
    updateTabsetPanel = function(
      session,
      inputId, # nolint: object_name_linter.
      selected
    ) {
      calls$tabset <- list(inputId = inputId, selected = selected)
      invisible(NULL)
    },
    .package = "shiny"
  )
  local_mocked_bindings(
    update_service_navigation = function(
      session,
      inputId # nolint: object_name_linter.
    ) {
      calls$nav <- list(inputId = inputId)
      invisible(NULL)
    },
    focus_panel = function(session, tabset_id, panel) invisible(NULL)
  )

  navigate_to(session = NULL, "main_panels", "summary")

  expect_equal(calls$tabset$inputId, "main_panels")
  expect_equal(calls$tabset$selected, "summary")
  expect_equal(calls$nav$inputId, "summary")
})

test_that("navigate_to switches the panel and nav before moving focus", {
  state <- new.env(parent = emptyenv())
  state$order <- character()
  local_mocked_bindings(
    updateTabsetPanel = function(
      session,
      inputId, # nolint: object_name_linter.
      selected
    ) {
      state$order <- c(state$order, "tabset")
      invisible(NULL)
    },
    .package = "shiny"
  )
  local_mocked_bindings(
    update_service_navigation = function(
      session,
      inputId # nolint: object_name_linter.
    ) {
      state$order <- c(state$order, "nav")
      invisible(NULL)
    },
    focus_panel = function(session, tabset_id, panel) {
      state$order <- c(state$order, "focus")
      invisible(NULL)
    }
  )

  navigate_to(session = NULL, "tabs", "page_two")

  expect_equal(state$order, c("tabset", "nav", "focus"))
})

test_that("navigate_to cleans the nav inputId but not the panel value", {
  calls <- new.env(parent = emptyenv())
  local_mocked_bindings(
    updateTabsetPanel = function(
      session,
      inputId, # nolint: object_name_linter.
      selected
    ) {
      calls$selected <- selected
      invisible(NULL)
    },
    .package = "shiny"
  )
  session <- fake_session(calls)

  navigate_to(session, "tabs", "Page-Two")

  expect_identical(calls$selected, "Page-Two")
  expect_identical(calls$messages$update_service_navigation, "page_two")
  expect_identical(
    calls$messages$shinygovstyle_focus_panel$panel,
    "Page-Two"
  )
})

test_that("navigate_to asks the browser to focus the new panel", {
  calls <- new.env(parent = emptyenv())
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

  navigate_to(fake_session(calls), "tabs", "sn_cookies", panel = "cookies")

  expect_identical(
    calls$messages$shinygovstyle_focus_panel,
    list(tabset_id = "tabs", panel = "cookies")
  )
})

test_that("navigate_to namespaces the tabset id in the focus message", {
  calls <- new.env(parent = emptyenv())
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

  session <- fake_session(calls, ns = shiny::NS("mod"))
  navigate_to(session, "tabs", "page_two")

  expect_identical(
    calls$messages$shinygovstyle_focus_panel$tabset_id,
    "mod-tabs"
  )
})

test_that("navigate_to(focus = FALSE) leaves focus alone", {
  calls <- new.env(parent = emptyenv())
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

  navigate_to(fake_session(calls), "tabs", "page_two", focus = FALSE)

  expect_identical(calls$messages$update_service_navigation, "page_two")
  expect_null(calls$messages$shinygovstyle_focus_panel)
})

test_that("focus_management.js handles the message navigate_to() sends", {
  js_path <- system.file(
    "www",
    "js",
    "focus_management.js",
    package = "shinyGovstyle"
  )
  expect_true(file.exists(js_path))
  js <- paste(readLines(js_path, warn = FALSE), collapse = "\n")

  expect_match(
    js,
    'Shiny\\.addCustomMessageHandler\\(\\s*"shinygovstyle_focus_panel"',
    perl = TRUE
  )
})

test_that("the focus handler ships with every shinyGovstyle component", {
  # navigate_to() can be used without service_navigation(), so the handler
  # is a base dependency rather than a service navigation one
  deps <- htmltools::findDependencies(gov_main_layout("content"))
  scripts <- unlist(lapply(deps, function(d) d$script))
  expect_true("focus_management.js" %in% scripts)
})
