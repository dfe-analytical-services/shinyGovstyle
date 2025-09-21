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
#' @param ... Additional arguments passed to `reactable::reactable`
#' @return A `reactable` HTML widget styled with GOV.UK classes
#' @keywords table, reactable, GOV.UK
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
#' }
govReactable <- # nolint
  function(
    df,
    right_col = NULL,
    page_size = 10,
    highlight = TRUE,
    borderless = TRUE,
    min_widths = list(),
    ...
  ) {
    # Generate column definitions
    col_defs <- stats::setNames(
      lapply(seq_along(names(df)), function(index) {
        col <- names(df)[index]

        reactable::colDef(
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
    return(table)
  }

#' Shiny bindings for govReactable
#' Output and render functions for using govReactable within shiny apps
#'
#' @param output_table_name Output variable to read from.
#' @param caption Adds a caption to the table as a header
#' @param caption_size Adjust the size of caption
#' Options are s, m, l, xl, with l as the default
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
#' can be assigned to a Shiny output slot.
#'
#' @name govReactable-shiny
#'
#' @examples
#' ui <- fluidPage(
#'   titlePanel("govReactableOutput example"),
#'   govReactableOutput("table")
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

    return(htmltools::div(
      heading_tag,
      reactable::reactableOutput(output_table_name)
    ))
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
