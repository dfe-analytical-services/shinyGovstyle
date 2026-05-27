mock_session <- function() {
  state <- new.env(parent = emptyenv())
  state$messages <- list()
  list(
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

test_that("update_page_title sends the page_title only", {
  session <- mock_session()
  update_page_title(session, page_title = "Summary")
  msgs <- session$messages()
  expect_length(msgs, 1)
  expect_equal(msgs[[1]]$type, "update_page_title")
  expect_equal(msgs[[1]]$message, "Summary")
})

test_that("update_page_title composes '<page_title> | <service_name>'", {
  session <- mock_session()
  update_page_title(
    session,
    page_title = "Summary",
    service_name = "My service"
  )
  msgs <- session$messages()
  expect_length(msgs, 1)
  expect_equal(msgs[[1]]$message, "Summary | My service")
})

test_that("update_page_title treats empty service_name like NULL", {
  session <- mock_session()
  update_page_title(session, page_title = "Summary", service_name = "")
  msgs <- session$messages()
  expect_length(msgs, 1)
  expect_equal(msgs[[1]]$message, "Summary")
})

test_that("update_page_title runs without error for both call shapes", {
  session <- mock_session()
  expect_no_error(update_page_title(session, page_title = "Page"))
  expect_no_error(
    update_page_title(session, page_title = "Page", service_name = "Service")
  )
})

test_that("update_page_title errors on missing or empty page_title", {
  session <- mock_session()
  expect_error(update_page_title(session, page_title = NULL))
  expect_error(update_page_title(session, page_title = character(0)))
  expect_error(update_page_title(session, page_title = ""))
})
