test_that("error_summary builds the documented structure", {
  summary_tag <- error_summary(
    "error1",
    "Error Title",
    c("error entry 1", "error entry 2")
  )

  expect_identical(summary_tag$attribs$id, "error1")
  expect_identical(summary_tag$attribs$class, "govuk-error-summary")

  expect_identical(
    as.character(tag_text(summary_tag, "govuk-error-summary__title")),
    "Error Title"
  )

  body <- find_tag_required(summary_tag, "govuk-error-summary__body")
  expect_identical(body$attribs$id, "error1list")

  list_tag <- find_tag_required(summary_tag, "govuk-error-summary__list")
  expect_identical(
    list_tag$attribs$class,
    "govuk-list govuk-error-summary__list"
  )

  # error_summary() builds <li> tags via Map(), which leaves them as a
  # length-1 list nested inside $children. Unwrap that before walking the items.
  li_tags <- list_tag$children[[1L]]
  entries <- vapply(
    li_tags,
    function(li) as.character(li$children[[1L]]),
    character(1L)
  )
  expect_identical(unname(entries), c("error entry 1", "error entry 2"))
})
