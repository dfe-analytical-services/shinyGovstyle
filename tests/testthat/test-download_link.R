# Create a test link ==========================================================
test_link <- download_link("download_data", "Download specific data set", file_size = "12 KB")

# Run rest of tests against the test link -------------------------------------
test_that("Returns shiny.tag object", {
  expect_s3_class(test_link, "shiny.tag")
})

test_that("content and URL are correctly formatted", {
  expect_equal(test_link$attribs$href, "")
  expect_true(grepl("Download specific data set", test_link$children[[1]]))
})

test_that("File type and size correctly append", {
  expect_true(grepl("\\(CSV", test_link$children[[1]]))
  expect_true(grepl("12 KB\\)", test_link$children[[1]]))
})

test_that("attributes are attached properly", {
  expect_equal(test_link$attribs$target, "_blank")
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
  expect_equal(
    paste0(download_link("download_data", "   Download specific data set")$children[[1]]),
    "Download specific data set (CSV)"
  )

  expect_equal(
    paste0(download_link("download_data", "Download specific data set    ")$children[[1]]),
    "Download specific data set (CSV)"
  )

  expect_equal(
    paste0(download_link("download_data", "   Download specific data set   ")$children[[1]]),
    "Download specific data set (CSV)"
  )
})

test_that("Warning appears for short link text and not for long text", {
  expect_warning(
    download_link("download_data", "R"),
    paste0(
      "the link_text: R, is shorter than 7 characters, this is",
      " unlikely to be descriptive for users, consider having more detailed",
      " link text"
    )
  )

  expect_no_warning(download_link("download_data", "Download specific data set"))
})
