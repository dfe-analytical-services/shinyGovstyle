months <- rep(c("January", "February", "March", "April", "May"), times = 2)
colours <- rep(c("Red", "Blue"), times = 5)
bikes <- c(85, 75, 165, 90, 80, 95, 85, 175, 100, 95)
vans <- c(150, 130, 180, 160, 140, 175, 135, 185, 155, 145)
buses <- c(200, 180, 220, 210, 190, 215, 185, 225, 205, 195)

transport_data <- data.frame(
  months,
  colours,
  bikes,
  vans,
  buses
)

usethis::use_data(transport_data, overwrite = TRUE)
