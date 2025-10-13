months <- c("January", "February", "March")
bikes <- c("£85", "£75", "£165")
cars <- c("£95", "£55", "£125")

transport_small <- data.frame("Months" = months, "Bikes" = bikes, "Cars" = cars)

usethis::use_data(transport_small, overwrite = TRUE)
