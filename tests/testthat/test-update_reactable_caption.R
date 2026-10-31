# Same recording mock as test-update_page_title.R, plus an `ns` so the module
# case can be exercised: shiny::NS(NULL) is a no-op like a top-level session,
# shiny::NS("mod") prefixes like a moduleServer() session.
mock_session <- function(namespace = NULL) {
  state <- new.env(parent = emptyenv())
  state$messages <- list()
  list(
    ns = shiny::NS(namespace),
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

# The updates sent in the `n`th message.
sent_updates <- function(session, n = 1L) {
  session$messages()[[n]]$message$updates
}

test_that("update_reactable_caption targets govReactableOutput's caption", {
  session <- mock_session()
  update_reactable_caption(session, "table", "Red vehicles by month")

  msgs <- session$messages()
  expect_length(msgs, 1)
  expect_identical(msgs[[1]]$type, "update_reactable_caption")

  updates <- sent_updates(session)
  expect_length(updates, 1)
  expect_identical(updates[[1]]$id, "table-caption")
  expect_identical(updates[[1]]$html, "Red vehicles by month")

  # The id must be the one govReactableOutput() gave the heading
  heading <- find_tag_required(
    govReactableOutput("table", caption = "Blue vehicles by month"),
    "govuk-heading-l"
  )
  expect_identical(htmltools::tagGetAttribute(heading, "id"), updates[[1]]$id)
})

test_that("update_reactable_caption targets govReactableOutput's subtitle", {
  session <- mock_session()
  update_reactable_caption(session, "table", subtitle = "Red vehicles (£)")

  updates <- sent_updates(session)
  expect_length(updates, 1)
  expect_identical(updates[[1]]$id, "table-subtitle")
  expect_identical(updates[[1]]$html, "Red vehicles (£)")

  subtitle <- find_tag_required(
    govReactableOutput(
      "table",
      caption = "Costs peaked in March",
      subtitle = "Blue vehicles (£)"
    ),
    "govuk-caption-m"
  )
  expect_identical(htmltools::tagGetAttribute(subtitle, "id"), updates[[1]]$id)
})

test_that("update_reactable_caption sends caption and subtitle together", {
  session <- mock_session()
  update_reactable_caption(
    session,
    "table",
    caption = "Red costs peaked in March",
    subtitle = "Red vehicles (£)"
  )

  expect_length(session$messages(), 1)
  updates <- sent_updates(session)
  expect_identical(
    vapply(updates, `[[`, character(1), "id"),
    c("table-caption", "table-subtitle")
  )
})

test_that("update_reactable_caption applies the module namespace", {
  session <- mock_session("mod")
  update_reactable_caption(
    session,
    "table",
    caption = "Red vehicles by month",
    subtitle = "Red vehicles (£)"
  )

  updates <- sent_updates(session)
  expect_identical(
    vapply(updates, `[[`, character(1), "id"),
    c("mod-table-caption", "mod-table-subtitle")
  )

  # Matches the UI side, where the module namespaces the output id
  output_tag <- govReactableOutput(
    shiny::NS("mod", "table"),
    caption = "Blue vehicles",
    subtitle = "Blue vehicles (£)"
  )
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag_required(output_tag, "govuk-heading-l"),
      "id"
    ),
    updates[[1]]$id
  )
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag_required(output_tag, "govuk-caption-m"),
      "id"
    ),
    updates[[2]]$id
  )
})

test_that("update_reactable_caption escapes plain text", {
  session <- mock_session()
  update_reactable_caption(
    session,
    "table",
    caption = "<img src=x onerror=alert(1)>",
    subtitle = "Bikes < buses"
  )

  updates <- sent_updates(session)
  expect_identical(updates[[1]]$html, "&lt;img src=x onerror=alert(1)&gt;")
  expect_identical(updates[[2]]$html, "Bikes &lt; buses")
})

test_that("update_reactable_caption passes HTML() and tags through", {
  session <- mock_session()
  update_reactable_caption(session, "table", shiny::HTML("Red <em>vans</em>"))
  update_reactable_caption(
    session,
    "table",
    shiny::tags$span("Red ", shiny::tags$abbr("HGVs"))
  )

  expect_identical(sent_updates(session, 1)[[1]]$html, "Red <em>vans</em>")
  expect_identical(
    sent_updates(session, 2)[[1]]$html,
    "<span>\n  Red \n  <abbr>HGVs</abbr>\n</span>"
  )
})

test_that("update_reactable_caption errors on an invalid output_table_name", {
  session <- mock_session()
  for (bad in list("", NA_character_, c("a", "b"), 1, NULL)) {
    expect_error(
      update_reactable_caption(session, bad, "Caption"),
      "`output_table_name` must be a single, non-empty string.",
      fixed = TRUE
    )
  }
  expect_length(session$messages(), 0)
})

test_that("update_reactable_caption needs a caption or a subtitle", {
  session <- mock_session()
  expect_error(
    update_reactable_caption(session, "table"),
    "Supply a `caption`, a `subtitle`, or both to update.",
    fixed = TRUE
  )
  expect_length(session$messages(), 0)
})

test_that("update_reactable_caption errors on an invalid caption/subtitle", {
  session <- mock_session()
  for (bad in list("", NA_character_, c("a", "b"), 1)) {
    expect_error(
      update_reactable_caption(session, "table", caption = bad),
      "`caption` must be a single, non-empty string",
      fixed = TRUE
    )
    expect_error(
      update_reactable_caption(session, "table", subtitle = bad),
      "`subtitle` must be a single, non-empty string",
      fixed = TRUE
    )
  }
  expect_length(session$messages(), 0)
})

test_that("govReactableOutput ships the caption update handler", {
  output_tag <- govReactableOutput("table", caption = "Caption")
  dep_names <- vapply(
    htmltools::findDependencies(output_tag),
    `[[`,
    character(1),
    "name"
  )
  expect_true("update_reactable_caption" %in% dep_names)
})

test_that("update_reactable_caption.js registers the handler it is sent to", {
  # Guards against the R message name and the browser handler name drifting
  # apart, which nothing else would catch outside a real browser.
  js_path <- system.file(
    "www",
    "js",
    "update_reactable_caption.js",
    package = "shinyGovstyle"
  )
  expect_true(file.exists(js_path))
  js <- paste(readLines(js_path, warn = FALSE), collapse = "\n")

  expect_match(
    js,
    'Shiny\\.addCustomMessageHandler\\(\\s*"update_reactable_caption"',
    perl = TRUE
  )
})
