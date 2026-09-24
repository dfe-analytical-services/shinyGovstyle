#' Interactive govTable
#'
#' This function inserts a government-styled table using `reactable`.
#' You can use this in R markdown or Quarto documents, or use
#' renderGovReactable({}) and govReactableOutput() for tables in R Shiny.
#' govReactableOutput() gives the ability to add a caption, for static
#' tables made using just govReactable(), use heading_text() to add
#' captions to tables.
#'
#' @description
#' This function is opinionated and sets table defaults that are in
#' keeping with the wider GOV.UK design system. Some defaults are overrideable,
#' such as `highlight=TRUE` and `borderless=TRUE`, however some are fixed, such
#' as `showSortIcon=FALSE` as the default sort icon is inaccessible. Each
#' sortable column heading is a button, so screen readers announce it as
#' something you can select and voice control software can select it by its
#' visible text (see issue #190). Additional arguments from
#' `reactable::reactable` can be passed to customise the table.
#'
#' @param df A dataframe used to generate the table
#' @param right_col A vector of column names that should be right-aligned.
#' By default, numeric data is right-aligned, and character data is
#' left-aligned
#' @param page_size The default number of rows displayed per page (default: 10)
#' @param highlight Highlight table rows on hover
#' @param borderless Remove inner borders from table
#' @param min_widths Customise minimum column width using a list of columns and
#' minimum width in pixels
#' @param columns Customise individual columns, for example to fix the
#' number of decimal places shown. Give a named list, where each name
#' matches a column in `df` and each value is built with
#' `reactable::colDef()` (see examples). Any column left out of this list
#' is unaffected, and keeps govReactable's usual GOV.UK look. For a column
#' you do include, anything you don't set on it, such as sorting or
#' alignment, also keeps that same default. Names that don't match a
#' column in `df` are ignored. A `headerClass` you set is added alongside
#' the GOV.UK sort header styling rather than replacing it, so sortable
#' columns always keep their visible sort indicator. Columns set to
#' `sortable = FALSE` don't show a sort indicator. A custom `header` on a
#' sortable column is placed inside the column's sort button, so it must
#' not contain links or other interactive content. It must be a string, a
#' tag or an R function; a `JS()` header on a sortable column is an error,
#' because the sort button can't be added to it.
#' @param language Language options made with `reactable::reactableLang()`,
#' for example to translate the pagination text. Defaults to the
#' `reactable.language` option, as in `reactable::reactable()`. `sortLabel`
#' is always set to `"{name}"`, so each heading's accessible name matches its
#' visible text, and setting it gives a warning.
#' @param ... Additional arguments passed to `reactable::reactable`
#' @return A `reactable` HTML widget styled with GOV.UK classes
#' @family Govstyle tables tabs and accordions
#' @export
#' @examples
#' # Example static table using govReactable
#' if (interactive()) {
#'   govReactable(
#'     iris,
#'     right_col = c(
#'       "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"
#'     )
#'   )
#'
#'   govReactable(
#'     iris,
#'     right_col = c(
#'       "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"
#'     ),
#'     highlight = FALSE,
#'     page_size = 5,
#'     min_widths = list(
#'       Sepal.Length = 75,
#'       Sepal.Width = 75,
#'       Petal.Length = 75,
#'       Petal.Width = 75
#'     )
#'   )
#'
#'   # Show one column to a fixed number of decimal places, leaving every
#'   # other column and style (sorting, alignment, etc.) untouched
#'   sales_data <- data.frame(
#'     shop = c("Shop A", "Shop B", "Shop C"),
#'     growth = c(4, 4.7, 12.34)
#'   )
#'   govReactable(
#'     sales_data,
#'     columns = list(
#'       growth = reactable::colDef(
#'         format = reactable::colFormat(digits = 1)
#'       )
#'     )
#'   )
#'
#'   # A more involved example: only `percent` is customised, so `region`
#'   # and `count` keep the normal GOV.UK defaults untouched
#'   # (counts shown as whole numbers alongside a percentage column fixed
#'   # to 1 decimal place)
#'   count_pct_data <- data.frame(
#'     region = c("North", "South", "East"),
#'     count = c(1234, 56, 789),
#'     percent = c(4, 4.7, 12.34)
#'   )
#'   govReactable(
#'     count_pct_data,
#'     right_col = c("count", "percent"),
#'     columns = list(
#'       percent = reactable::colDef(
#'         format = reactable::colFormat(digits = 1)
#'       )
#'     )
#'   )
#' }
govReactable <- # nolint
  function(
    df,
    right_col = NULL,
    page_size = 10,
    highlight = TRUE,
    borderless = TRUE,
    min_widths = list(),
    columns = list(),
    language = getOption("reactable.language"),
    ...
  ) {
    # Generate column definitions
    col_defs <- stats::setNames(
      lapply(seq_along(names(df)), function(index) {
        col <- names(df)[index]

        default_col <- reactable::colDef(
          name = col,
          sortable = TRUE,
          header = function(value) sort_header_button(value),
          headerClass = "bar-sort-header",
          html = TRUE,
          na = "NA",
          align = if (!is.null(right_col) && col %in% right_col) {
            "right"
          } else {
            "left"
          },
          minWidth = if (!is.null(min_widths[[col]])) {
            min_widths[[col]]
          } else {
            NULL
          }
        )

        # Merge in any user-supplied colDef for this column, so only the
        # fields the user actually set (non-NULL) override the GOV.UK
        # defaults above. reactable::colDef() renames a handful of its
        # input arguments in its returned object (class -> className,
        # headerClass -> headerClassName, footerClass -> footerClassName,
        # defaultSortOrder -> defaultSortDesc), so both `default_col` and
        # the user's colDef are built via reactable::colDef() first
        # (giving both the same *output*-name scheme), then merged
        # directly as list objects instead of re-calling colDef() with
        # the user's already-renamed fields as if they were input names.
        if (!is.null(columns[[col]])) {
          user_fields <- Filter(Negate(is.null), unclass(columns[[col]]))
          merged_col <- utils::modifyList(unclass(default_col), user_fields)
          merged_col$headerClassName <- sort_header_class(merged_col)
          merged_col["header"] <- list(
            sort_header_render(merged_col, user_fields$header)
          )
          structure(merged_col, class = "colDef")
        } else {
          default_col
        }
      }),
      names(df)
    )

    # Create the reactable table
    table <- reactable::reactable(
      df,
      columns = col_defs,
      defaultPageSize = page_size,
      highlight = highlight,
      borderless = borderless,
      showSortIcon = FALSE,
      language = govuk_reactable_lang(language),
      fullWidth = TRUE,
      wrap = TRUE,
      class = "gov-table govuk-table",
      ...
    )

    attachDependency(table, widget = "reactable")
  }

