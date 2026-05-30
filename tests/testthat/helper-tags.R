# find_tags() matches exact whitespace-split class tokens (not substrings).
# Do not "fix" this to use grepl() — it would falsely match e.g. the
# "govuk-date-input__item" class when looking up "govuk-date-input".
#
# Matches are returned in document order (depth-first pre-order). Callers that
# index results positionally (e.g. headers[[1]], find_by_id_suffix(..)[[1L]])
# depend on this ordering.
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

# find_tag() returns the first match in document order, or NULL if none.
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
# "govuk-error-message shinyjs-hide", role "alert", and (optionally) the
# message text. Tests that want to assert *further* properties of the error
# tag should keep their own `find_tag(.., "govuk-error-message")` lookup
# alongside this helper call rather than replacing it.
expect_hidden_error <- function(tag, message = NULL) {
  errors <- find_tags(tag, "govuk-error-message")
  testthat::expect_length(errors, 1L)
  testthat::expect_identical(
    htmltools::tagGetAttribute(errors[[1L]], "class"),
    "govuk-error-message shinyjs-hide"
  )
  testthat::expect_identical(
    htmltools::tagGetAttribute(errors[[1L]], "role"),
    "alert"
  )
  if (!is.null(message)) {
    testthat::expect_identical(errors[[1L]]$children[[1L]], message)
  }
}

# expect_has_tag() asserts a tag with `class` is present and returns it (so a
# present-assertion can double as a lookup). Prefer this over
# expect_false(is.null(find_tag(..))), which gives an uninformative message.
expect_has_tag <- function(x, class) {
  node <- find_tag(x, class)
  testthat::expect(
    !is.null(node),
    sprintf("Expected a tag with class %s, but none was found.", shQuote(class))
  )
  invisible(node)
}

# expect_no_tag() asserts no tag with `class` is present.
expect_no_tag <- function(x, class) {
  testthat::expect_null(find_tag(x, class))
}
