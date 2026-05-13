## ---- helpers ----------------------------------------------------------------

make_legacy_summary <- function(action = FALSE, border = TRUE) {
  headers <- c("Name", "Date of birth", "Contact information", "Contact details")
  info <- c(
    "Sarah Philips",
    "5 January 1978",
    "72 Guild Street <br> London <br> SE23 6FH",
    "07700 900457 <br> sarah.phillips@example.com"
  )
  gov_summary("sumID", headers, info, action = action, border = border)
}

# Rows are now direct children of the <dl> (do.call spread them).
get_rows <- function(out) out$children

## ---- legacy vector API ------------------------------------------------------

test_that("legacy API: correct number of rows", {
  out <- make_legacy_summary()
  expect_equal(length(get_rows(out)), 4)
})

test_that("legacy API: action = FALSE rows have --no-actions class", {
  out <- make_legacy_summary(action = FALSE)
  for (row in get_rows(out)) {
    expect_match(row$attribs$class, "govuk-summary-list__row--no-actions")
  }
})

test_that("legacy API: action = TRUE rows have action button", {
  out <- make_legacy_summary(action = TRUE)
  for (row in get_rows(out)) {
    classes <- vapply(row$children, function(ch) {
      if (is.list(ch)) ch$attribs$class %||% "" else ""
    }, character(1))
    expect_true(any(grepl("govuk-summary-list__actions", classes)))
    expect_false(grepl("--no-actions", row$attribs$class))
  }
})

test_that("legacy API: action buttons contain visually-hidden text", {
  out <- make_legacy_summary(action = TRUE)
  for (row in get_rows(out)) {
    actions_dd <- Filter(
      function(ch) is.list(ch) &&
        identical(ch$attribs$class, "govuk-summary-list__actions"),
      row$children
    )[[1]]
    btn <- actions_dd$children[[1]]
    spans <- Filter(function(ch) {
      is.list(ch) && !is.null(ch$attribs$class) &&
        grepl("govuk-visually-hidden", ch$attribs$class)
    }, btn$children)
    expect_length(spans, 1)
  }
})

test_that("legacy API: border = FALSE adds --no-border class to dl", {
  out <- make_legacy_summary(border = FALSE)
  expect_match(out$attribs$class, "govuk-summary-list--no-border")
})

test_that("legacy API: border = TRUE has no --no-border class on dl", {
  out <- make_legacy_summary(border = TRUE)
  expect_false(grepl("--no-border", out$attribs$class))
})

test_that("legacy API: summary-overrides.css dependency is attached", {
  out <- make_legacy_summary()
  deps <- htmltools::findDependencies(out)
  dep_names <- vapply(deps, `[[`, character(1), "name")
  expect_true("summary" %in% dep_names)
  summary_dep <- deps[[which(dep_names == "summary")]]
  expect_equal(summary_dep$stylesheet, "summary-overrides.css")
})

## ---- rows API ---------------------------------------------------------------

test_that("rows API: row without actions gets --no-actions class", {
  out <- gov_summary("id1", rows = list(
    list(key = "Name", value = "Sarah", actions = list())
  ))
  row <- get_rows(out)[[1]]
  expect_match(row$attribs$class, "govuk-summary-list__row--no-actions")
})

test_that("rows API: row with actions does NOT get --no-actions class", {
  out <- gov_summary("id2", rows = list(
    list(key = "Name", value = "Sarah",
         actions = list(list(id = "btn1", text = "Change",
                             visually_hidden_text = "name")))
  ))
  row <- get_rows(out)[[1]]
  expect_false(grepl("--no-actions", row$attribs$class))
})

test_that("rows API: no_border = TRUE adds --no-border class to row", {
  out <- gov_summary("id3", rows = list(
    list(key = "Name", value = "Sarah", actions = list(), no_border = TRUE)
  ))
  row <- get_rows(out)[[1]]
  expect_match(row$attribs$class, "govuk-summary-list__row--no-border")
})

test_that("rows API: multiple actions produce actions-list ul with li items", {
  out <- gov_summary("id4", rows = list(
    list(key = "Contact", value = "Unknown",
         actions = list(
           list(id = "add_c",    text = "Add",    visually_hidden_text = "contact"),
           list(id = "change_c", text = "Change", visually_hidden_text = "contact")
         ))
  ))
  row <- get_rows(out)[[1]]
  actions_dd <- Filter(
    function(ch) is.list(ch) &&
      identical(ch$attribs$class, "govuk-summary-list__actions"),
    row$children
  )[[1]]
  ul <- actions_dd$children[[1]]
  expect_equal(ul$name, "ul")
  expect_match(ul$attribs$class, "govuk-summary-list__actions-list")
  expect_length(ul$children, 2)
  expect_match(ul$children[[1]]$attribs$class, "govuk-summary-list__actions-list-item")
})

