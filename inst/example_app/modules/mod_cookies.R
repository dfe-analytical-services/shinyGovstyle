mod_cookies_ui <- function(id) {
  shiny::tagList(
    shinyGovstyle::heading_text("Cookie page", size = "l"),
    shinyGovstyle::label_hint(
      shiny::NS(id, "label-cookies"),
      "This an example cookie page that could be
                   expanded"
    )
  )
}
