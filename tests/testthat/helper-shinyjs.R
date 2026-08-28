# Helpers for testing functions that dispatch through shinyjs::* without
# a Shiny session. Use with testthat::with_mocked_bindings(.package = "shinyjs")
# to record what would have been sent to the session.
#
# `make_call_recorder()` returns a list of:
#   - record(fn): factory producing a mock that tags every call with `fn`
#   - get(): returns the list of recorded calls, each `list(fn, args)`
#
# `recorded_arg()` pulls a named argument out of a recorded call, falling back
# to a positional index when the source called the shinyjs function without
# names. shinyjs::addClass etc. are called both ways across R/error_*.R.
# State lives in an environment (not a closure-captured local mutated with
# `<<-`) so the recorder follows the package convention of capturing mock
# side effects in `new.env(parent = emptyenv())`.
make_call_recorder <- function() {
  state <- new.env(parent = emptyenv())
  state$calls <- list()
  list(
    record = function(fn) {
      function(...) {
        state$calls[[length(state$calls) + 1L]] <-
          list(fn = fn, args = list(...))
      }
    },
    get = function() state$calls
  )
}

recorded_arg <- function(call, name, position) {
  if (name %in% names(call$args)) {
    call$args[[name]]
  } else if (length(call$args) >= position) {
    call$args[[position]]
  } else {
    NULL
  }
}

calls_for <- function(recorder, fn) {
  Filter(function(c) c$fn == fn, recorder$get())
}
