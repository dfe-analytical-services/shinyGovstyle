test_that("text area works", {
  text_area_check <- text_area_Input("input1", "Test area")

  expect_equal(
    as.numeric(htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-textarea"),
      "rows"
    )),
    5
  )

  expect_identical(
    tag_text(text_area_check, "govuk-label"),
    shiny::HTML("Test area")
  )
})


test_that("text area error works", {
  text_area_check <- text_area_Input(
    "input1",
    "Test area",
    error = TRUE,
    error_message = "Test error",
    row_no = 10
  )

  expect_equal(
    as.numeric(htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-textarea"),
      "rows"
    )),
    10
  )

  expect_hidden_error(text_area_check, "Test error")
})

test_that("text area word works", {
  text_area_check <- text_area_Input("input1", "Test area", word_limit = 300)

  textarea <- find_tag(text_area_check, "govuk-textarea")
  expect_identical(
    htmltools::tagGetAttribute(textarea, "aria-describedby"),
    "input1-info"
  )

  # Visible until the JS starts the live count, as in GOV.UK Frontend
  info <- find_by_id_suffix(text_area_check, "input1-info")
  expect_identical(
    htmltools::tagGetAttribute(info, "class"),
    "govuk-hint govuk-character-count__message"
  )
  expect_identical(
    tag_text_by_id_suffix(text_area_check, "input1-info"),
    "You can enter up to 300 words"
  )

  # "input1-status" (not just "-status"): "-sr-status" also ends in "-status".
  status <- find_by_id_suffix(text_area_check, "input1-status")
  expect_identical(htmltools::tagGetAttribute(status, "aria-hidden"), "true")
  expect_identical(
    htmltools::tagGetAttribute(status, "class"),
    "govuk-hint govuk-character-count__message govuk-character-count__status"
  )
  # Hidden, and empty, until the JS fills it in
  expect_true(htmltools::tagHasAttribute(status, "hidden"))
  expect_length(rendered_children(status), 0)

  sr_status <- find_by_id_suffix(text_area_check, "input1-sr-status")
  expect_identical(
    htmltools::tagGetAttribute(sr_status, "aria-live"),
    "polite"
  )
  expect_identical(
    htmltools::tagGetAttribute(sr_status, "aria-atomic"),
    "true"
  )
  expect_match(
    htmltools::tagGetAttribute(sr_status, "class"),
    "govuk-visually-hidden"
  )
  expect_length(rendered_children(sr_status), 0)
})

test_that("word limit uses GOV.UK's maxlength and count type markup", {
  # tagQuery()$find() searches descendants only, so query from a wrapper
  form_group <- htmltools::tagQuery(
    shiny::div(text_area_Input("input1", "Test area", word_limit = 300))
  )$find(".govuk-character-count")$selectedTags()
  expect_length(form_group, 1)
  form_group <- form_group[[1]]

  expect_identical(
    htmltools::tagGetAttribute(form_group, "data-module"),
    "govuk-character-count"
  )
  expect_identical(
    htmltools::tagGetAttribute(form_group, "data-maxlength"),
    "300"
  )
  expect_identical(
    htmltools::tagGetAttribute(form_group, "data-count-type"),
    "words"
  )
  expect_false(htmltools::tagHasAttribute(form_group, "data-maxwords"))
})

test_that("no count attributes without a word limit", {
  form_group <- htmltools::tagQuery(
    shiny::div(text_area_Input("input1", "Test area"))
  )$find("#input1div")$selectedTags()
  expect_length(form_group, 1)
  form_group <- form_group[[1]]

  expect_identical(
    htmltools::tagGetAttribute(form_group, "class"),
    "govuk-form-group"
  )
  for (attr in c(
    "data-module",
    "data-maxlength",
    "data-count-type",
    "data-maxwords"
  )) {
    expect_false(htmltools::tagHasAttribute(form_group, attr), label = attr)
  }
  expect_length(
    htmltools::tagQuery(form_group)$find(
      ".govuk-character-count__message"
    )$selectedTags(),
    0
  )
})

test_that("form group children appear in GOV.UK order", {
  text_area_check <- text_area_Input(
    "input1",
    "Test area",
    error = TRUE,
    error_message = "Test error",
    word_limit = 300
  )

  expect_identical(
    htmltools::tagGetAttribute(text_area_check, "class"),
    "govuk-form-group govuk-character-count"
  )
  expect_identical(
    child_classes(text_area_check),
    c(
      "govuk-label",
      "govuk-error-message shinyjs-hide",
      "govuk-textarea govuk-js-character-count",
      # the word-limit info/status/sr-status divs, after the textarea as in
      # GOV.UK Frontend, wrapped in a tagList
      "<list>"
    )
  )
})

test_that("label is programmatically associated with the textarea", {
  text_area_check <- text_area_Input("input1", "Test area")

  expect_identical(
    htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-label"),
      "for"
    ),
    "input1"
  )
  expect_identical(
    htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-textarea"),
      "id"
    ),
    "input1"
  )
})

test_that("hint is referenced by aria-describedby only when given", {
  with_hint <- text_area_Input("input1", "Test area", hint_label = "Hint")
  without_hint <- text_area_Input("input1", "Test area")

  expect_identical(
    htmltools::tagGetAttribute(
      find_tag(with_hint, "govuk-textarea"),
      "aria-describedby"
    ),
    "input1-hint"
  )
  expect_null(
    htmltools::tagGetAttribute(
      find_tag(without_hint, "govuk-textarea"),
      "aria-describedby"
    )
  )
})

test_that("hidden error id is never in the rendered aria-describedby", {
  # error_on() adds the error id at runtime; rendering it up front would make
  # screen readers announce the hidden error before it is raised.
  text_area_check <- text_area_Input(
    "input1",
    "Test area",
    hint_label = "Hint",
    error = TRUE,
    error_message = "Test error",
    word_limit = 300
  )

  expect_identical(
    htmltools::tagGetAttribute(
      find_tag(text_area_check, "govuk-textarea"),
      "aria-describedby"
    ),
    "input1-info input1-hint"
  )
})
