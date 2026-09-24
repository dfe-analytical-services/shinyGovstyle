# Deployed at
# https://department-for-education.shinyapps.io/shinygovstyle-example-app/

library(bslib)
library(shinyGovstyle) # needs to come after as there's name clashes / masking

lapply(list.files("modules", full.names = TRUE, pattern = "\\.R$"), source)

# Single source of truth for the showcase app's width, so gov_page(width =
# demo_width) in ui.R and mod_width_toggle_server(initial = demo_width) in
# server.R can't silently drift apart.
demo_width <- "full"
