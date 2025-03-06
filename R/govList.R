#' @rdname layouts
#' @param list vector of list
#' @param style options: "none", "bullet", "number". defaults to "none".
#' @export
gov_list <- function(list, style = "none") {

  # check style argument
  if (!style %in% c("none", "bullet", "number")) {
    stop(
      cat(
        'style argument must be one of the following values:
        "none"
        "bullet"
        "number"
        '
      )
    )
  }

  # create list wrapper
  list_wrapper <- function(x) {
    # get list style class
    if (style == "bullet") {
      list_style_class <-  "govuk-list--bullet"
    } else if (style == "number") {
      list_style_class <-  "govuk-list--number"
    } else {
      list_style_class <- ""
    }

    # get shiny tag to use (ordered list or unordered list)
    if (style == "number") {
      shiny_tag <- shiny::tags$ol
    } else {
      shiny_tag <- shiny::tags$ul
    }

    # put together wrapper
    shiny_tag(class = stringr::str_c("govuk-list", list_style_class, sep = " "), x)

  }


  # apply wrapper over list to get full list
  # govList <-
  list_wrapper(purrr::map(list, function(x) {
    shiny::tags$li(x)
  }))



}


