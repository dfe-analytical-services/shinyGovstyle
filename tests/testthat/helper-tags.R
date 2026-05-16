find_tags <- function(x, class) {
  if (inherits(x, "shiny.tag")) {
    classes <- htmltools::tagGetAttribute(x, "class")
    here <- if (!is.null(classes) &&
                class %in% strsplit(classes, "\\s+")[[1L]]) list(x) else list()
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

tag_text <- function(x, class) {
  node <- find_tag(x, class)
  if (is.null(node)) NULL else node$children[[1L]]
}

child_classes <- function(tag) {
  vapply(tag$children, function(c) {
    if (!inherits(c, "shiny.tag")) return(NA_character_)
    cls <- htmltools::tagGetAttribute(c, "class")
    if (is.null(cls)) NA_character_ else cls
  }, character(1L))
}
