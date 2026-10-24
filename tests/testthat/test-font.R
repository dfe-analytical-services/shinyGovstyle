test_that("font stylesheet loads", {
  font_check <- font()
  font_dep <- Filter(function(x) identical(x$name, "font"), font_check)
  expect_length(font_dep, 1)
  expect_identical(font_dep[[1]]$stylesheet, "font.css")
})

test_that("font() also attaches the base shinyGovstyle dependencies", {
  # So update_page_title() works in apps that use font() without any other
  # shinyGovstyle component.
  dep_names <- vapply(font(), function(x) x$name, character(1))
  expect_true("stylecss" %in% dep_names)
  expect_true("update_page_title" %in% dep_names)
})
