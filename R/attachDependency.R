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

    dep <- htmltools::htmlDependency(
      name = "stylecss",
      version = version,
      src = c(href = "shinyGovstyle/css"),
      stylesheet = "govuk-frontend-6.1.0.min.css"
    )

    if (!is.null(widget)) {
      if (widget == "radio") {
        dep <- list(
          dep,
          htmltools::htmlDependency(
            name = "radio_button_Input",
            version = version,
            src = c(href = "shinyGovstyle/js"),
            script = "radio_button_input_binding.js"
          )
        )
      } else if (widget == "date") {
        dep <- list(
          dep,
          htmltools::htmlDependency(
            name = "date_Input",
            version = version,
            src = c(href = "shinyGovstyle/js"),
            script = "date_input_binding.js"
          )
        )
      } else if (widget == "accordion") {
        dep <- list(
          dep,
          htmltools::htmlDependency(
            name = "accordion",
            version = version,
            src = c(href = "shinyGovstyle/js"),
            script = "accordion.js"
          )
        )
      } else if (widget == "govTab") {
        dep <- list(
          dep,
          htmltools::htmlDependency(
            name = "govTab",
            version = version,
            src = c(href = "shinyGovstyle/js"),
            script = "govTab.js"
          )
        )
      } else if (widget == "contents_link") {
        dep <- list(
          dep,
          htmltools::htmlDependency(
            name = "contents_link",
            version = version,
            src = c(href = "shinyGovstyle/js"),
            script = "contents_link.js"
          )
        )
      } else if (widget == "service_navigation") {
        dep <- list(
          dep,
          htmltools::htmlDependency(
            name = "service_navigation",
            version = version,
            src = c(href = "shinyGovstyle/js"),
            script = "service_navigation.js"
          )
        )
      } else if (widget == "reactable") {
        dep <- list(
          dep,
          htmltools::htmlDependency(
            name = "reactable-overrides",
            version = version,
            src = c(href = "shinyGovstyle/css"),
            stylesheet = "reactable-overrides.css"
          )
        )
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
