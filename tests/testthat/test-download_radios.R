test_that("Suffixes present", {
  expect_true(
    download_radios() |>
      paste(collapse = ",") |>
      stringr::str_detect(c("CSV", "ODS", "XLSX")) |>
      all()
  )
  expect_true(
    download_radios(file_types = c("CSV", "ODS"), file_sizes = c("1 KB", "3 KB")) |>
      paste(collapse = ",") |>
      stringr::str_detect(c("CSV", "ODS")) |>
      all()
  )
  expect_true(
    download_radios(file_types = c("CSV", "ODS"), file_sizes = c("1 KB", "3 KB")) |>
      paste(collapse = ",") |>
      stringr::str_detect(c("XLSX")) |>
      isFALSE()
  )
})
