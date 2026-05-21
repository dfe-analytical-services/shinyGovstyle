# Create a test link ==========================================================
test_button <- download_button(
  "download_data",
  "Download specific data set",
  file_size = "12 KB"
)

# Run rest of tests against the test link -------------------------------------
test_that("Returns shiny.tag object", {
  expect_s3_class(test_button, "shiny.tag")
})

test_that("content and URL are correctly formatted", {
  expect_identical(test_button$attribs$href, "")
  expect_identical(
    as.character(tag_text(test_button, "govuk-button")),
    "Download specific data set (CSV, 12 KB)"
  )
})

test_that("attributes are attached properly", {
  expect_identical(test_button$attribs$target, "_blank")
  expect_identical(test_button$attribs$id, "download_data")
  expect_identical(
    test_button$attribs$class,
    "shiny-download-link govuk-button"
  )
})

# Rest of tests against the function ==========================================
test_that("Rejects dodgy link text", {
  expect_error(download_button("download_data", "Download data"))
  expect_error(download_button("download_data", "Click here"))
  expect_error(download_button("download_data", "here"))
  expect_error(download_button("download_data", "PDF"))
  expect_error(download_button("download_data", "Full stop."))
  expect_error(download_button("download_data", "http://shiny.posit.co/"))
  expect_error(download_button("download_data", "www.google.com"))
})

test_that("Surrounding whitespace shrubbery is trimmed", {
  trimmed_label <- function(label) {
    as.character(
      tag_text(
        download_button("download_data", label, file_size = "96 MB"),
        "govuk-button"
      )
    )
  }

  expect_identical(
    trimmed_label("   Download specific data set"),
    "Download specific data set (CSV, 96 MB)"
  )
  expect_identical(
    trimmed_label("Download specific data set    "),
    "Download specific data set (CSV, 96 MB)"
  )
  expect_identical(
    trimmed_label("   Download specific data set   "),
    "Download specific data set (CSV, 96 MB)"
  )
})

test_that("Warning appears for short link text and not for long text", {
  expect_warning(
    download_button("download_data", "R", file_size = "96 MB"),
    paste0(
      "the button_label: R, is shorter than 7 characters, this is",
      " unlikely to be descriptive for users, consider having more detailed",
      " link text"
    )
  )

  expect_no_warning(
    download_button(
      "download_data",
      "Download specific data set",
      file_size = "96 MB"
    )
  )
})

test_that("file_size is valid", {
  expect_warning(
    download_button("download_data", "Download your data"),
    paste0(
      "download_data",
      ": download_button file_size is NULL. ",
      "Please add a file_size estimate or upper limit wherever possible."
    )
  )

  expect_no_warning(
    download_button("download_data", "Download your data", file_size = "12 KB")
  )

  expect_error(
    download_button("download_data", "Download your data", file_size = "12 JV")
  )
})
