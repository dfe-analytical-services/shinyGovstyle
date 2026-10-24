test_that("noti banner renders title and string body", {
  out <- shinyGovstyle::noti_banner(
    inputId = "banner",
    title_txt = "Important",
    body_txt = "Example text"
  )

  html <- as.character(out)
  expect_match(html, "govuk-notification-banner", fixed = TRUE)
  expect_match(html, "Important", fixed = TRUE)
  expect_match(html, "Example text", fixed = TRUE)
})

test_that("noti success banner uses success class and alert role", {
  out <- shinyGovstyle::noti_banner(
    inputId = "banner",
    title_txt = "Important",
    body_txt = "Example text",
    type = "success"
  )

  html <- as.character(out)
  expect_match(html, "govuk-notification-banner--success", fixed = TRUE)
  expect_match(html, "role=\"alert\"", fixed = TRUE)
})

test_that("body_txt accepts a shiny.tag", {
  out <- shinyGovstyle::noti_banner(
    inputId = "banner",
    title_txt = "Important",
    body_txt = shiny::tags$b("Bold body")
  )

  expect_match(as.character(out), "<b>Bold body</b>", fixed = TRUE)
})

test_that("body_txt accepts a tagList", {
  out <- shinyGovstyle::noti_banner(
    inputId = "banner",
    title_txt = "Important",
    body_txt = shiny::tagList(
      shiny::tags$b("Heads up: "),
      shiny::tags$a(href = "https://example.com", "follow up")
    )
  )

  html <- as.character(out)
  expect_match(html, "<b>Heads up: </b>", fixed = TRUE)
  expect_match(html, "href=\"https://example.com\"", fixed = TRUE)
})
