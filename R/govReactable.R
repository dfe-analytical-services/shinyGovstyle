#' Interactive govTable
#'
#' This function inserts a government-styled table using `reactable`.
#' You can use this in R markdown or Quarto documents, or use
#' renderGovReactable({}) and govReactableOutput() for tables in R Shiny.
#' govReactableOutput() gives the ability to add a caption, for static
#' tables made using just govReactable(), use heading_text() to add
#' captions to tables.
#'
#' @param df A dataframe used to generate the table.
#' @param right_col A vector of column names that should be right-aligned.
#' By default, numeric data is right-aligned, and character data is
#' left-aligned.
#' @param col_widths A named list specifying column widths using width
#' classes (e.g., "one-quarter", "two-thirds").
#' @param page_size The default number of rows displayed per page (default: 10).
#' @param ... Additional arguments passed to `reactable::reactable`.
#' @return A `reactable` HTML widget styled with GOV.UK classes.
#' @keywords table, reactable, GOV.UK
#' @export
#' @examples
#' # Example static table using govReactable
#' if (interactive()) {
#'
#'   govReactable(
#'     iris,
#'     right_col = c(
#'      "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"
#'     ),
#'     col_widths = list(Species = "one-third"),
#'     page_size = 5
#'   )
#' }
govReactable <- function(
  df,
  right_col = NULL,
  col_widths = list(),
  page_size = 10,
  ...
) {
  # Generate column definitions
  col_defs <- stats::setNames(
    lapply(seq_along(names(df)), function(index) {
      col <- names(df)[index]

      # Set width class if specified in col_widths
      col_class <- if (!is.null(col_widths[[col]])) {
        paste0("govuk-!-width-", col_widths[[col]])
      } else {
        ""
      }

      # Apply right alignment class if column is in right_col
      right_class <- if (!is.null(right_col) && col %in% right_col) {
        "govTable_right_align"
      } else {
        ""
      }

      reactable::colDef(
        name = col,
        sortable = TRUE,
        headerClass = paste("govuk-table__header", col_class, right_class),
        class = paste("govuk-table__cell", col_class, right_class),
        html = TRUE,
        na = "NA",
        minWidth = 65,
        align = if (!is.null(right_col) && col %in% right_col) {
          "right"
        } else {
          "left"
        }
      )
    }),
    names(df)
  )

  # Create the reactable table
  table <- reactable::reactable(
    df,
    columns = col_defs,
    searchable = FALSE,
    sortable = TRUE,
    pagination = TRUE,
    defaultPageSize = page_size,
    highlight = TRUE,
    borderless = TRUE,
    showSortIcon = FALSE,
    defaultColDef = reactable::colDef(headerClass = "bar-sort-header"),
    resizable = TRUE,
    fullWidth = TRUE,
    rowClass = "govuk-table__row",
    language = reactable::reactableLang(
      searchPlaceholder = "Search table..."
    ),
    theme = reactable::reactableTheme(
      searchInputStyle = list(
        float = "right",
        width = "25%",
        marginBottom = "10px",
        padding = "5px",
        fontSize = "14px",
        border = "1px solid #ccc",
        borderRadius = "5px"
      )
    ),
    class = "gov-table govuk-table",
    ...
  )

  # Attach the govReactable CSS dependency
  dependency <- htmltools::htmlDependency(
    name = "govReactable",
    version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "govReactable.css"
  )

  htmltools::attachDependencies(table, dependency, append = TRUE)
}

#' Shiny bindings for govReactable
#' Output and render functions for using govReactable within shiny apps
#'
#' @param output_table_name Output variable to read from.
#' @param caption Adds a caption to the table as a header.
#' @param caption_size Adjust the size of caption.
#' Options are s, m, l, xl, with l as the default.
#' @param heading_level The HTML heading level for
#' the caption (e.g., "h2", "h3", "h4", "h5"). Default is "h2".
#' @param expr An expression that generates a `reactable` widget.
#' @param env The environment in which to evaluate `expr`.
#' @param quoted Is `expr` a quoted expression (with [quote()])?
#' This is useful if you want to save an expression in a variable.
#' @return `govReactableOutput()` returns a `reactable` output element
#' that can be included in a Shiny UI.
#'
#' `renderGovReactable()` returns a `reactable` render function that
#' can be assigned to a Shiny output slot.
#'
#'@name govReactable-shiny
#'
#' @examples
#' # Run in an interactive R session
#' if (interactive()) {
#'
#' library(shiny)
#' library(shinyGovstyle)
#'
#' ui <- fluidPage(
#'  titlePanel("govReactableOutput example"),
#'  govReactableOutput("table")
#' )
#'
#' server <- function(input, output, session) {
#'   output$table <- renderGovReactable({
#'    govReactable(iris)
#'  })
#' }
#'
#' shinyApp(ui, server)
#' }
#'
#' @export
# Output for reactive tables

govReactableOutput <- function(
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
renderGovReactable <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  reactable::renderReactable(expr, env = env, quoted = TRUE)
}
