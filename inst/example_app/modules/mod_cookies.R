mod_cookies_ui <- function(id) {
  tagList(
    heading_text("Cookie page", size = "l"),
    label_hint(
      NS(id, "label-cookies"),
      "This an example cookie page that could be
                   expanded"
    )
  )
}
