bad_link_text <- data.frame(
  bad_link_text = c(
    # one word examples
    "click", "csv", "continue", "dashboard", "document", "download", "file",
    "form", "guidance", "here", "info", "information", "jpeg", "jpg", "learn",
    "link", "more", "next", "page", "pdf", "previous", "read", "site", "svg",
    "this", "web", "webpage", "website", "word", "xlsx",
    # two word examples
    "click here", "click this link", "download csv", "download document",
    "download file", "download here", "download jpg", "download jpeg",
    "download pdf", "download png", "download svg", "download word",
    "download xlsx", "further information", "go here", "learn more",
    "link to", "read more", "this page", "visit this", "web page", "web site",
    "this link"
  )
)

usethis::use_data(bad_link_text, overwrite = TRUE)
