# Create a test link ==========================================================
test_button <- download_button("download_data", "Download specific data set", file_size = "12 KB")

# Run rest of tests against the test link -------------------------------------
test_that("Returns shiny.tag object", {
  expect_s3_class(test_button, "shiny.tag")
})

test_that("content and URL are correctly formatted", {
  expect_equal(test_button$attribs$href, "")
  expect_true(grepl("Download specific data set", test_button$children[[1]]))
})

test_that("File type and size correctly append", {
  expect_true(grepl("\\(CSV", test_button$children[[1]]))
  expect_true(grepl("12 KB\\)", test_button$children[[1]]))
})

test_that("attributes are attached properly", {
  expect_equal(test_button$attribs$target, "_blank")
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
  expect_equal(
    paste0(
      download_button(
        "download_data",
        "   Download specific data set",
        file_size = "96 MB"
      )$children[[1]]
    ),
    "Download specific data set (CSV, 96 MB)"
  )

  expect_equal(
    paste0(download_button(
      "download_data",
      "Download specific data set    ",
      file_size = "96 MB"
    )$children[[1]]),
    "Download specific data set (CSV, 96 MB)"
  )

  expect_equal(
    paste0(download_button(
      "download_data",
      "   Download specific data set   ",
      file_size = "96 MB"
    )$children[[1]]),
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
    download_button("download_data", "Download specific data set", file_size = "96 MB")
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
