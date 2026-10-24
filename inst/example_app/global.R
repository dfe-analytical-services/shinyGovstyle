# Deployed at
# CRAN release:
# https://department-for-education.shinyapps.io/shinygovstyle-example-app/
# Development version (main):
# https://department-for-education.shinyapps.io/shinygovstyle-example-app-dev/

library(bslib)
library(shinyGovstyle) # needs to come after as there's name clashes / masking

lapply(list.files("modules", full.names = TRUE, pattern = "\\.R$"), source)

# Single source of truth for the showcase app's width, so gov_page(width =
# demo_width) and mod_width_toggle_ui(initial = demo_width) in ui.R
# cannot silently drift apart.
demo_width <- "full"

# The CRAN release app is the canonical URL for both deployments, so search
# engines and link previews treat the dev app as a copy of it
app_url <- paste0(
  "https://department-for-education.shinyapps.io/",
  "shinygovstyle-example-app/"
)

# Link preview image, served from the app's www/ folder. It points at the dev
# app because that is always deployed from main, so the image exists there
# even before the CRAN release app has caught up with a new version
og_image_url <- paste0(
  "https://department-for-education.shinyapps.io/",
  "shinygovstyle-example-app-dev/shinygovstyle-opengraph.png"
)
