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
#' keeping with the wider GOV.UK design system. Some defaults can be overridden,
#' such as `highlight=TRUE` and `borderless=TRUE`, however some are fixed, such
#' as `showSortIcon=FALSE` as the default sort icon is inaccessible. Each
#' sortable column heading is a button, so screen readers announce it as
#' something you can select and voice control software can select it by its
#' visible text (see issue #190). Additional arguments from
#' `reactable::reactable` can be passed to customise the table.
#'
#' @param df A dataframe used to generate the table
#' @param right_col A vector of extra column names to right-align. Numeric
#' columns are right-aligned automatically, following GOV.UK guidance that
#' numbers should be right-aligned so they are easier to compare, and other
#' columns are left-aligned. Use this for columns that hold numbers as text,
#' such as `"£85"`. To left-align a numeric column, set
#' `reactable::colDef(align = "left")` for it in `columns`
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
#' @param caption Adds a caption to the table as a heading, linked to the
#' table via `aria-labelledby`. Plain text is shown exactly as written (it is
#' escaped, so `<` or `&` can't be read as HTML); pass `shiny::HTML()` or tags
#' for deliberate markup. `NULL` (default) renders the table with no caption.
#' In a Shiny app, set the caption on [govReactableOutput()] instead
#' @inheritParams table_title_params
#' @inheritSection table_title_params Table titles
#' @param caption_size Adjust the size of caption. One of `"s"`, `"m"`, `"l"`,
#' `"xl"`, with `"l"` as the default. Any other value throws an error.
#' @param heading_level The HTML heading level for the caption, an integer
#' from `1L` to `5L`. Defaults to `2L` (`<h2>`). Use `1L` when the table is
#' the main content of the page, so the caption is the page's main heading
#' @param caption_id The id given to the caption heading, which the table
#' references via `aria-labelledby`. Must be unique on the page and contain no
#' spaces. `NULL` (default) generates a unique id for you, so you only need
#' this if you want to link to or style the caption yourself
#' @param language Language options made with `reactable::reactableLang()`,
#' for example to translate the pagination text. Defaults to the
#' `reactable.language` option, as in `reactable::reactable()`. `sortLabel`
#' is always set to `"{name}"`, so each heading's accessible name matches its
#' visible text, and setting it gives a warning.
#' @param ... Additional arguments passed to `reactable::reactable`
#' @return A `reactable` HTML widget styled with GOV.UK classes, or (if
#' `caption` is supplied) that widget together with a linked caption heading
#' @family Govstyle tables tabs and accordions
#' @export
#' @examples
#' # Example static table using govReactable
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
#'   # Add a title linked to the table for screen reader users: a short
#'   # headline, with what the data is, where and when underneath
#'   govReactable(
#'     shinyGovstyle::transport_data,
#'     caption = "Costs peaked in March for every vehicle type",
#'     subtitle = "Cost of bikes, vans and buses (£), January to May"
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
    validate_single_content(caption, "caption")
    validate_single_content(subtitle, "subtitle")
    validate_subtitle_has_caption(caption, subtitle)

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
          # GOV.UK right-aligns numbers so they line up for comparison, so
          # numeric columns do this without being asked. right_col adds
          # columns that hold numbers as text, such as "£85".
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

