test_that("Suffixes present", {
  expect_true(
    download_radios() |>
      paste(collapse = ",") |>
      stringr::str_detect(c("CSV", "ODS", "XLSX")) |>
      all()
  )
  expect_true(
    download_radios(
      file_types = c("CSV", "ODS"),
      file_sizes = c("1 KB", "3 KB")
    ) |>
      paste(collapse = ",") |>
      stringr::str_detect(c("CSV", "ODS")) |>
      all()
  )
  expect_true(
    download_radios(
      file_types = c("CSV", "ODS"),
      file_sizes = c("1 KB", "3 KB")
    ) |>
      paste(collapse = ",") |>
      stringr::str_detect(c("XLSX")) |>
      isFALSE()
  )
  expect_error(
    download_radios_handler(
      file_name = c("sdf", "sdfsdgf"),
      file_contents = data.frame(z = c(1))
    )
  )
  expect_error(
    download_radios_handler(file_name = "sdfsdf", file_contents = 1)
  )
})
