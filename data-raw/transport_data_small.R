months <- c("January", "February", "March")
bikes <- c("£85", "£75", "£165")
cars <- c("£95", "£55", "£125")

transport_data_small <- data.frame(
  months,
  bikes,
  cars
)

usethis::use_data(transport_data_small, overwrite = TRUE)
