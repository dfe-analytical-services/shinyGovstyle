# Create a test link ==========================================================
test_link <- external_link("https://shiny.posit.co/", "R Shiny")

# Run rest of tests against the test link -------------------------------------
test_that("Returns shiny.tag object", {
  expect_s3_class(test_link, "shiny.tag")
})

test_that("content and URL are correctly formatted", {
  expect_snapshot(test_link)
})

test_that("attributes are attached properly", {
  expect_equal(test_link$attribs$rel, "noopener noreferrer")
  expect_equal(test_link$attribs$target, "_blank")
})

# Rest of tests against the function ==========================================
test_that("Rejects dodgy link text", {
  expect_error(external_link("https://shiny.posit.co/", "Click here"))
  expect_error(external_link("https://shiny.posit.co/", "here"))
  expect_error(external_link("https://shiny.posit.co/", "PDF"))
  expect_error(external_link("https://shiny.posit.co/", "Full stop."))
  expect_error(external_link(
    "https://shiny.posit.co/",
    "https://shiny.posit.co/"
  ))
  expect_error(external_link(
    "https://shiny.posit.co/",
    "http://shiny.posit.co/"
  ))
  expect_error(external_link("https://shiny.posit.co/", "www.google.com"))
})

test_that("Rejects non-boolean for add_warning", {
  expect_error(
    external_link(
      "https://shiny.posit.co/",
      "R Shiny",
      add_warning = "Funky non-boolean"
    ),
    "add_warning must be a TRUE or FALSE value"
  )
})

test_that("New tab warning always stays for non-visual users", {
  test_link_hidden <-
    external_link("https://shiny.posit.co/", "R Shiny", add_warning = FALSE)

  expect_snapshot(
    external_link("https://shiny.posit.co/", "R Shiny", add_warning = FALSE)
  )
})

test_that("Surrounding whitespace shrubbery is trimmed", {
  expect_snapshot(external_link("https://shiny.posit.co/", "   R Shiny"))

  expect_snapshot(
    external_link("https://shiny.posit.co/", "R Shiny      ")
  )

  expect_snapshot(
    external_link("https://shiny.posit.co/", "   R Shiny   ")
  )

  expect_snapshot(
    external_link("https://shiny.posit.co/", "   R Shiny", add_warning = FALSE)
  )

  expect_snapshot(
    external_link("https://shiny.posit.co/", "R Shiny   ", add_warning = FALSE)
  )

  expect_snapshot(
    external_link(
      "https://shiny.posit.co/",
      "   R Shiny   ",
      add_warning = FALSE
    )
  )
})

test_that("Warning appears for short link text and not for long text", {
  expect_warning(
    external_link("https://shiny.posit.co/", "R"),
    paste0(
      "the link_text: R, is shorter than 7 characters, this is",
      " unlikely to be descriptive for users, consider having more detailed",
      " link text"
    )
  )

  expect_no_warning(external_link("https://shiny.posit.co/", "R Shiny"))
})

test_that("Footer flag works as expected", {
  expect_equal(
    external_link(
      "www.test-link.co.uk",
      "test link",
      footer = FALSE
    )$attribs$class,
    "govuk-link"
  )

  expect_equal(
    external_link(
      "www.test-link.co.uk",
      "test link",
      footer = TRUE
    )$attribs$class,
    "govuk-link govuk-footer__link"
  )

  expect_error(
    external_link("www.test-link.co.uk", "test link", footer = "TRUE"),
    paste0(
      "The footer parameter should logical TRUE/FALSE. Received:\n",
      "character: TRUE"
    )
  )

  expect_error(
    external_link("www.test-link.co.uk", "test link", footer = 0),
    paste0(
      "The footer parameter should logical TRUE/FALSE. Received:\n",
      "numeric: 0"
    )
  )
})
