test_that("summary list works", {
  headers <- c(
    "Name",
    "Date of birth",
    "Contact information",
    "Contact details"
  )
  info <- c(
    "Sarah Philips",
    "5 January 1978",
    "72 Guild Street <br> London <br> SE23 6FH",
    "07700 900457 <br> sarah.phillips@example.com"
  )

  summary_check <- gov_summary("sumID", headers, info, action = FALSE)

  expect_equal(length(summary_check$children[[1]]), 4)

  summary_check <- gov_summary(
    "sumID",
    headers,
    info,
    action = TRUE,
    border = FALSE
  )

  expect_identical(
    summary_check$children[[1]]$Name$children[[3]][[3]][[1]][[1]],
    "button"
  )
})
