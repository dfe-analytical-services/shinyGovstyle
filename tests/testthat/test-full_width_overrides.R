test_that("full_width_overrides returns a shiny.tag object", {
  expect_s3_class(full_width_overrides(), "shiny.tag")
})

test_that("full_width_overrides attaches base shinyGovstyle dependencies", {
  # So update_page_title() works in apps that use full_width_overrides()
  # without any other shinyGovstyle component.
  dep_names <- vapply(
    htmltools::findDependencies(full_width_overrides()),
    function(x) x$name,
    character(1)
  )
  expect_true("stylecss" %in% dep_names)
  expect_true("update_page_title" %in% dep_names)
})