# The permanent sort chevron, larger click target and active-sort bar in
# reactable-overrides.css all hang off the `bar-sort-header` class, so it is
# fixed rather than overridable: a user's `headerClass` from `columns` is added
# alongside it instead of replacing it (#190). A column the user makes
# unsortable drops the class, so its header doesn't advertise a sort it can't
# perform.
sort_header_class <- function(col_def) {
  classes <- if (is.null(col_def$headerClassName)) {
    character(0)
  } else {
    unlist(strsplit(col_def$headerClassName, "\\s+"))
  }
  classes <- setdiff(classes[nzchar(classes)], "bar-sort-header")

  if (isTRUE(col_def$sortable)) {
    classes <- c("bar-sort-header", classes)
  }

  if (length(classes) == 0) {
    NULL
  } else {
    paste(classes, collapse = " ")
  }
}

# reactable renders a sortable header as a `div role="columnheader"` with its
# own click handler but no button role, so screen readers don't announce it
# as something you can select and voice control can't target it (#190). A
# native button inside the header gives it that role, following the MOJ and
# ONS sortable table patterns. Clicks on the button bubble up to reactable's
# handler, so reactable still does the sorting and keeps `aria-sort` on the
# columnheader. govreactable.js removes the columnheader's own tab stop and
# stops Enter/Space on the button from also reaching reactable's keypress
# handler, which would otherwise sort twice.
sort_header_button <- function(content) {
  shiny::tags$button(type = "button", class = "gov-sort-button", content)
}

