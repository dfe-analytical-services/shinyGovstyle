# Create a test link ==========================================================
test_link <- download_link(
  "download_data",
  "Download specific data set",
  file_size = "12 KB"
)

# Run rest of tests against the test link -------------------------------------
test_that("Returns shiny.tag object", {
  expect_s3_class(test_link, "shiny.tag")
})

test_that("content and URL are correctly formatted", {
  expect_identical(htmltools::tagGetAttribute(test_link, "href"), "")
  expect_identical(
    as.character(tag_text(test_link, "shiny-download-link")),
    "Download specific data set (CSV, 12 KB)"
  )
})

test_that("attributes are attached properly", {
  expect_identical(htmltools::tagGetAttribute(test_link, "target"), "_blank")
  expect_identical(
    htmltools::tagGetAttribute(test_link, "id"),
    "download_data"
  )
  expect_identical(
    htmltools::tagGetAttribute(test_link, "class"),
    "shiny-download-link govuk-link disabled"
  )
})

# Rest of tests against the function ==========================================
test_that("Rejects dodgy link text", {
  expect_error(download_link("download_data", "Download data"))
  expect_error(download_link("download_data", "Click here"))
  expect_error(download_link("download_data", "here"))
  expect_error(download_link("download_data", "PDF"))
  expect_error(download_link("download_data", "Full stop."))
  expect_error(download_link("download_data", "http://shiny.posit.co/"))
  expect_error(download_link("download_data", "www.google.com"))
})

test_that("Surrounding whitespace shrubbery is trimmed", {
  trimmed_label <- function(text) {
    as.character(
      tag_text(
        download_link("download_data", text, file_size = "96 MB"),
        "shiny-download-link"
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
    download_link("download_data", "R", file_size = "96 MB"),
    paste0(
      "the link_text: R, is shorter than 7 characters, this is",
      " unlikely to be descriptive for users, consider having more detailed",
      " link text"
    )
  )

  expect_no_warning(
    download_link(
      "download_data",
      "Download specific data set",
      file_size = "96 MB"
    )
  )
})

test_that("file_size is valid", {
  expect_warning(
    download_link("download_data", "Download your data"),
    paste0(
      "download_data",
      ": download_link file_size is NULL. ",
      "Please add a file_size estimate or upper limit wherever possible."
    )
  )

  expect_no_warning(
    download_link("download_data", "Download your data", file_size = "12 KB")
  )

  expect_error(
    download_link("download_data", "Download your data", file_size = "12 JV")
  )
})
