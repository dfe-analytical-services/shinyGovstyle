test_that("govReactableOutput links the caption to the table region", {
  output_tag <- govReactableOutput("table", caption = "Example table")

  html <- htmltools::renderTags(output_tag)$html

  expect_match(
    html,
    '<h2 class="govuk-heading-l" id="table-caption">Example table</h2>',
    fixed = TRUE
  )
  expect_match(
    html,
    '<div role="region" aria-labelledby="table-caption">',
    fixed = TRUE
  )
})

test_that("govReactableOutput caption ids follow the (namespaced) output id", {
  # Output ids are already unique on a Shiny page, so captions that share
  # text, or have no letters at all, still get distinct ids.
  ns <- shiny::NS("mod")
  page <- htmltools::tagList(
    govReactableOutput("table_a", caption = "2025"),
    govReactableOutput("table_b", caption = "2025"),
    govReactableOutput(ns("table_a"), caption = "2025")
  )

  links <- caption_links(page)
  expect_identical(
    links$heading_ids,
    c("table_a-caption", "table_b-caption", "mod-table_a-caption")
  )
  expect_identical(links$labelledby, links$heading_ids)
})

test_that("govReactableOutput subtitle id follows the (namespaced) output id", {
  ns <- shiny::NS("mod")
  output_tag <- govReactableOutput(
    ns("table"),
    caption = "Costs peaked in March",
    subtitle = "Cost of vehicles (£), January to May"
  )

  subtitle <- find_tag_required(output_tag, "govuk-caption-m")
  expect_identical(
    htmltools::tagGetAttribute(subtitle, "id"),
    "mod-table-subtitle"
  )
  expect_identical(
    caption_links(output_tag)$labelledby,
    "mod-table-caption mod-table-subtitle"
  )
})

test_that("govReactableOutput markup is unchanged without a subtitle", {
  output_tag <- govReactableOutput("table", caption = "Example table")
  expect_no_tag(output_tag, "govuk-caption-m")
  expect_identical(caption_links(output_tag)$labelledby, "table-caption")
})

test_that("govReactableOutput errors on an invalid caption or subtitle", {
  expect_error(
    govReactableOutput("table", caption = ""),
    "`caption` must be a single, non-empty string",
    fixed = TRUE
  )
  expect_error(
    govReactableOutput("table", caption = "Headline", subtitle = NA_character_),
    "`subtitle` must be a single, non-empty string",
    fixed = TRUE
  )
})

test_that("govReactableOutput caption respects caption_size/heading_level", {
  output_tag <- govReactableOutput(
    "table",
    caption = "Example table",
    caption_size = "s",
    heading_level = 4
  )

  html <- htmltools::renderTags(output_tag)$html

  expect_match(
    html,
    '<h4 class="govuk-heading-s" id="table-caption">Example table</h4>',
    fixed = TRUE
  )
})

test_that("govReactableOutput errors on an invalid caption_size", {
  expect_error(
    govReactableOutput(
      "table",
      caption = "Example table",
      caption_size = "xxl"
    ),
    "`caption_size` must be one of",
    fixed = TRUE
  )
})

test_that("deprecated string heading_level still works with a warning", {
  rlang::local_options(lifecycle_verbosity = "warning")
  expect_warning(
    output_tag <- govReactableOutput(
      "table",
      caption = "Example table",
      heading_level = "h3"
    ),
    class = "lifecycle_warning_deprecated"
  )

  html <- htmltools::renderTags(output_tag)$html
  expect_match(
    html,
    '<h3 class="govuk-heading-l" id="table-caption">Example table</h3>',
    fixed = TRUE
  )
})

test_that("renderGovReactable renders a table and reacts to inputs", {
  server <- function(input, output, session) {
    output$table <- renderGovReactable({
      govReactable(utils::head(iris, input$rows))
    })
  }

  shiny::testServer(server, {
    session$setInputs(rows = 2)
    rendered <- jsonlite::fromJSON(output$table)
    expect_false(is.null(rendered$x))
    expect_length(rendered$x$tag$attribs$data$Species, 2)

    session$setInputs(rows = 3)
    rendered <- jsonlite::fromJSON(output$table)
    expect_length(rendered$x$tag$attribs$data$Species, 3)
  })
})

# promises is always installed, as shiny imports it, but isn't a declared
# dependency of this package, so it's reached through its namespace rather
# than with `promises::`, which R CMD check would flag as undeclared.
async_value <- function(value, then) {
  promises <- asNamespace("promises")
  promises$then(promises$promise_resolve(value), then)
}

test_that("renderGovReactable renders an async table", {
  server <- function(input, output, session) {
    output$table <- renderGovReactable({
      async_value(utils::head(iris, 2), govReactable)
    })
  }

  shiny::testServer(server, {
    rendered <- jsonlite::fromJSON(output$table)
    expect_length(rendered$x$tag$attribs$data$Species, 2)
  })
})

test_that("renderGovReactable errors on a captioned async table", {
  server <- function(input, output, session) {
    output$table <- renderGovReactable({
      async_value(iris, function(df) {
        govReactable(df, caption = "Iris measurements")
      })
    })
  }

  shiny::testServer(server, {
    expect_error(
      output$table,
      "set them on govReactableOutput() instead",
      fixed = TRUE
    )
  })
})

test_that("renderGovReactable errors on a captioned govReactable", {
  # A captioned govReactable() is a tagList, which renderReactable() would
  # otherwise render as an empty table with no error.
  server <- function(input, output, session) {
    output$table <- renderGovReactable({
      govReactable(iris, caption = "Iris measurements")
    })
  }

  shiny::testServer(server, {
    expect_error(
      output$table,
      "set them on govReactableOutput() instead",
      fixed = TRUE
    )
  })
})

test_that("renderGovReactable errors on a value that isn't a table", {
  server <- function(input, output, session) {
    output$table <- renderGovReactable(iris)
  }

  shiny::testServer(server, {
    expect_error(
      output$table,
      "not an object of class data.frame",
      fixed = TRUE
    )
  })
})

test_that("renderGovReactable allows NULL for no table", {
  server <- function(input, output, session) {
    output$table <- renderGovReactable(NULL)
  }

  shiny::testServer(server, {
    expect_no_error(output$table)
  })
})

test_that("govReactableOutput attaches the GOV.UK stylesheet", {
  output_check <- govReactableOutput("table", caption = "Example table")
  dep_names <- vapply(
    htmltools::findDependencies(output_check),
    `[[`,
    character(1),
    "name"
  )
  expect_true("stylecss" %in% dep_names)
})
