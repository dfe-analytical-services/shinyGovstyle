#' Table Function
#'
#' This function inserts a government-styled table using `reactable`.
#'
#' @param inputId Input ID for the table.
#' @param df A dataframe to create a table.
#' @param caption Adds a caption to the table as a header.
#' @param caption_size Adjust the size of the caption. Options are "s", "m", "l", "xl" (default: "l").
#' @param num_col A vector of column names to format as numeric (right-aligned).
#' @param col_widths A named list specifying column widths using shorthand values (e.g., "one-quarter", "two-thirds").
#' @param defaultPageSize The default number of rows per page (default: 10).
#' @param pageSizeOptions A vector of available page size options (default: `c(5, 10, 25, 50)`).
#' @return A `reactable` HTML widget object.
#' @keywords table
#' @export
#' @examples
#' if (interactive()) {
#'
#'   Months <- rep(c("January", "February", "March", "April", "May"), times = 2)
#'   Bikes <- c(85, 75, 165, 90, 80, 95, 85, 175, 100, 95)
#'   Cars <- c(95, 55, 125, 110, 70, 120, 60, 130, 115, 90)
#'   Trucks <- c(150, 130, 180, 160, 140, 175, 135, 185, 155, 145)
#'   Buses <- c(200, 180, 220, 210, 190, 215, 185, 225, 205, 195)
#'   example_data <- data.frame(Months, Bikes, Cars, Trucks, Buses)
#'
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::banner(
#'       inputId = "banner", type = "beta", 'This is a new service'),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'     govTable(
#'       "tab1", example_data, "Test Table", "l",
#'       num_col = c("Bikes", "Cars", "Trucks", "Buses"),
#'       col_widths = list(Months = "one-third"),
#'       defaultPageSize = 5, pageSizeOptions = c(5, 10, 20))
#'     ),
#'
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'
#'   shinyApp(ui, server)
#' }

govTable2 <- function(inputId, df, caption, caption_size = "l",
                      num_col = NULL,
                      col_widths = list(),
                      defaultPageSize = 10, pageSizeOptions = c(5, 10, 25, 50)) {

  map_width_class <- function(width) {
    if (!is.null(width)) {
      paste0("govuk-!-width-", width)
    } else {
      ""
    }
  }

  # Ensure column headers are formatted correctly for accessibility
  col_defs <- setNames(lapply(seq_along(names(df)), function(index) {
    col <- names(df)[index]
    col_class <- map_width_class(col_widths[[col]])
    reactable::colDef(
      name = col,
      align = ifelse(col %in% num_col, "right", "left"),
      sortable = TRUE,
      headerClass = paste("govuk-table__header", col_class),
      class = paste(
        ifelse(index == 1, "govuk-table__cell govuk-table__header govuk-table__header--bold",
               ifelse(col %in% num_col, "govuk-table__cell govuk-table__cell--numeric", "govuk-table__cell")),
        col_class
      )
    )
  }), names(df))

  table <- reactable::reactable(
    df,
    columns = col_defs,
    searchable = FALSE,
    sortable = TRUE,
    pagination = TRUE,
    defaultPageSize = defaultPageSize,
    pageSizeOptions = pageSizeOptions,
    highlight = TRUE,
    fullWidth = TRUE,
    defaultColDef = reactable::colDef(
      headerClass = "govuk-table__header",
      html = TRUE,
      na = "NA",
      minWidth = 100,  # Ensure all columns have enough width
      align = "left",
      class = "govuk-table__cell"
    ),
    rowClass = "govuk-table__row",
    language = reactable::reactableLang(
      searchPlaceholder = "Search table..."
    ),
    class = "govuk-table"
  )

  # Wrap the table in a scrollable container to prevent clipping or wrapping
  return(htmltools::div(
    style = "overflow-x: auto; width: 100%; max-width: 100vw;",
    htmltools::tags$div(
      class = paste("govuk-table__caption", paste0("govuk-table__caption--", caption_size)),
      caption
    ),
    table
  ))
}
