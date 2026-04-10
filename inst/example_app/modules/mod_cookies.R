mod_cookies_ui <- function(id) {
  shiny::tagList(
    heading_text("Cookie page", size = "l"),
    label_hint(
      shiny::NS(id, "label-cookies"),
      "This an example cookie page that could be
                   expanded"
    )
  )
}
