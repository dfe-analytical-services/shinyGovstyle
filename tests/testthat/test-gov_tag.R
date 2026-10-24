test_that("tag works", {
  tag_check <- shinyGovstyle::gov_tag("tag1", "Complete")

  expect_identical(
    htmltools::tagGetAttribute(tag_check, "class"),
    "govuk-tag"
  )

  expect_identical(
    tag_text(tag_check, "govuk-tag"),
    "Complete"
  )
})


test_that("tag colour works", {
  tag_check2 <- shinyGovstyle::gov_tag("tag1", "Complete", "yellow")

  expect_identical(
    htmltools::tagGetAttribute(tag_check2, "class"),
    "govuk-tag govuk-tag--yellow"
  )
})


test_that("deprecated colours are warned against", {
  expect_warning(
    gov_tag("tag2", "Complete", "light-blue"),
    paste(
      "'light-blue' is no longer a supported colour.",
      "Please select an alternative from: 'navy', 'grey', 'purple', 'teal',",
      "'blue', 'yellow', 'orange', 'red', 'magenta', or 'green'."
    ),
    fixed = TRUE
  )
})


test_that("every removed colour warns, supported colours do not", {
  for (colour in c("light-blue", "turquoise", "pink")) {
    expect_warning(
      gov_tag("tag2", "Complete", colour),
      paste0("'", colour, "' is no longer a supported colour."),
      fixed = TRUE
    )
  }
  expect_no_warning(gov_tag("tag2", "Complete", "red"))
})


test_that("unknown colours warn and list the supported options", {
  for (colour in c("rainbow", "gren", "Red")) {
    expect_warning(
      gov_tag("tag2", "Complete", colour),
      paste0(
        "'",
        colour,
        "' is not a supported colour. Please select an alternative from: ",
        "'navy', 'grey', 'purple', 'teal', 'blue', 'yellow', 'orange', ",
        "'red', 'magenta', or 'green'."
      ),
      fixed = TRUE
    )
  }
})


test_that("a colour that is not a single string errors clearly", {
  for (colour in list(NULL, NA_character_, 1, c("red", "blue"))) {
    expect_error(
      gov_tag("tag2", "Complete", colour),
      "`colour` must be a single character string.",
      fixed = TRUE
    )
  }
})