# Internal helper: returns the caption heading, an optional subtitle, and a
# region wrapping `content`, labelled by the heading (and subtitle) via
# aria-labelledby. Shared by govReactable() and govReactableOutput(). The id is
# always chosen by the caller rather than derived from the caption text:
# slugifying the text gave duplicate or empty ids (digits and non-ASCII letters
# were stripped, so "Table 1" and "Table 2" both became "table_"), which
# silently pointed a table at the wrong caption, or at none. Callers derive
# the subtitle id from the same unique source, so it can't collide either.
captioned_table <- function(
  content,
  caption,
  caption_size,
  heading_level,
  id,
  subtitle = NULL,
  subtitle_id = NULL
) {
  validate_heading_level(heading_level)
  validate_gds_text_size(caption_size, "caption_size")

  has_subtitle <- !is.null(subtitle)

  heading_class <- paste0("govuk-heading-", caption_size)
  if (has_subtitle) {
    # Pull the subtitle up under the headline so the two read as one title
    heading_class <- paste(heading_class, "govuk-!-margin-bottom-1")
  }

  htmltools::tagList(
    build_heading_tag(
      heading_level,
      # Passed unwrapped on purpose so htmltools escapes plain strings. Captions
      # are often built from data or user input (e.g. paste(input$region,
      # "results"), a column value, a file name). Sent as raw HTML, a value
      # containing `<script>` or `<img onerror=...>` would run as code in the
      # user's browser (cross-site scripting), and even an innocent stray `<`
      # would break the markup and change the table's accessible name, since
      # this heading is its aria-labelledby target. Tags and shiny::HTML()
      # still pass through, so markup is an explicit opt-in. The subtitle
      # below is passed unwrapped for the same reason.
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
      role = "region",
      # Both parts label the table, matching govTable(), where the subtitle
      # sits inside the native <caption>. aria-labelledby is far better
      # supported than aria-describedby (W3C WAI tables tutorial).
      `aria-labelledby` = if (has_subtitle) paste(id, subtitle_id) else id,
      content
    )
  )
}

# Internal state: a per-process counter behind next_caption_id(). A counter,
# rather than a random suffix, keeps generated ids unique without touching the
# user's random number stream, so set.seed() reproducibility is unaffected.
caption_id_state <- new.env(parent = emptyenv())
caption_id_state$count <- 0L

next_caption_id <- function() {
  caption_id_state$count <- caption_id_state$count + 1L
  paste0("govreactable-caption-", caption_id_state$count)
}

# Internal helper: aria-labelledby takes a space-separated list of ids, so an
# id containing whitespace would be read as several (missing) ids and leave the
# table unnamed. Reject it up front rather than ship a silently broken link.
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
#' @param caption Adds a caption to the table as a heading, linked to the
#' table via `aria-labelledby`. Plain text is shown exactly as written (it is
#' escaped); pass `shiny::HTML()` or tags for deliberate markup. The heading's
#' id is `output_table_name` followed by `-caption` (and the subtitle's id,
#' `-subtitle`). To change either from the server, use
#' [update_reactable_caption()]
#' @inheritParams table_title_params
#' @inheritSection table_title_params Table titles
#' @param caption_size Adjust the size of caption. One of `"s"`, `"m"`, `"l"`,
#' `"xl"`, with `"l"` as the default. Any other value throws an error.
#' @param heading_level The HTML heading level for the caption, an integer
#' from `1L` to `5L`. Defaults to `2L` (`<h2>`). Use `1L` when the table is
#' the main content of the page, such as an app that shows a single table, so
#' the caption is the page's main heading. Strings such as `"h3"` are
#' `r lifecycle::badge("deprecated")` as of shinyGovstyle 0.3.0 and will stop
#' working in shinyGovstyle 1.0.0; use the integer form (e.g. `3L`) instead.
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
#' # A caption that follows a filter, updated from the server. The starting
#' # caption matches the dropdown's default so it's right before the server
#' # runs.
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
    # Warned here rather than in the helper so lifecycle attributes the
    # deprecated usage to the user's code rather than to this package.
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
        # One id per legacy string, so each gets its own once-per-session
        # warning showing the right integer.
        id = paste0("shinyGovstyle_heading_level_", legacy_level)
      )
    }

    validate_single_content(caption, "caption", allow_null = FALSE)
    validate_single_content(subtitle, "subtitle")

    # Shiny already requires output ids to be unique on the page (and module
    # namespacing is applied to them), so deriving the caption and subtitle ids
    # from the output id guarantees the aria-labelledby link can't collide.
    # The "reactable_output" dependency ships the handler
    # update_reactable_caption() sends to, so either can be changed from the
    # server.
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

# Internal helper: validates a table caption's heading_level for
# govReactable() and govReactableOutput(), and returns it as an integer.
# Level 1 is allowed for an app whose page is a single table, where the
# caption is the page's main heading; h6 is too small to be a table title.
# govReactableOutput() shipped in 0.2.0 with "h2"-"h5" strings, which are
# still accepted with `allow_legacy = TRUE` during the 0.3.0 transition;
# govReactableOutput() gives the deprecation warning.
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