# Decide the header for a column the user customised through `columns`. A
# sortable column gets the sort button, wrapped around the user's own header
# if they set one. An unsortable column keeps the user's header (or
# reactable's default) with no button, as there is nothing to select.
sort_header_render <- function(col_def, user_header) {
  if (!isTRUE(col_def$sortable)) {
    return(user_header)
  }

  if (is.null(user_header)) {
    function(value) sort_header_button(value)
  } else if (inherits(user_header, "JS_EVAL")) {
    stop(
      "govReactable() can't add its accessible sort button to a JS() ",
      "header. Use a string, a tag or an R function for the header of a ",
      "sortable column, or set `sortable = FALSE` for it."
    )
  } else if (is.function(user_header)) {
    function(value, name) {
      sort_header_button(call_header_function(user_header, value, name))
    }
  } else {
    function(value) sort_header_button(user_header)
  }
}

# reactable calls a header function with only as many of (value, name) as it
# has arguments, so a user's `function(value)` keeps working once wrapped.
call_header_function <- function(fn, value, name) {
  arg_names <- names(formals(fn))
  n_args <- if ("..." %in% arg_names) 2L else min(length(arg_names), 2L)
  do.call(fn, list(value, name)[seq_len(n_args)])
}

# `sortLabel` sets the columnheader's aria-label. reactable's "Sort {name}"
# doesn't match the visible heading text (WCAG 2.5.3, #190), so it is fixed
# to "{name}". Any other language setting the user passes is kept.
govuk_reactable_lang <- function(language) {
  if (is.null(language)) {
    return(reactable::reactableLang(sortLabel = "{name}"))
  }

  user_sort_label <- language$sortLabel
  if (!is.null(user_sort_label) && !identical(user_sort_label, "{name}")) {
    warning(
      "govReactable() ignores `sortLabel` in `language` and always uses ",
      "\"{name}\", so each heading's accessible name matches its visible text."
    )
  }

  do.call(
    reactable::reactableLang,
    utils::modifyList(unclass(language), list(sortLabel = "{name}"))
  )
}

#' Shiny bindings for govReactable
#' Output and render functions for using govReactable within shiny apps
#'
#' @param output_table_name Output variable to read from
#' @param caption Adds a caption to the table as a header
#' @param caption_size Adjust the size of caption. One of `"s"`, `"m"`, `"l"`,
#' `"xl"`, with `"l"` as the default. Any other value throws an error.
#' @param heading_level The HTML heading level for
#' the caption (e.g., "h2", "h3", "h4", "h5"). Default is "h2"
#' @param expr An expression that generates a `reactable` widget
#' @param env The environment in which to evaluate `expr`
#' @param quoted Is `expr` a quoted expression (with [quote()])?
#' This is useful if you want to save an expression in a variable
#' @return `govReactableOutput()` returns a `reactable` output element
#' that can be included in a Shiny UI
#'
#' `renderGovReactable()` returns a `reactable` render function that
#' can be assigned to a Shiny output slot
#'
#' @name govReactable-shiny
#' @family Govstyle tables tabs and accordions
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   govReactableOutput(
#'     "table",
#'     caption = "Example table"
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   output$table <- renderGovReactable({
#'     govReactable(iris)
#'   })
#' }
#'
#' if (interactive()) shinyApp(ui, server)
#' @export
govReactableOutput <- # nolint
  function(
    output_table_name,
    caption,
    caption_size = "l",
    heading_level = "h2"
  ) {
    validate_gds_text_size(caption_size, "caption_size")

    # Validate heading_level input
    allowed_levels <- c("h2", "h3", "h4", "h5")
    if (!heading_level %in% allowed_levels) {
      stop(
        "heading_level must be one of: ",
        paste(allowed_levels, collapse = ", ")
      )
    }

    heading_tag <- do.call(
      shiny::tags[[heading_level]],
      list(
        class = paste0("govuk-heading-", caption_size),
        caption
      )
    )

    htmltools::div(
      heading_tag,
      reactable::reactableOutput(output_table_name)
    )
  }

# use renderReactable to render the govTables - naming just for convention
# This function wraps reactable::renderReactable.
#' @rdname govReactable-shiny
#' @export
renderGovReactable <- # nolint
  function(
    expr,
    env = parent.frame(),
    quoted = FALSE
  ) {
    if (!quoted) {
      expr <- substitute(expr)
    }
    reactable::renderReactable(expr, env = env, quoted = TRUE)
  }
