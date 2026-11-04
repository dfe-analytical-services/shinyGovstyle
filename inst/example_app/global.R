# Deployed at
# https://department-for-education.shinyapps.io/shinygovstyle-example-app/

library(bslib)
library(shinyGovstyle) # needs to come after as there's name clashes / masking

lapply(list.files("modules", full.names = TRUE, pattern = "\\.R$"), source)

# Canonical URL of the deployed showcase, also used for link previews.
app_url <- paste0(
  "https://department-for-education.shinyapps.io/",
  "shinygovstyle-example-app/"
)

og_image_url <- paste0(app_url, "shinygovstyle-opengraph.png")

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
