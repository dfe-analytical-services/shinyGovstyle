#' Interactive govTable
#'
#' Adds a GOV.UK styled table to a Shiny app using `reactable`. Put it
#' straight into the UI for data that doesn't change, or use
#' `renderGovReactable()` and `govReactableOutput()` for data that does. Pass
#' `caption` to add a heading that screen readers link to the table.
#'
#' @description
#' This function sets table defaults that follow the GOV.UK design system. Some
#' can be changed, such as `highlight` and `borderless`. Others are fixed, such
#' as `showSortIcon = FALSE`, because the default sort icon is not accessible.
#' Each sortable heading is a button, so screen readers announce it and voice
#' control can select it by its visible text. Other arguments for
#' `reactable::reactable` can be passed in `...`.
#'
#' @param df A dataframe used to generate the table
#' @param right_col A vector of extra column names to right-align. Numeric
#' columns are right-aligned automatically, as GOV.UK guidance says numbers
#' should be right-aligned. Use this for numbers stored as text, such as
#' `"£85"`. To left-align a numeric column, set
#' `reactable::colDef(align = "left")` for it in `columns`
#' @param page_size The default number of rows displayed per page (default: 10)
#' @param highlight Highlight table rows on hover
#' @param borderless Remove inner borders from table
#' @param min_widths Customise minimum column width using a list of columns and
#' minimum width in pixels
#' @param columns Change individual columns, for example to set the number of
#' decimal places. Give a named list where each name is a column in `df` and
#' each value is made with `reactable::colDef()` (see examples). Columns you
#' leave out keep the GOV.UK defaults, and so does anything you don't set on a
#' column you include. Names that don't match a column are ignored. A
#' `headerClass` is added to the GOV.UK sort header styling, not swapped for
#' it. Columns with `sortable = FALSE` show no sort arrow. A custom `header` on
#' a sortable column goes inside the sort button, so it must not contain links
#' or other interactive content. It must be a string, a tag or an R function. A
#' `JS()` header on a sortable column is an error. Screen readers name a
#' sortable heading from the column's `name`, not its `header`, so if you set a
#' `header`, set `name` to the same text, e.g.
#' `reactable::colDef(name = "Average cost", header = "Average cost")`.
#' @param caption Adds a caption heading that screen readers link to the table
#' (using `aria-labelledby`). Plain text is escaped and shown as written; use
#' `shiny::HTML()` or tags for markup. `NULL` (default) means no caption.
#' For a table built in the server, set the caption on [govReactableOutput()]
#' instead, as [renderGovReactable()] gives an error for a captioned table
#' @inheritParams table_title_params
#' @inheritSection table_title_params Table titles
#' @param caption_size Size of the caption: `"s"`, `"m"`, `"l"` (default) or
#' `"xl"`. Any other value is an error.
#' @param heading_level The caption's heading level, an integer from `1L` to
#' `5L`. Defaults to `2L`. Use `1L` when the table is the main content of the
#' page
#' @param caption_id The id of the caption heading, which the table links to.
#' It must be unique on the page and have no spaces. `NULL` (default) makes a
#' unique id, so you only need this to link to or style the caption yourself.
#' Setting it without a `caption` is an error
#' @param language Language options from `reactable::reactableLang()`, for
#' example to translate the pagination text. Defaults to the
#' `reactable.language` option. `sortLabel` is always `"{name}"` so each
#' heading's accessible name matches its visible text, and setting it gives a
#' warning.
#' @param ... Additional arguments passed to `reactable::reactable`
#' @return A `reactable` widget with GOV.UK classes, or, if `caption` is given,
#' that widget with a caption heading
#' @family Govstyle tables tabs and accordions
#' @export
#' @examples
#' # Tables whose data doesn't change, to put straight into a Shiny app's UI
#' if (interactive()) {
#'   # Numeric columns are right-aligned automatically
#'   govReactable(iris)
#'
#'   # Use right_col for numbers stored as text, such as "£85"
#'   govReactable(
#'     shinyGovstyle::transport_data_small,
#'     right_col = c("bikes", "cars")
#'   )
#'
#'   govReactable(
#'     iris,
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
#'   # Add a caption and subtitle that screen readers link to the table
#'   govReactable(
#'     shinyGovstyle::transport_data,
#'     caption = "Costs peaked in March for every vehicle type",
#'     subtitle = "Cost of bikes, vans and buses (£), January to May"
#'   )
#'
#'   # Show one column to 1 decimal place
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
#'   # Only `percent` is changed, so `region` and `count` keep the defaults
#'   count_pct_data <- data.frame(
#'     region = c("North", "South", "East"),
#'     count = c(1234, 56, 789),
#'     percent = c(4, 4.7, 12.34)
#'   )
#'   govReactable(
#'     count_pct_data,
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
    subtitle = NULL,
    caption_size = "l",
    heading_level = 2L,
    caption_id = NULL,
    language = getOption("reactable.language"),
    ...
  ) {
    heading_level <- govreactable_heading_level(
      heading_level,
      allow_legacy = FALSE
    )
    # Check up front, so a bad value errors even when there is no caption
    validate_gds_text_size(caption_size, "caption_size")
    validate_single_content(caption, "caption")
    validate_single_content(subtitle, "subtitle")
    validate_subtitle_has_caption(caption, subtitle)
    validate_id_has_caption(caption, caption_id)

    # Generate column definitions
    col_defs <- stats::setNames(
      lapply(seq_along(names(df)), function(index) {
        col <- names(df)[index]

        default_col <- reactable::colDef(
          name = col,
          sortable = TRUE,
          header = function(value) sort_header_button(value),
          headerClass = "gov-sort-header",
          html = TRUE,
          na = "NA",
          # GOV.UK right-aligns numbers. right_col adds columns that hold
          # numbers as text, such as "£85".
          align = if (is.numeric(df[[col]]) || col %in% right_col) {
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

        # Merge the user's colDef over the defaults, so only the fields they
        # set override them. colDef() renames some arguments in its output
        # (for example headerClass to headerClassName), so both are built
        # with colDef() and then merged as lists.
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

    table <- attachDependency(table, widget = "reactable")

    if (is.null(caption)) {
      return(table)
    }

    if (is.null(caption_id)) {
      caption_id <- next_caption_id()
    } else {
      validate_caption_id(caption_id)
    }

    captioned_table(
      table,
      caption,
      caption_size,
      heading_level,
      caption_id,
      subtitle,
      paste0(caption_id, "-subtitle")
    )
  }

# Builds the caption heading, an optional subtitle, and a wrapper around
# `content` that carries the ids govreactable.js uses to set aria-labelledby.
# Used by govReactable() and govReactableOutput(). The caller supplies the id,
# because ids made from the caption text can clash ("Table 1" and "Table 2"
# both became "table_").
captioned_table <- function(
  content,
  caption,
  caption_size,
  heading_level,
  id,
  subtitle = NULL,
  subtitle_id = NULL
) {
  has_subtitle <- !is.null(subtitle)

  heading_class <- paste0("govuk-heading-", caption_size)
  if (has_subtitle) {
    # Keep the subtitle close to the heading
    heading_class <- paste(heading_class, "govuk-!-margin-bottom-1")
  }

  htmltools::tagList(
    build_heading_tag(
      heading_level,
      # Not wrapped in HTML(), so htmltools escapes plain strings. Captions
      # often come from data or user input, and raw HTML could run scripts or
      # break the table's accessible name. Tags and shiny::HTML() still work,
      # so markup is opt-in. The subtitle is treated the same way.
      caption,
      heading_class,
      id
    ),
    if (has_subtitle) {
      shiny::tags$p(
        id = subtitle_id,
        class = paste(
          subtitle_class(caption_size),
          "govuk-!-margin-bottom-4"
        ),
        subtitle
      )
    },
    htmltools::tags$div(
      class = "shinygovstyle-reactable-labelled",
      # reactable can't name its role="table" element, so govreactable.js
      # copies these ids onto it as aria-labelledby. Naming the table itself,
      # not a region around it, means screen readers read the title when they
      # reach the table, once, with no extra landmark. The subtitle labels the
      # table too, as in govTable(). aria-labelledby is better supported than
      # aria-describedby.
      `data-labelledby` = if (has_subtitle) paste(id, subtitle_id) else id,
      content
    )
  )
}

# Counter behind next_caption_id(). A counter keeps ids unique without using
# random numbers, so set.seed() is not affected.
caption_id_state <- new.env(parent = emptyenv())
caption_id_state$count <- 0L

next_caption_id <- function() {
  caption_id_state$count <- caption_id_state$count + 1L
  paste0("govreactable-caption-", caption_id_state$count)
}

# aria-labelledby takes a space-separated list, so an id with spaces would be
# read as several ids and leave the table unnamed.
validate_caption_id <- function(caption_id) {
  if (
    !is.character(caption_id) ||
      length(caption_id) != 1 ||
      is.na(caption_id) ||
      !grepl("^\\S+$", caption_id)
  ) {
    stop(
      "`caption_id` must be a single, non-empty string with no spaces.",
      call. = FALSE
    )
  }
  invisible(caption_id)
}

# caption_id names the caption heading, so it does nothing without a caption.
# Error, so the mistake shows straight away.
validate_id_has_caption <- function(caption, caption_id) {
  if (!is.null(caption_id) && is.null(caption)) {
    stop(
      "`caption_id` needs a `caption`. `caption_id` is the id of the ",
      "caption heading, so set `caption` too, or remove `caption_id`.",
      call. = FALSE
    )
  }
  invisible(caption_id)
}

# The sort arrows and click area in reactable-overrides.css depend on the
# `gov-sort-header` class. It is always added to sortable columns, alongside
# any `headerClass` the user sets, and removed from unsortable ones (#190).
sort_header_class <- function(col_def) {
  classes <- if (is.null(col_def$headerClassName)) {
    character(0)
  } else {
    unlist(strsplit(col_def$headerClassName, "\\s+"))
  }
  classes <- setdiff(classes[nzchar(classes)], "gov-sort-header")

  if (isTRUE(col_def$sortable)) {
    classes <- c("gov-sort-header", classes)
  }

  if (length(classes) == 0) {
    NULL
  } else {
    paste(classes, collapse = " ")
  }
}

# reactable's sortable header is a div with a click handler but no button
# role, so screen readers don't announce it and voice control can't target it
# (#190). A native button inside it fixes that, as in the MOJ and ONS sortable
# tables. Clicks bubble up to reactable, which does the sorting. govreactable.js
# stops the header and the button both being tab stops, and stops Enter and
# Space sorting twice.
sort_header_button <- function(content) {
  shiny::tags$button(
    type = "button",
    class = "gov-sort-button",
    shiny::tags$span(class = "gov-sort-button__label", content),
    sort_icon()
  )
}

# The sort arrows from the MOJ sortable table (moj-frontend, MIT licence), as
# one hidden SVG filled with `currentColor`. CSS uses the header's aria-sort to
# show two small arrows (unsorted) or one larger arrow (up for ascending, down
# for descending).
sort_icon <- function() {
  arrow <- function(class, d) {
    htmltools::tag(
      "path",
      list(class = class, d = d, fill = "currentColor")
    )
  }

  htmltools::tag(
    "svg",
    list(
      class = "gov-sort-icon",
      width = "22",
      height = "22",
      viewBox = "0 0 22 22",
      fill = "none",
      focusable = "false",
      `aria-hidden` = "true",
      xmlns = "http://www.w3.org/2000/svg",
      arrow(
        "gov-sort-icon__none",
        "M8.1875 9.5L10.9609 3.95703L13.7344 9.5H8.1875Z"
      ),
      arrow(
        "gov-sort-icon__none",
        "M13.7344 12.0781L10.9609 17.6211L8.1875 12.0781H13.7344Z"
      ),
      arrow(
        "gov-sort-icon__ascending",
        "M6.5625 15.5L11 6.63125L15.4375 15.5H6.5625Z"
      ),
      arrow(
        "gov-sort-icon__descending",
        "M15.4375 7L11 15.8687L6.5625 7L15.4375 7Z"
      )
    )
  )
}

# Sets the header for a column changed through `columns`. Sortable columns get
# the sort button around the user's header. Unsortable columns keep the user's
# header with no button.
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

# reactable passes a header function only as many of (value, name) as it has
# arguments, so do the same when wrapping it.
call_header_function <- function(fn, value, name) {
  arg_names <- names(formals(fn))
  n_args <- if ("..." %in% arg_names) 2L else min(length(arg_names), 2L)
  do.call(fn, list(value, name)[seq_len(n_args)])
}

# `sortLabel` sets the header's aria-label. reactable's "Sort {name}" doesn't
# match the visible text (WCAG 2.5.3, #190), so it is always "{name}". Other
# language settings are kept.
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
#' @param caption Adds a caption heading that screen readers link to the table.
#' Plain text is escaped and shown as written; use `shiny::HTML()` or tags for
#' markup. The heading's id is `output_table_name` plus `-caption`, and the
#' subtitle's is `-subtitle`. To change either from the server, use
#' [update_reactable_caption()]
#' @inheritParams table_title_params
#' @inheritSection table_title_params Table titles
#' @param caption_size Size of the caption: `"s"`, `"m"`, `"l"` (default) or
#' `"xl"`. Any other value is an error.
#' @param heading_level The caption's heading level, an integer from `1L` to
#' `5L`. Defaults to `2L`. Use `1L` when the table is the main content of the
#' page. Strings such as `"h3"` are `r lifecycle::badge("deprecated")` as of
#' shinyGovstyle 0.3.0 and will stop working in 1.0.0; use an integer (for
#' example `3L`) instead.
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
#'     caption = "Virginica flowers have the longest petals",
#'     subtitle = "Petal and sepal measurements (cm) for three iris species"
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
#'
#' # A caption that changes with a filter. The starting caption matches the
#' # dropdown's default.
#' species <- levels(iris$Species)
#'
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::select_Input(
#'     inputId = "species",
#'     label = "Species",
#'     select_text = species,
#'     select_value = species
#'   ),
#'   govReactableOutput(
#'     "table",
#'     caption = paste(species[1], "measurements")
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   output$table <- renderGovReactable({
#'     govReactable(iris[iris$Species == input$species, ])
#'   })
#'
#'   shiny::observe({
#'     update_reactable_caption(
#'       session,
#'       "table",
#'       paste(input$species, "measurements")
#'     )
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
    heading_level = 2L,
    subtitle = NULL
  ) {
    # Warn here, not in the helper, so lifecycle blames the user's code
    legacy_level <- heading_level
    heading_level <- govreactable_heading_level(heading_level)
    if (is.character(legacy_level)) {
      lifecycle::deprecate_warn(
        when = "0.3.0",
        what = "govReactableOutput(heading_level = 'must be an integer')",
        details = c(
          i = paste0(
            "Use `heading_level = ",
            heading_level,
            "L` instead of `heading_level = \"",
            legacy_level,
            "\"`."
          ),
          i = "Heading level strings will stop working in shinyGovstyle 1.0.0."
        ),
        # One id per legacy string, so each warns once with the right integer
        id = paste0("shinyGovstyle_heading_level_", legacy_level)
      )
    }

    validate_gds_text_size(caption_size, "caption_size")
    validate_single_content(caption, "caption", allow_null = FALSE)
    validate_single_content(subtitle, "subtitle")

    # Shiny output ids are already unique (and namespaced in modules), so ids
    # built from them can't clash. The dependency adds the handler for
    # update_reactable_caption() and govreactable.js, which links the caption
    # to the table once it renders, even if the server sends a table not made
    # by govReactable().
    attachDependency(
      htmltools::div(
        captioned_table(
          reactable::reactableOutput(output_table_name),
          caption,
          caption_size,
          heading_level,
          paste0(output_table_name, "-caption"),
          subtitle,
          paste0(output_table_name, "-subtitle")
        )
      ),
      widget = "reactable_output"
    )
  }

# Wraps reactable::renderReactable()
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
    table_func <- shiny::exprToFunction(expr, env, quoted = TRUE)
    reactable::renderReactable(
      bquote(check_render_value(.(table_func)())),
      quoted = TRUE
    )
  }

# renderReactable() silently shows an empty table for anything but a widget.
# The likely cause is govReactable(caption = ...), which returns a tagList, so
# give a clear error that points to govReactableOutput(). Async (promise)
# results pass through for renderReactable() to resolve, so we don't take over
# its render function and its bindCache() handling.
check_render_value <- function(value) {
  if (
    is.null(value) ||
      inherits(value, "htmlwidget") ||
      inherits(value, "promise")
  ) {
    return(value)
  }

  if (inherits(value, "shiny.tag.list")) {
    stop(
      "renderGovReactable() needs a table without a caption. Remove ",
      "`caption` and `subtitle` from govReactable() and set them on ",
      "govReactableOutput() instead.",
      call. = FALSE
    )
  }

  stop(
    "renderGovReactable() needs a table made with govReactable(), not an ",
    "object of class ",
    paste(class(value), collapse = "/"),
    ".",
    call. = FALSE
  )
}

# Checks heading_level for govReactable() and govReactableOutput(), and returns
# an integer. Level 1 is allowed for an app that is a single table, and h6 is
# too small for a table title. The "h2" to "h5" strings from 0.2.0 are still
# accepted with `allow_legacy = TRUE`; govReactableOutput() gives the
# deprecation warning.
govreactable_heading_level <- function(heading_level, allow_legacy = TRUE) {
  allowed_levels <- 1:5
  legacy_levels <- paste0("h", 2:5)

  if (
    allow_legacy &&
      is.character(heading_level) &&
      length(heading_level) == 1 &&
      heading_level %in% legacy_levels
  ) {
    return(match(heading_level, legacy_levels) + 1L)
  }

  if (
    !is.numeric(heading_level) ||
      length(heading_level) != 1 ||
      is.na(heading_level) ||
      !(heading_level %in% allowed_levels)
  ) {
    stop(
      "`heading_level` must be a single integer from 1 to 5, e.g. `3L`.",
      call. = FALSE
    )
  }

  as.integer(heading_level)
}
