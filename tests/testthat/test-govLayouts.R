test_that("gov_main_layout wraps a main element with govuk-main-wrapper", {
  layout <- gov_main_layout(
    shiny::tags$div(class = "marker-child", "hello"),
    inputID = "main"
  )

  expect_identical(
    htmltools::tagGetAttribute(layout, "class"),
    "govuk-width-container"
  )

  main_wrapper <- expect_has_tag(layout, "govuk-main-wrapper")
  expect_identical(main_wrapper$name, "main")
  expect_identical(htmltools::tagGetAttribute(main_wrapper, "id"), "main")
  expect_identical(htmltools::tagGetAttribute(main_wrapper, "role"), "main")
  expect_identical(htmltools::tagGetAttribute(main_wrapper, "tabindex"), "-1")

  expect_has_tag(layout, "marker-child")
})

test_that("gov_main_layout width defaults to standard", {
  layout <- gov_main_layout(shiny::tags$div("hello"))
  expect_null(htmltools::tagGetAttribute(layout, "style"))
  expect_no_tag(layout, "govuk-width-container--standard")
  expect_no_tag(layout, "govuk-width-container--three-quarters")
  expect_no_tag(layout, "govuk-width-container--full")
})

test_that("gov_main_layout width = 'standard' explicitly renders the class", {
  layout <- gov_main_layout(shiny::tags$div("hello"), width = "standard")
  expect_has_tag(layout, "govuk-width-container--standard")
})

test_that("gov_main_layout width = 'full' adds the full modifier class", {
  layout <- gov_main_layout(shiny::tags$div("hello"), width = "full")
  expect_has_tag(layout, "govuk-width-container--full")
})

test_that("gov_main_layout custom width sets an inline max-width style", {
  layout <- gov_main_layout(shiny::tags$div("hello"), width = "1400px")
  expect_identical(
    htmltools::tagGetAttribute(layout, "style"),
    "max-width: 1400px;"
  )
})

test_that("gov_row renders a govuk-grid-row div and passes children through", {
  row <- gov_row(shiny::tags$div(class = "marker-child", "row content"))

  expect_identical(row$name, "div")
  expect_identical(htmltools::tagGetAttribute(row, "class"), "govuk-grid-row")
  expect_has_tag(row, "marker-child")
})

test_that("gov_box renders a govuk-grid-column-{size} div and respects size", {
  default_box <- gov_box(shiny::tags$div(class = "marker-child", "x"))
  expect_identical(
    htmltools::tagGetAttribute(default_box, "class"),
    "govuk-grid-column-full"
  )
  expect_has_tag(default_box, "marker-child")

  half_box <- gov_box(
    shiny::tags$div(class = "marker-child", "x"),
    size = "one-half"
  )
  expect_identical(
    htmltools::tagGetAttribute(half_box, "class"),
    "govuk-grid-column-one-half"
  )
})

test_that("gov_text renders a govuk-body paragraph with the supplied content", {
  text <- gov_text("Hello world")

  expect_identical(text$name, "p")
  expect_identical(htmltools::tagGetAttribute(text, "class"), "govuk-body")
  expect_identical(tag_text(text, "govuk-body"), "Hello world")
})
