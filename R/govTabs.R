#' Tabs Function
#'
#' This function creates a tabs based table. It requires a single dataframe
#' with a grouping variable.
#'
#' Every tab and panel id is prefixed with `inputId`, so several `govTabs()`
#' on one page work independently, even when they share the same group
#' values. The first tab is selected when the page loads.
#' @inheritParams id_arg
#' @param df A single dataframe with all data. See example for structure
#' @param group_col The column name with the groups to be used as tabs
#' @return a tab table HTML shiny tag object
#' @family Govstyle tables tabs and accordions
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png",
#'     logo_alt_text = "Ministry of Justice logo"
#'   ),
#'   shinyGovstyle::gov_main_layout(
#'     shinyGovstyle::govTabs("tabs", shinyGovstyle::case_data, "tabs")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {}
#' if (interactive()) shinyApp(ui = ui, server = server)
govTabs <- # nolint
  function(
    inputId, # nolint
    df,
    group_col
  ) {
    tabs <- as.character(unique(df[[group_col]]))
    tab_ids <- tab_slugs(tabs)
    is_first <- seq_along(tabs) == 1L
    value_cols <- setdiff(names(df), group_col)

    panels <- lapply(seq_along(tabs), function(i) {
      # Filter to this tab's rows and drop the grouping column. drop = FALSE
      # keeps a data frame when only one value column is left.
      temp_table <- df[
        which(df[[group_col]] == tabs[[i]]),
        value_cols,
        drop = FALSE
      ]
      rows <- lapply(seq_len(nrow(temp_table)), function(j) {
        create_tab_row(temp_table[j, , drop = FALSE])
      })
      create_tab_table(
        temp_table,
        rows,
        tabs[[i]],
        tab_ids[[i]],
        inputId,
        is_first[[i]]
      )
    })

    main_tab_div <- shiny::tags$div(
      # govuk-frontend-supported switches on the tabs layout in the GOV.UK
      # stylesheet. GOV.UK puts it on <body> once its own JS has loaded, which
      # shinyGovstyle does not do, so it goes on the component instead.
      class = "govuk-tabs govuk-frontend-supported",
      id = inputId,
      shiny::tags$h2(class = "govuk-tabs__title", "Contents"),
      create_tabs(tabs, tab_ids, inputId, is_first),
      panels
    )

    attachDependency(main_tab_div, "govTab")
  }

# Turn tab labels into unique, selector-safe id fragments.
tab_slugs <- function(tabs) {
  slugs <- gsub("[^a-z0-9]+", "-", tolower(tabs))
  slugs <- gsub("^-+|-+$", "", slugs)
  slugs[slugs == ""] <- "tab"
  make.unique(slugs, sep = "-")
}

tab_id <- function(input_id, slug) {
  paste0(input_id, "-tab-", slug)
}

panel_id <- function(input_id, slug) {
  paste0(input_id, "-panel-", slug)
}

create_tab_table <- function(
  df,
  rows,
  tab,
  slug,
  inputId, # nolint
  is_first
) {
  shiny::tags$div(
    class = if (is_first) {
      "govuk-tabs__panel"
    } else {
      "govuk-tabs__panel govuk-tabs__panel--hidden"
    },
    id = panel_id(inputId, slug),
    role = "tabpanel",
    `aria-labelledby` = tab_id(inputId, slug),
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
  shiny::tags$tr(
    class = "govuk-table__row",
    Map(
      function(x) {
        shiny::tags$td(class = "govuk-table__cell", x)
      },
      x = df_row
    )
  )
}

create_tabs <- function(
  tabs_names,
  slugs,
  inputId, # nolint
  is_first
) {
  shiny::tags$ul(
    class = "govuk-tabs__list",
    role = "tablist",
    Map(
      function(x, slug, first) {
        shiny::tags$li(
          class = if (first) {
            "govuk-tabs__list-item govuk-tabs__list-item--selected"
          } else {
            "govuk-tabs__list-item"
          },
          role = "presentation",
          shiny::tags$a(
            class = "govuk-tabs__tab",
            id = tab_id(inputId, slug),
            href = paste0("#", panel_id(inputId, slug)),
            role = "tab",
            tabindex = if (first) "0" else "-1",
            `aria-selected` = if (first) "true" else "false",
            `aria-controls` = panel_id(inputId, slug),
            x
          )
        )
      },
      x = tabs_names,
      slug = slugs,
      first = is_first,
      USE.NAMES = FALSE
    )
  )
}
