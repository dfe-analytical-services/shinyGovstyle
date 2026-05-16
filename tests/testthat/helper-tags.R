# find_tags() matches exact whitespace-split class tokens (not substrings).
# Do not "fix" this to use grepl() — it would falsely match e.g. the
# "govuk-date-input__item" class when looking up "govuk-date-input".
find_tags <- function(x, class) {
  if (inherits(x, "shiny.tag")) {
    classes <- htmltools::tagGetAttribute(x, "class")
    here <- if (
      !is.null(classes) &&
        class %in% strsplit(classes, "\\s+")[[1L]]
    ) {
      list(x)
    } else {
      list()
    }
    c(
      here,
      unlist(lapply(x$children, find_tags, class = class), recursive = FALSE)
    )
  } else if (is.list(x)) {
    result <- unlist(lapply(x, find_tags, class = class), recursive = FALSE)
    if (is.null(result)) list() else result
  } else {
    list()
  }
}

find_tag <- function(x, class) {
  hits <- find_tags(x, class)
  if (length(hits) == 0L) NULL else hits[[1L]]
}

find_tag_required <- function(x, class) {
  node <- find_tag(x, class)
  if (is.null(node)) {
    stop(sprintf("No tag with class %s found", shQuote(class)), call. = FALSE)
  }
  node
}

tag_text <- function(x, class) {
  find_tag_required(x, class)$children[[1L]]
}

child_classes <- function(tag) {
  tag_children <- Filter(function(c) inherits(c, "shiny.tag"), tag$children)
  vapply(
    tag_children,
    function(c) {
      cls <- htmltools::tagGetAttribute(c, "class")
      if (is.null(cls)) NA_character_ else cls
    },
    character(1L)
  )
}

find_by_id_suffix <- function(x, suffix) {
  if (inherits(x, "shiny.tag")) {
    id <- htmltools::tagGetAttribute(x, "id")
    here <- if (!is.null(id) && grepl(paste0(suffix, "$"), id)) {
      list(x)
    } else {
      list()
    }
    c(
      here,
      unlist(
        lapply(x$children, find_by_id_suffix, suffix = suffix),
        recursive = FALSE
      )
    )
  } else if (is.list(x)) {
    result <- unlist(
      lapply(x, find_by_id_suffix, suffix = suffix),
      recursive = FALSE
    )
    if (is.null(result)) list() else result
  } else {
    list()
  }
}

# expect_hidden_error() asserts the standard "renders hidden by default"
# contract: exactly one govuk-error-message tag, class
# "govuk-error-message shinyjs-hide", and (optionally) the message text.
# Tests that want to assert *further* properties of the error tag should
# keep their own `find_tag(.., "govuk-error-message")` lookup alongside
# this helper call rather than replacing it.
expect_hidden_error <- function(tag, message = NULL) {
  errors <- find_tags(tag, "govuk-error-message")
  testthat::expect_length(errors, 1L)
  testthat::expect_identical(
    htmltools::tagGetAttribute(errors[[1L]], "class"),
    "govuk-error-message shinyjs-hide"
  )
  if (!is.null(message)) {
    testthat::expect_identical(errors[[1L]]$children[[1L]], message)
  }
}
