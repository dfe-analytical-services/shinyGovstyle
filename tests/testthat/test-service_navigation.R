test_that("service_navigation works", {
  expect_no_error(service_navigation(links = c("Page 1", "Page 2", "Page 3")))

  expect_no_error(
    service_navigation(
      service_name = "My app",
      c(
        "Page 1" = "p1",
        "Page 2" = "p2",
        "Page 3" = "p3"
      )
    )
  )

  expect_no_error(service_navigation("My app"))
})

test_that("service_navigation HTML is as expected", {
  local_edition(3)
  expect_snapshot(service_navigation(links = c("Page 1", "Page 2", "Page 3")))
  expect_snapshot(
    service_navigation(
      service_name = "My app",
      c(
        "Page 1" = "p1",
        "Page 2" = "p2",
        "Page 3" = "p3"
      )
    )
  )
})

test_that("service_navigation works with a single link", {
  expect_no_error(service_navigation(links = "Solo page"))
  local_edition(3)
  expect_snapshot(service_navigation(links = "Solo page"))
})

test_that("service_navigation errors with empty vector", {
  expect_error(service_navigation(links = character(0)))
})

test_that("service_navigation errors with NULL links", {
  expect_error(service_navigation(links = NULL))
})
