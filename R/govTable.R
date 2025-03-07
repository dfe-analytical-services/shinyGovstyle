#' Table Function
#'
#' This function inserts a government-styled table using `reactable`.
#'
#' @param inputId A unique input ID for the table.
#' @param df A dataframe used to generate the table.
#' @param caption A text caption displayed above the table as a heading.
#' @param caption_size Defines the size of the caption text. Options: "s", "m", "l", "xl" (default: "l").
#' @param right_col A vector of column names that should be right-aligned. By default, numeric data is right-aligned, and character data is left-aligned.
#' @param col_widths A named list specifying column widths using width classes (e.g., "one-quarter", "two-thirds").
#' @param page_size The default number of rows displayed per page (default: 10).
#' @return A `reactable` HTML widget styled with GOV.UK classes.
#' @keywords table, reactable, GOV.UK
#' @export
#' @examples
#' if (interactive()) {
#'
#'   Months <- rep(c("January", "February", "March", "April", "May"), times = 2)
#'   Colours <- rep(c("Red", "Blue"), times = 5)
#'   Bikes <- c(85, 75, 165, 90, 80, 95, 85, 175, 100, 95)
#'   Cars <- c(95, 55, 125, 110, 70, 120, 60, 130, 115, 90)
#'   Vans <- c(150, 130, 180, 160, 140, 175, 135, 185, 155, 145)
#'   Buses <- c(200, 180, 220, 210, 190, 215, 185, 225, 205, 195)
#'   example_data <- data.frame(Months, Colours, Bikes, Cars, Vans, Buses)
#'
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::banner(
#'       inputId = "banner", type = "beta", 'This is a new service'),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       govTable(
#'         "tab1", example_data, "Test Table", "l",
#'         right_col = c("Colours", "Bikes", "Cars", "Vans", "Buses"),
#'         col_widths = list(Months = "one-third"),
#'         page_size = 5
#'         )
#'     ),
#'
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'
#'   shinyApp(ui, server)
#' }

govTable <- function(inputId, df, caption, caption_size = "l",
                      right_col = NULL,
                      col_widths = list(),
                      page_size = 10) {

  # Generate column definitions
  col_defs <- stats::setNames(lapply(seq_along(names(df)), function(index) {
    col <- names(df)[index]

    # Set width class if specified in col_widths
    col_class <- if (!is.null(col_widths[[col]])) {
      paste0("govuk-!-width-", col_widths[[col]])
    } else {
      ""
    }

    # Apply right alignment class if column is in right_col
    right_class <- if (col %in% right_col) "govTable_right_align" else ""

    reactable::colDef(
      name = col,
      sortable = TRUE,
      headerClass = paste(col_class, right_class),
      class = paste(col_class, right_class)
    )
  }), names(df))

  table <- reactable::reactable(
    df,
    columns = col_defs,
    searchable = FALSE,
    sortable = TRUE,
    pagination = TRUE,
    defaultPageSize = page_size,
    highlight = TRUE,
    fullWidth = TRUE,
    class = "govuk-table"
  )

  return(htmltools::div(
    htmltools::tags$div(
      class = paste0("govuk-table__caption govuk-table__caption--", caption_size),
      caption
    ),
    table
  ))
}
