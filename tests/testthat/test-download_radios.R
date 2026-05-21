radio_labels <- function(x) {
  labels <- find_tags(x, "govuk-radios__label")
  vapply(
    labels,
    function(label) as.character(label$children[[1L]]),
    character(1L)
  )
}

test_that("default file_types render one radio per allowed extension", {
  radios <- download_radios()

  # The default file_sizes use "< 1 GB"; htmltools escapes the < as &lt; when
  # building the label text node, so the assertion matches the escaped form.
  expect_identical(
    radio_labels(radios),
    c("CSV (&lt; 1 GB)", "ODS (&lt; 1 GB)", "XLSX (&lt; 1 GB)")
  )
})

test_that("file_types subset only renders the requested extensions", {
  radios <- download_radios(
    file_types = c("CSV", "ODS"),
    file_sizes = c("1 KB", "3 KB")
  )

  labels <- radio_labels(radios)
  expect_identical(labels, c("CSV (1 KB)", "ODS (3 KB)"))
  expect_false("XLSX" %in% sub(" \\(.*$", "", labels))
})

test_that("download_radios_handler validates file_name and file_contents", {
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

test_that("invalid file_types raise an error", {
  expect_error(
    download_radios(
      file_types = c("CSV", "WAT"),
      file_sizes = c("1 KB", "1 KB")
    )
  )
})
