#' Clean heading text function
#' This internal function is used in `subcontents_links()` and `heading_text()`
#' to create an automated link between the two
#' @param text string
#' @return a string
#' @keywords internal
clean_heading_text <- function(text) {
  text %>%
    stringr::str_replace_all(" ", "_") %>%
    stringr::str_to_lower() %>%
    stringr::str_remove_all("[^_[a-z]]")
}
