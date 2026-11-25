# Connect showcase addresses are listed in inst/example_app/README.md.

library(bslib)
library(shinyGovstyle) # needs to come after as there's name clashes / masking

lapply(list.files("modules", full.names = TRUE, pattern = "\\.R$"), source)

# Single source of truth for the showcase app's width, so gov_page(width =
# demo_width) and mod_width_toggle_ui(initial = demo_width) in ui.R
# cannot silently drift apart.
demo_width <- "full"

showcase_package <- utils::packageDescription("shinyGovstyle")
showcase_github <- identical(showcase_package$RemoteType, "github")
showcase_cran <- identical(showcase_package$Repository, "CRAN")
showcase_source <- if (showcase_github) {
  "GitHub development version"
} else if (showcase_cran) {
  "CRAN release"
} else {
  "installed version"
}
showcase_source_url <- if (showcase_cran && !showcase_github) {
  "https://cran.r-project.org/package=shinyGovstyle"
} else {
  "https://github.com/dfe-analytical-services/shinyGovstyle"
}
showcase_docs_url <- paste0(
  "https://dfe-analytical-services.github.io/shinyGovstyle/",
  if (!showcase_cran || showcase_github) "dev/" else ""
)
