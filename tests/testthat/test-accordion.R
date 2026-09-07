test_that("accordion works", {
  accordion_check <- accordion(
    "acc1",
    c(
      "Writing well for the web",
      "Writing well for specialists",
      "Know your audience",
      "How people read"
    ),
    c(
      "This is the content for Writing well for the web.",
      "This is the content for Writing well for specialists.",
      "This is the content for Know your audience.",
      "This is the content for How people read."
    )
  )

  expect_length(find_tags(accordion_check, "govuk-accordion__section"), 4L)
})


test_that("accordion numbering works past 9", {
  accordion_numbering_check <- accordion(
    "acc1",
    paste0("Accordion title ", 1:12),
    paste0("Accordion content ", 1:12)
  )

  buttons <- find_tags(
    accordion_numbering_check,
    "govuk-accordion__section-button"
  )
  expect_length(buttons, 12L)

  name1 <- htmltools::tagGetAttribute(buttons[[1]], "name")
  name11 <- htmltools::tagGetAttribute(buttons[[11]], "name")

  expect_equal(stringr::str_sub(name1, -2), "01")
  expect_equal(stringr::str_sub(name11, -2), "11")
})

test_that("string descriptions render as a govuk-body paragraph", {
  html <- as.character(accordion("acc1", "Title", "Just text"))

  expect_match(
    html,
    '<p class="govuk-body">Just text</p>',
    fixed = TRUE
  )
})

test_that("descriptions accept rich block content (tagList)", {
  html <- as.character(
    accordion(
      "acc1",
      "Title",
      list(
        shiny::tagList(
          shinyGovstyle::gov_text("A paragraph"),
          shinyGovstyle::gov_list(
            list(shiny::tags$a(href = "https://www.gov.uk", "Link")),
            style = "bullet"
          )
        )
      )
    )
  )

  expect_match(html, "govuk-list--bullet", fixed = TRUE)
  expect_match(html, '<a href="https://www.gov.uk">Link</a>', fixed = TRUE)
})
