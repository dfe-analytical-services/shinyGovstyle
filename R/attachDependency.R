#' Base shinyGovstyle dependencies
#'
#' The core stylesheet plus the `update_page_title` handler, shipped with
#' every shinyGovstyle UI function (via [attachDependency()] or directly)
#' so that `update_page_title()` works in any app that uses at least one
#' shinyGovstyle function, regardless of whether `service_navigation()` is
#' present.
#'
#' @noRd
#' @importFrom utils packageVersion
#' @importFrom htmltools htmlDependency
base_dependencies <- function() {
  version <- as.character(packageVersion("shinyGovstyle")[[1]])

  list(
    htmltools::htmlDependency(
      name = "stylecss",
      version = version,
      src = c(href = "shinyGovstyle/css"),
      stylesheet = "govuk-frontend-6.1.0.min.css"
    ),
    htmltools::htmlDependency(
      name = "update_page_title",
      version = version,
      src = c(href = "shinyGovstyle/js"),
      script = "update_page_title.js"
    )
  )
}

#' Attach shinyGovstyle dependencies
#'
#' @param tag An object which has (or should have) HTML dependencies. Can be
#'   either an `htmltools` tag or an `htmlwidget` object.
#' @param widget Name of a widget for particular dependencies
#'
#' @noRd
#' @importFrom utils packageVersion
#' @importFrom htmltools htmlDependency attachDependencies findDependencies
attachDependency <- # nolint
  function(tag, widget = NULL) {
    version <- as.character(packageVersion("shinyGovstyle")[[1]])

    dep <- base_dependencies()

    if (!is.null(widget)) {
      widget_dep <- if (widget == "radio") {
        htmltools::htmlDependency(
          name = "radio_button_Input",
          version = version,
          src = c(href = "shinyGovstyle/js"),
          script = "radio_button_input_binding.js"
        )
      } else if (widget == "date") {
        htmltools::htmlDependency(
          name = "date_Input",
          version = version,
          src = c(href = "shinyGovstyle/js"),
          script = "date_input_binding.js"
        )
      } else if (widget == "accordion") {
        htmltools::htmlDependency(
          name = "accordion",
          version = version,
          src = c(href = "shinyGovstyle/js"),
          script = "accordion.js"
        )
      } else if (widget == "govTab") {
        htmltools::htmlDependency(
          name = "govTab",
          version = version,
          src = c(href = "shinyGovstyle/js"),
          script = "govTab.js"
        )
      } else if (widget == "contents_link") {
        htmltools::htmlDependency(
          name = "contents_link",
          version = version,
          src = c(href = "shinyGovstyle/js"),
          script = "contents_link.js"
        )
      } else if (widget == "service_navigation") {
        htmltools::htmlDependency(
          name = "service_navigation",
          version = version,
          src = c(href = "shinyGovstyle/js"),
          script = "service_navigation.js"
        )
      } else if (widget == "reactable") {
        htmltools::htmlDependency(
          name = "reactable-overrides",
          version = version,
          src = c(href = "shinyGovstyle/css"),
          stylesheet = "reactable-overrides.css"
        )
      }

      if (!is.null(widget_dep)) {
        dep <- c(dep, list(widget_dep))
      }
    }

    # htmlwidgets' rendering path (htmlwidgets:::toHTML.htmlwidget) only reads
    # `widget$dependencies` and silently drops anything attached via
    # `htmltools::attachDependencies()`. Branch on the object type so callers
    # don't have to.
    if (inherits(tag, "htmlwidget")) {
      dep_list <- if (is.list(dep) && !inherits(dep, "html_dependency")) {
        dep
      } else {
        list(dep)
      }
      tag$dependencies <- c(tag$dependencies, dep_list)
      tag
    } else {
      htmltools::attachDependencies(tag, dep, append = TRUE)
    }
  }
