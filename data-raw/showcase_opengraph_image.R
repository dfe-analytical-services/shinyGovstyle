# Builds the link preview (Open Graph) image for the showcase app. It reuses
# the crown-free favicon design (the teal GOV.UK logo dot on GOV.UK blue),
# because the showcase isn't on GOV.UK and so can't use the crown.
ragg::agg_png(
  "inst/example_app/www/shinygovstyle-opengraph.png",
  width = 1200,
  height = 630,
  res = 72,
  background = "#1d70b8"
)
grid::grid.newpage()
grid::grid.circle(
  x = grid::unit(160, "points"),
  y = grid::unit(315, "points"),
  r = grid::unit(70, "points"),
  gp = grid::gpar(fill = "#00ffe0", col = NA)
)
grid::grid.text(
  "shinyGovstyle",
  x = grid::unit(290, "points"),
  y = grid::unit(345, "points"),
  just = "left",
  gp = grid::gpar(col = "white", fontsize = 96, fontface = "bold")
)
grid::grid.text(
  "GOV.UK Design System for R Shiny",
  x = grid::unit(290, "points"),
  y = grid::unit(255, "points"),
  just = "left",
  gp = grid::gpar(col = "white", fontsize = 48)
)
grDevices::dev.off()
