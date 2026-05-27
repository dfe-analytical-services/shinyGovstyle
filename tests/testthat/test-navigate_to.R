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
    }
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
    }
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
    }
  )

  navigate_to(session = NULL, "main_panels", "summary")

  expect_equal(calls$tabset$inputId, "main_panels")
  expect_equal(calls$tabset$selected, "summary")
  expect_equal(calls$nav$inputId, "summary")
})

test_that("navigate_to calls updateTabsetPanel before service nav update", {
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
    }
  )

  navigate_to(session = NULL, "tabs", "page_two")

  expect_equal(state$order, c("tabset", "nav"))
})
