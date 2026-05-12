# Deployed at
# https://department-for-education.shinyapps.io/shinygovstyle-example-app/

library(bslib)
library(shinyGovstyle) # needs to come after as there's name clashes / masking

lapply(list.files("modules", full.names = TRUE, pattern = "\\.R$"), source)
