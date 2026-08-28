# find_tags() matches exact whitespace-split class tokens (not substrings).
# Do not "fix" this to use grepl(); it would falsely match e.g. the
# "govuk-date-input__item" class when looking up "govuk-date-input".
#
# Matches are returned in document order (depth-first pre-order). Callers that
# index results positionally (e.g. headers[[1]], or find_tags_by_id_suffix(..)
# [[1L]]) depend on this ordering.
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

# find_tags_by_name() is the tag-name analogue of find_tags(), for elements
# that carry no stable class to match on (e.g. <option> inside a <select>).
# Same document-order, recursive contract as find_tags().
find_tags_by_name <- function(x, name) {
  if (inherits(x, "shiny.tag")) {
    here <- if (identical(x$name, name)) list(x) else list()
    c(
      here,
      unlist(
        lapply(x$children, find_tags_by_name, name = name),
        recursive = FALSE
      )
    )
  } else if (is.list(x)) {
    result <- unlist(
      lapply(x, find_tags_by_name, name = name),
      recursive = FALSE
    )
    if (is.null(result)) list() else result
  } else {
    list()
  }
}

# rendered_children() drops children that produce no output: NULL (htmltools
# keeps it in $children, which is how an unused `if (error == TRUE)` branch
# reaches us) and the empty list left behind by a skipped tagList branch.
rendered_children <- function(tag) {
  Filter(
    function(c) {
      !is.null(c) &&
        !(is.list(c) && !inherits(c, "shiny.tag") && length(c) == 0L)
    },
    tag$children
  )
}

# tag_text() returns the single text child of the matched tag. It errors if the
# tag has any other number of children, so a regression that appends stray
# content next to the text is caught rather than silently ignored. For tags with
# mixed or multiple children, look the tag up with find_tag_required() and
# assert its children explicitly instead.
tag_text <- function(x, class) {
  node_children <- rendered_children(find_tag_required(x, class))
  if (length(node_children) != 1L) {
    stop(
      sprintf(
        "Expected tag with class %s to have exactly one child, found %d",
        shQuote(class),
        length(node_children)
      ),
      call. = FALSE
    )
  }
  node_children[[1L]]
}

# tag_text_by_name() is the tag-name analogue of tag_text(), for elements that
# carry no stable class to match on (e.g. <li> inside a plain list, <option>
# inside a <select>). Unlike tag_text() (which assumes a single match),
# name-based elements are typically repeated, so this returns the first child
# text of *every* match, in document order, as a character vector. Each
# matched tag is still assumed to have a single text child.
tag_text_by_name <- function(x, name) {
  hits <- find_tags_by_name(x, name)
  vapply(hits, function(h) as.character(h$children[[1L]]), character(1L))
}

# child_classes() returns one entry per rendered child of `tag`: the child's
# class, NA for a tag with no class, or a "<text>" / "<list>" sentinel for
# anything that is not a tag. Sentinels rather than silent filtering, so a stray
# text node or a list-wrapped block shows up in the failure diff. Children
# that render nothing are dropped by rendered_children().
child_classes <- function(tag) {
  tag_children <- rendered_children(tag)
  vapply(
    tag_children,
    function(c) {
      if (inherits(c, "shiny.tag")) {
        cls <- htmltools::tagGetAttribute(c, "class")
        if (is.null(cls)) NA_character_ else cls
      } else if (is.list(c)) {
        "<list>"
      } else {
        "<text>"
      }
    },
    character(1L)
  )
}

# find_tags_by_id_suffix() is the id-suffix analogue of find_tags(): it returns
# every descendant whose id ends in `suffix`, in document order. Same recursive
# contract. Most callers want the single-match find_by_id_suffix() below.
find_tags_by_id_suffix <- function(x, suffix) {
  if (inherits(x, "shiny.tag")) {
    id <- htmltools::tagGetAttribute(x, "id")
    # endsWith(), not grepl(): a suffix containing regex metacharacters (".",
    # "[", "+") would otherwise match the wrong element.
    here <- if (!is.null(id) && endsWith(id, suffix)) {
      list(x)
    } else {
      list()
    }
    c(
      here,
      unlist(
        lapply(x$children, find_tags_by_id_suffix, suffix = suffix),
        recursive = FALSE
      )
    )
  } else if (is.list(x)) {
    result <- unlist(
      lapply(x, find_tags_by_id_suffix, suffix = suffix),
      recursive = FALSE
    )
    if (is.null(result)) list() else result
  } else {
    list()
  }
}

# find_by_id_suffix() returns the single descendant whose id ends in `suffix`,
# erroring unless there is exactly one. Stricter than find_tag() /
# find_tag_required() (ids are expected unique: >1 match means the markup
# changed in a way the test should catch).
find_by_id_suffix <- function(x, suffix) {
  hits <- find_tags_by_id_suffix(x, suffix)
  if (length(hits) != 1L) {
    stop(
      sprintf(
        "Expected exactly one tag with id ending in %s, found %d",
        shQuote(suffix),
        length(hits)
      ),
      call. = FALSE
    )
  }
  hits[[1L]]
}

# expect_hidden_error() asserts the standard "renders hidden by default"
# contract: exactly one govuk-error-message tag, class
# "govuk-error-message shinyjs-hide", role "alert", a leading visually hidden
# "Error:" prefix, and (optionally) the message text as the final child. Tests that want to assert *further* properties of the error
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
  # GOV.UK Design System: the visually hidden prefix comes before the message
  # text so screen readers announce "Error: <message>", not "<message> Error:".
  error_children <- errors[[1L]]$children
  prefix <- error_children[[1L]]
  testthat::expect_identical(
    htmltools::tagGetAttribute(prefix, "class"),
    "govuk-visually-hidden"
  )
  testthat::expect_identical(prefix$children[[1L]], "Error:")
  if (!is.null(message)) {
    testthat::expect_identical(
      error_children[[length(error_children)]],
      message
    )
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