test_that("rows API: single action does NOT wrap in ul", {
  out <- gov_summary("id5", rows = list(
    list(key = "Name", value = "Sarah",
         actions = list(list(id = "btn1", text = "Change",
                             visually_hidden_text = "name")))
  ))
  row <- get_rows(out)[[1]]
  actions_dd <- Filter(
    function(ch) is.list(ch) &&
      identical(ch$attribs$class, "govuk-summary-list__actions"),
    row$children
  )[[1]]
  expect_equal(actions_dd$children[[1]]$name, "button")
})

test_that("rows API: tag object passed as key is rendered as-is", {
  key_tag <- shiny::tags$span(class = "custom", "My Key")
  out <- gov_summary("id6", rows = list(
    list(key = key_tag, value = "val", actions = list())
  ))
  row <- get_rows(out)[[1]]
  dt <- row$children[[1]]
  expect_equal(dt$children[[1]]$name, "span")
  expect_equal(dt$children[[1]]$attribs$class, "custom")
})

## ---- gov_summary_card -------------------------------------------------------

test_that("gov_summary_card: wraps in govuk-summary-card structure", {
  out <- gov_summary_card(
    inputId = "cardID",
    title = "Lead tenant",
    rows = list(list(key = "Age", value = "38", actions = list()))
  )
  expect_equal(out$name, "div")
  expect_match(out$attribs$class, "govuk-summary-card")
})

test_that("gov_summary_card: title wrapper and title text correct", {
  out <- gov_summary_card(
    inputId = "cardID",
    title = "Lead tenant",
    rows = list(list(key = "Age", value = "38", actions = list()))
  )
  wrapper <- out$children[[1]]
  expect_match(wrapper$attribs$class, "govuk-summary-card__title-wrapper")
  heading <- wrapper$children[[1]]
  expect_equal(heading$name, "h2")
  expect_equal(heading$children[[1]], "Lead tenant")
})

test_that("gov_summary_card: heading_level controls tag name", {
  out <- gov_summary_card(
    inputId = "cardID", title = "Section",
    heading_level = 3L,
    rows = list(list(key = "A", value = "B", actions = list()))
  )
  heading <- out$children[[1]]$children[[1]]
  expect_equal(heading$name, "h3")
})

test_that("gov_summary_card: invalid heading_level errors", {
  expect_error(
    gov_summary_card("id", "T", heading_level = 7L,
                     rows = list(list(key = "k", value = "v", actions = list()))),
    "heading_level"
  )
})

test_that("gov_summary_card: no card_actions omits the actions ul", {
  out <- gov_summary_card(
    inputId = "cardID", title = "T",
    rows = list(list(key = "A", value = "B", actions = list()))
  )
  wrapper <- out$children[[1]]
  ul_children <- Filter(function(ch) {
    is.list(ch) && !is.null(ch$name) && ch$name == "ul"
  }, wrapper$children)
  expect_length(ul_children, 0)
})

test_that("gov_summary_card: card_actions render as li items", {
  out <- gov_summary_card(
    inputId = "cardID", title = "T",
    card_actions = list(
      list(id = "del", text = "Delete", visually_hidden_text = "(T)"),
      list(id = "wit", text = "Withdraw", visually_hidden_text = "(T)")
    ),
    rows = list(list(key = "A", value = "B", actions = list()))
  )
  wrapper <- out$children[[1]]
  ul <- Filter(function(ch) is.list(ch) && !is.null(ch$name) && ch$name == "ul",
               wrapper$children)[[1]]
  expect_match(ul$attribs$class, "govuk-summary-card__actions")
  expect_length(ul$children, 2)
  expect_match(ul$children[[1]]$attribs$class, "govuk-summary-card__action")
})

test_that("gov_summary_card: content div contains the summary dependency", {
  out <- gov_summary_card(
    inputId = "cardID", title = "T",
    rows = list(list(key = "A", value = "B", actions = list()))
  )
  content_div <- out$children[[2]]
  expect_match(content_div$attribs$class, "govuk-summary-card__content")
  dl_found <- any(vapply(htmltools::findDependencies(content_div), function(d) {
    identical(d$name, "summary")
  }, logical(1)))
  expect_true(dl_found)
})
