test_that("banner() warns once, naming phase_banner()", {
  out <- expect_one_deprecation(
    banner("banner", "Beta", "This is a new service"),
    mentions = c("banner()", "phase_banner()", "1.0.0")
  )
  expect_same_output(
    out,
    phase_banner("banner", "Beta", "This is a new service")
  )
})

test_that("banner() positional calls match phase_banner(), including width", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_same_output(
    banner("banner", "Beta", NULL, "https://example.com/feedback", "full"),
    phase_banner("banner", "Beta", NULL, "https://example.com/feedback", "full")
  )
})

test_that("banner() named calls match phase_banner()", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_same_output(
    banner(
      inputId = "banner",
      type = "Alpha",
      feedback_url = "mailto:feedback@example.com"
    ),
    phase_banner(
      inputId = "banner",
      type = "Alpha",
      feedback_url = "mailto:feedback@example.com"
    )
  )
})

test_that("banner() keeps the unset-width default", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  out <- banner("banner", "Beta", "Label")
  # An explicit width = "standard" adds a modifier class; leaving it out
  # must not, exactly as for phase_banner()
  expect_no_tag(out, "govuk-width-container--standard")
})

test_that("banner() passes phase_banner() errors through", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  expect_error(
    banner("banner", "Beta"),
    "Either `label` or `feedback_url` must be provided"
  )
})
