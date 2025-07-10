#' Tabs Function
#'
#' This function creates a tabs based table.  It requires a single dataframe
#' with a grouping variable
#' @param inputId The id to access the tag
#' @param df A single dataframe with all data.  See example for structure.
#' @param group_col The column name with the groups to be used as tabs
#' @return a tab table html shiny object.
#' @keywords tab table
#' @export
#' @examples
#' if (interactive()) {
#'
#'   # Create an example dataset
#'   tabs <- c(rep("Past Day", 3),
#'             rep("Past Week", 3),
#'             rep("Past Month", 3),
#'             rep("Past Year", 3))
#'   Case_manager <- rep(c("David Francis", "Paul Farmer", "Rita Patel"),4)
#'   Cases_open <- c(3, 1, 2, 24, 16, 24, 98, 122, 126, 1380, 1129, 1539)
#'   Cases_closed <- c(0, 0, 0, 18, 20, 27, 95, 131, 142, 1472, 1083, 1265)
#'   data <- data.frame(tabs, Case_manager, Cases_open, Cases_closed)
#'
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::gov_layout(size = "two-thirds",
#'       shinyGovstyle::govTabs(data, "tabs")),
#'     shinyGovstyle::footer(full = TRUE)
#'   )
#'
#'   server <- function(input, output, session) {}
#'   shinyApp(ui = ui, server = server)
#' }

govTabs <- function(inputId, df, group_col) {
  tabs <- unique(df[[group_col]])
  tab_headers <- create_tabs(tabs, inputId)

  #Select the first tab as the selected one
  tab_headers$children[[1]][[1]]$attribs$class <-
    "govuk-tabs__list-item govuk-tabs__list-item--selected"

  main_temp_hold <- NULL
  #This needs to make up the tables on each tab
  for (i in tabs) {
    #filter through tabs and drop the grouping value
    temp_table <- df[df[[group_col]] == i, ]
    temp_table[group_col] <- NULL
    #Create row by row the main bulk of table to insert later
    main_row_store <- NULL
    for (j in 1:nrow(temp_table)) {
      temp_row_store <- create_tab_row(temp_table[j, ])
      main_row_store <- shiny::tagList(temp_row_store, main_row_store)
    }

    temp_hold <- create_tab_table(temp_table, main_row_store, i, inputId)
    main_temp_hold <- shiny::tagList(main_temp_hold, temp_hold)
  }

  #Put the lime with coconut and create the final thing
  main_tab_div <- shiny::tags$div(
    class = "govuk-frontend-supported",
    shiny::tags$h2(class = "govuk-tabs__title", "Contents"),
    tab_headers,
    main_temp_hold
  )

  #unhide first tab
  main_tab_div$children[[3]][[1]][[1]][[1]][[2]][[2]]$class <-
    "govuk-tabs__panel"

  attachDependency(main_tab_div, "govTab")
}


create_tab_table <- function(df, rows, tab, inputId) {
  shiny::tags$div(
    class = "govuk-tabs__panel govuk-tabs__panel--hidden",
    id = tolower(gsub(" ", "-", tab)),
    name = paste0(tolower(gsub(" ", "-", tab)), "-", inputId, "-table"),
    shiny::tags$h2(class = "govuk-heading-l", tab),
    shiny::tags$table(
      class = "govuk-table",
      shiny::tags$thead(
        class = "govuk-table__head",
        shiny::tags$tr(
          class = "govuk-table__row",
          Map(
            function(x) {
              shiny::tags$th(
                scope = "col",
                class = "govuk-table__header",
                x
              )
            },
            x = colnames(df)
          )
        )
      ),
      shiny::tags$tbody(
        class = "govuk-table__body",
        rows
      )
    )
  )
}

create_tab_row <- function(df_row) {
  rowHTML <- shiny::tags$tr(
    class = "govuk-table__row",
    Map(
      function(x) {
        shiny::tags$td(class = "govuk-table__cell", x)
      },
      x = df_row
    )
  )
}

create_tabs <- function(tabs_names, inputId) {
  shiny::tags$ul(
    class = "govuk-tabs__list",
    id = paste0(inputId, "tab"),
    Map(
      function(x) {
        shiny::tags$li(
          name = paste0(tolower(gsub(" ", "-", x)), "-t"),
          id = paste0(tolower(gsub(" ", "-", x)), "-test"),
          class = "govuk-tabs__list-item",
          shiny::tags$a(
            class = "govuk-tabs__tab",
            name = paste0(tolower(gsub(" ", "-", x)), "-l"),
            id = paste0(tolower(gsub(" ", "-", x)), "-l-test"),
            href = paste0("#", tolower(gsub(" ", "-", x))),
            x
          )
        )
      },
      x = tabs_names
    )
  )
}
