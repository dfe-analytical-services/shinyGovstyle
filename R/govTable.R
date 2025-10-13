#' Table Function
#'
#' This function inserts a gov styled table. Format is with header looking
#' rows and columns
#' @param inputId Input Id for the table
#' @param df expects a dataframe to create a table
#' @param caption adds a caption to the table as a header
#' @param caption_size adjust the size of caption. Options are s, m, l, xl,
#' with l as the default
#' @param num_col adds numeric class format to these columns
#' @param width_overwrite change width. Need to include width for every column.
#' Columns must add up to 1.
#' Options are three-quarters, two-thirds, one-half, one-third, one-quarter.
#' Default is `NULL`
#' @return a table HTML shiny tag object
#' @keywords table
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     shinyGovstyle::govTable(
#'       "tab1",
#'       shinyGovstyle::transport_data_small,
#'       "Test",
#'       "l",
#'       num_col = c(2,3),
#'       width_overwrite = c("one-half", "one-quarter", "one-quarter")
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
govTable <- # nolint
  function(
    inputId, # nolint
    df,
    caption,
    caption_size = "l",
    num_col = NULL,
    width_overwrite = NULL
  ) {
    # Create row by row the main bulk of table to insert later
    main_row_store <- NULL
    for (i in seq_len(nrow(df))) {
      temp_row_store <- create_rows(df[i, ], num_col)
      main_row_store <- shiny::tagList(temp_row_store, main_row_store)
    }

    # Create the actual table
    gov_table <- shiny::tags$table(
      id = inputId,
      class = "govuk-table",
      shiny::tags$caption(
        class = paste0(
          "govuk-table__caption govuk-table__caption--",
          caption_size
        ),
        style = "caption-side: top;",
        caption
      ),
      shiny::tags$thead(
        class = "govuk-table__head",
        shiny::tags$tr(
          class = "govuk-table__row",
          Map(
            function(x) {
              shiny::tags$th(scope = "col", class = "govuk-table__header", x)
            },
            x = colnames(df)
          )
        )
      ),
      shiny::tags$tbody(
        class = "govuk-table__body",
        main_row_store
      )
    )

    # Change class of headers to numeric if requested
    for (i in num_col) {
      if (i != 1) {
        gov_table$children[[2]]$children[[1]][[3]][[1]][[i]]$attribs$class <-
          "govuk-table__header govuk-table__header--numeric"
      }
    }

    # Change width of columns if requested
    if (!is.null(width_overwrite)) {
      for (i in seq_along(width_overwrite)) {
        gov_table$children[[2]]$children[[1]][[3]][[1]][[i]]$attribs$class <-
          paste0(
            gov_table$children[[2]]$children[[1]][[3]][[1]][[i]]$attribs$class,
            " govuk-!-width-",
            width_overwrite[i]
          )
      }
    }

    shinyGovstyle::attachDependency(gov_table)
  }

create_rows <- function(df_row, num_col = NULL) {
  row_html <- shiny::tags$tr(
    class = "govuk-table__row",
    shiny::tags$th(scope = "row", class = "govuk-table__header", df_row[1, 1]),
    Map(
      function(x) {
        shiny::tags$td(class = "govuk-table__cell", x)
      },
      df_row[1, -1]
    )
  )
  #Not sure I can think of better way to add numeric class then do it post
  #creating the table rows
  for (i in num_col) {
    if (i != 1) {
      row_html$children[[2]][[i - 1]]$attribs$class <-
        "govuk-table__cell govuk-table__cell--numeric"
    }
  }
  return(row_html)
}
