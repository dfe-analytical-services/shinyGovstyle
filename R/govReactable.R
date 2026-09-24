#' Interactive govTable
#'
#' This function inserts a government-styled table using `reactable`.
#' You can use this in R markdown or Quarto documents, or use
#' renderGovReactable({}) and govReactableOutput() for tables in R Shiny.
#' Pass `caption` to add a heading that is programmatically linked to the
#' table (via `aria-labelledby`), so screen reader users know what the table
#' is about.
#'
#' @description
#' This function is opinionated and sets table defaults that are in
#' keeping with the wider GOV.UK design system. Some defaults are overrideable,
#' such as `highlight=TRUE` and `borderless=TRUE`, however some are fixed, such
#' as `showSortIcon=FALSE` as the default sort icon is inaccessible. Additional
#' arguments from `reactable::reactable` can be passed to customise the table.
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
#' column in `df` are ignored.
#' @param caption Adds a caption to the table as a heading, linked to the
#' table via `aria-labelledby`. `NULL` (default) renders the table with no
#' caption.
#' @param caption_size Adjust the size of caption. One of `"s"`, `"m"`, `"l"`,
#' `"xl"`, with `"l"` as the default. Any other value throws an error.
#' @param heading_level Heading level for the caption, an integer between 1
#' and 6. Defaults to 2
#' @param ... Additional arguments passed to `reactable::reactable`
#' @return A `reactable` HTML widget styled with GOV.UK classes, or (if
#' `caption` is supplied) that widget together with a linked caption heading
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
#'   # Add a caption linked to the table for screen reader users
#'   govReactable(
#'     iris,
#'     caption = "Iris measurements",
#'     right_col = c(
#'       "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"
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
    caption = NULL,
    caption_size = "l",
    heading_level = 2,
    ...
  ) {
    # Generate column definitions
    col_defs <- stats::setNames(
      lapply(seq_along(names(df)), function(index) {
        col <- names(df)[index]

        default_col <- reactable::colDef(
          name = col,
          sortable = TRUE,
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
      fullWidth = TRUE,
      wrap = TRUE,
      class = "gov-table govuk-table",
      ...
    )

    table <- attachDependency(table, widget = "reactable")

    if (is.null(caption)) {
      return(table)
    }

    cap <- reactable_caption(caption, caption_size, heading_level)
    htmltools::tagList(
      cap$tag,
      htmltools::tags$div(
        role = "region",
        `aria-labelledby` = cap$id,
        table
      )
    )
  }

# Internal helper: builds the caption heading shared by govReactable() and
# govReactableOutput(), reusing clean_heading_text() (the same slugifier
# heading_text() uses) to generate an id, so the caller can link the table to
# the heading via aria-labelledby.
reactable_caption <- function(caption, caption_size, heading_level) {
  validate_heading_level(heading_level)
  validate_gds_text_size(caption_size, "caption_size")

  id <- clean_heading_text(caption)
  tag <- build_heading_tag(
    heading_level,
    caption,
    paste0("govuk-heading-", caption_size),
    id
  )

  list(tag = tag, id = id)
}

# Internal helper: govReactableOutput() shipped in CRAN release 0.2.0 with a
# string heading_level ("h2"-"h5"), before the rest of the package's integer
# 1-6 convention existed. Accept the old strings for one deprecation cycle
# (removal planned for 1.0.0) so 0.2.0 callers don't break outright.
coerce_heading_level <- function(heading_level) {
  if (!is.character(heading_level)) {
    return(heading_level)
  }

  lifecycle::deprecate_warn(
    when = "0.3.0",
    what = I("govReactableOutput(heading_level = 'a \"h2\"-style string')"),
    with = I("an integer between 1 and 6, e.g. heading_level = 2")
  )

  if (!grepl("^h[1-6]$", heading_level)) {
    stop(
      "heading_level must be an integer between 1 and 6 ",
      "(or a deprecated \"h1\"-\"h6\" string).",
      call. = FALSE
    )
  }
  as.integer(sub("^h", "", heading_level))
}

#' Shiny bindings for govReactable
#' Output and render functions for using govReactable within shiny apps
#'
#' @param output_table_name Output variable to read from
#' @param caption Adds a caption to the table as a header
#' @param caption_size Adjust the size of caption. One of `"s"`, `"m"`, `"l"`,
#' `"xl"`, with `"l"` as the default. Any other value throws an error.
#' @param heading_level Heading level for the caption, an integer between 1
#' and 6. Defaults to 2. A string such as `"h2"` is also accepted for
#' backwards compatibility but is deprecated (emits a warning) and will be
#' removed in a future version; use the integer form instead
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
    heading_level = 2
  ) {
    heading_level <- coerce_heading_level(heading_level)
    cap <- reactable_caption(caption, caption_size, heading_level)

    htmltools::div(
      cap$tag,
      htmltools::tags$div(
        role = "region",
        `aria-labelledby` = cap$id,
        reactable::reactableOutput(output_table_name)
      )
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
