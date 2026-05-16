test_that("gov_main_layout wraps a main element with govuk-main-wrapper", {
  layout <- gov_main_layout(
    shiny::tags$div(class = "marker-child", "hello"),
    inputID = "main"
  )

  expect_identical(
    htmltools::tagGetAttribute(layout, "class"),
    "govuk-width-container"
  )

  main_wrapper <- find_tag(layout, "govuk-main-wrapper")
  expect_false(is.null(main_wrapper))
  expect_identical(main_wrapper$name, "main")
  expect_identical(htmltools::tagGetAttribute(main_wrapper, "id"), "main")
  expect_identical(htmltools::tagGetAttribute(main_wrapper, "role"), "main")
  expect_identical(htmltools::tagGetAttribute(main_wrapper, "tabindex"), "-1")

  expect_false(is.null(find_tag(layout, "marker-child")))
})

test_that("gov_row renders a govuk-grid-row div and passes children through", {
  row <- gov_row(shiny::tags$div(class = "marker-child", "row content"))

  expect_identical(row$name, "div")
  expect_identical(htmltools::tagGetAttribute(row, "class"), "govuk-grid-row")
  expect_false(is.null(find_tag(row, "marker-child")))
})

test_that("gov_box renders a govuk-grid-column-{size} div and respects size", {
  default_box <- gov_box(shiny::tags$div(class = "marker-child", "x"))
  expect_identical(
    htmltools::tagGetAttribute(default_box, "class"),
    "govuk-grid-column-full"
  )
  expect_false(is.null(find_tag(default_box, "marker-child")))

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
  expect_identical(text$children[[1L]], "Hello world")
})
