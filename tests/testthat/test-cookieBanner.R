test_that("cookie banner works", {
  cookie_banner_check <- shinyGovstyle::cookieBanner("The best thing")

  button_group <- find_tag(cookie_banner_check, "govuk-button-group")
  expect_equal(length(button_group$children), 3)

  expect_identical(
    tag_text(cookie_banner_check, "govuk-cookie-banner__heading"),
    "Cookies on The best thing"
  )

  # Body copy is rendered via gov_text(), so it carries the govuk-body class.
  bodies <- find_tags(cookie_banner_check, "govuk-body")
  expect_gte(length(bodies), 2)
  expect_match(
    paste(
      vapply(bodies, function(b) as.character(b), character(1L)),
      collapse = " "
    ),
    "We use some essential cookies to make this service work."
  )

  hidden_msgs <- Filter(
    function(t) {
      cls <- htmltools::tagGetAttribute(t, "class")
      !is.null(cls) && "shinyjs-hide" %in% strsplit(cls, "\\s+")[[1L]]
    },
    cookie_banner_check$children
  )
  expect_length(hidden_msgs, 2L)
  ids <- vapply(hidden_msgs, htmltools::tagGetAttribute, character(1L), "id")
  expect_setequal(ids, c("cookieAcceptDiv", "cookieRejectDiv"))
})

test_that("cookie banner link markup is as expected", {
  local_edition(3)

  expect_snapshot(cookieBanner("The best thing"))
})
