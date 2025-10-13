tabs <- c(
  rep("Past Day", 3),
  rep("Past Week", 3),
  rep("Past Month", 3),
  rep("Past Year", 3)
)
case_manager <- rep(c("David Francis", "Paul Farmer", "Rita Patel"), 4)
cases_open <- c(3, 1, 2, 24, 16, 24, 98, 122, 126, 1380, 1129, 1539)
cases_closed <- c(0, 0, 0, 18, 20, 27, 95, 131, 142, 1472, 1083, 1265)

case_data <- data.frame(
  tabs,
  case_manager,
  cases_open,
  cases_closed
)

usethis::use_data(case_data, overwrite = TRUE)
