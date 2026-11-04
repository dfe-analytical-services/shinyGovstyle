#' Update a govReactable caption or subtitle from the server
#'
#' @description
#' Changes the caption, the subtitle, or both, of a [govReactableOutput()]
#' table while the app is running, for example so the title still describes
#' the data after a filter changes it.
#'
#' The caption and subtitle are the table's accessible name, so keeping them
#' accurate matters for screen reader users as well as sighted users.
#'
#' The new text isn't announced when it changes, because it follows something
#' the user just did, such as picking a filter. Screen readers read the new
#' title when the user reaches the table.
#'
#' Works inside Shiny modules without extra namespacing: pass the same
#' `output_table_name` you used in `renderGovReactable()`.
#'
#' @param session The Shiny session object
#' @param output_table_name The id of the table, as given to
#'   `govReactableOutput()` and `output$<id>` (without the module namespace)
#' @param caption The new caption, or `NULL` (default) to leave it as it is.
#'   Plain text is escaped and shown as written; use `shiny::HTML()` or tags
#'   for markup
#' @param subtitle The new subtitle, or `NULL` (default) to leave it as it is.
#'   Escaped in the same way as `caption`. Only works if `govReactableOutput()`
#'   was given a `subtitle` to start with
#'
#' @returns `NULL` (invisibly), called for side effects
#' @family Govstyle tables tabs and accordions
#' @export
#'
#' @examples
#' colours <- sort(unique(shinyGovstyle::transport_data$colours))
#'
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::select_Input(
#'     inputId = "colour",
#'     label = "Colour",
#'     select_text = colours,
#'     select_value = colours
#'   ),
#'   shinyGovstyle::govReactableOutput(
#'     "table",
#'     # Start with the title for the dropdown's default choice
#'     caption = paste(colours[1], "vehicle costs peaked in March"),
#'     subtitle = paste(colours[1], "vehicle costs (£), January to May")
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   output$table <- shinyGovstyle::renderGovReactable({
#'     shinyGovstyle::govReactable(
#'       subset(shinyGovstyle::transport_data, colours == input$colour)
#'     )
#'   })
#'
#'   shiny::observe({
#'     shinyGovstyle::update_reactable_caption(
#'       session,
#'       "table",
#'       caption = paste(input$colour, "vehicle costs peaked in March"),
#'       subtitle = paste(input$colour, "vehicle costs (£), January to May")
#'     )
#'   })
#' }
#'
#' if (interactive()) shiny::shinyApp(ui = ui, server = server)
update_reactable_caption <- function(
  session,
  output_table_name,
  caption = NULL,
  subtitle = NULL
) {
  if (
    !is.character(output_table_name) ||
      length(output_table_name) != 1 ||
      is.na(output_table_name) ||
      !nzchar(output_table_name)
  ) {
    stop(
      "`output_table_name` must be a single, non-empty string.",
      call. = FALSE
    )
  }
  if (is.null(caption) && is.null(subtitle)) {
    stop("Supply a `caption`, a `subtitle`, or both to update.", call. = FALSE)
  }
  validate_single_content(caption, "caption")
  validate_single_content(subtitle, "subtitle")

  # Use the ids govReactableOutput() gives the caption and subtitle.
  # session$ns() adds the module prefix (and does nothing at the top level).
  # Only the parts supplied are sent.
  update_for <- function(content, suffix) {
    if (is.null(content)) {
      return(NULL)
    }
    list(
      id = session$ns(paste0(output_table_name, suffix)),
      html = govuk_markup_html(content)
    )
  }
  updates <- Filter(
    Negate(is.null),
    list(update_for(caption, "-caption"), update_for(subtitle, "-subtitle"))
  )

  session$sendCustomMessage(
    "update_reactable_caption",
    list(updates = updates)
  )
  invisible(NULL)
}
