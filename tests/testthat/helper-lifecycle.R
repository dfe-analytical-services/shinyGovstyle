# Helpers for testing deprecated APIs.
#
# `expect_one_deprecation()` evaluates `expr` with lifecycle warnings forced
# on, and checks that it signals exactly one warning, that the warning is a
# lifecycle deprecation, and that its message contains every string in
# `mentions` (e.g. the replacement function). Returns the value of `expr` so
# the output can be checked too. Warnings are captured in an environment
# rather than with `<<-`, following the package's test conventions.
expect_one_deprecation <- function(expr, mentions = character()) {
  rlang::local_options(lifecycle_verbosity = "warning")
  caught <- new.env(parent = emptyenv())
  caught$warnings <- list()

  value <- withCallingHandlers(
    expr,
    warning = function(w) {
      caught$warnings[[length(caught$warnings) + 1L]] <- w
      invokeRestart("muffleWarning")
    }
  )

  expect_length(caught$warnings, 1)
  if (length(caught$warnings) == 1) {
    w <- caught$warnings[[1]]
    expect_s3_class(w, "lifecycle_warning_deprecated")
    for (mention in mentions) {
      expect_match(conditionMessage(w), mention, fixed = TRUE)
    }
  }

  invisible(value)
}

# `expect_same_output()` checks that a deprecated wrapper renders exactly what
# its replacement renders: identical HTML and identical dependencies.
expect_same_output <- function(old, new) {
  expect_identical(as.character(old), as.character(new))
  expect_identical(
    htmltools::findDependencies(old),
    htmltools::findDependencies(new)
  )
}
