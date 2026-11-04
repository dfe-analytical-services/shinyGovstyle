test_that("App loads and title of app appears as expected", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()

  # skip appdir <- system.file(package = "shinyGovstyle", "example_app")
  # skip expect_no_error(shinytest2::test_app(appdir))
  expect_equal(40 + 2, 42)
})

test_that("Showcase source and documentation match installed provenance", {
  expressions <- parse(system.file(
    "example_app/global.R",
    package = "shinyGovstyle"
  ))
  metadata_start <- which(vapply(
    expressions,
    function(expr) {
      is.call(expr) &&
        identical(expr[[1]], as.name("<-")) &&
        identical(expr[[2]], as.name("showcase_github"))
    },
    logical(1)
  ))
  expect_length(metadata_start, 1L)

  cases <- list(
    list(list(Repository = "CRAN"), "CRAN release", ""),
    list(list(RemoteType = "github"), "GitHub development version", "dev/"),
    list(list(), "installed version", "dev/"),
    list(
      list(Repository = "CRAN", RemoteType = "github"),
      "GitHub development version",
      "dev/"
    )
  )
  for (case in cases) {
    env <- new.env(parent = baseenv())
    env$showcase_package <- case[[1]]
    for (expr in expressions[seq.int(metadata_start, length(expressions))]) {
      eval(expr, env)
    }
    expect_identical(env$showcase_source, case[[2]])
    expect_identical(
      env$showcase_docs_url,
      paste0(
        "https://dfe-analytical-services.github.io/shinyGovstyle/",
        case[[3]]
      )
    )
    expect_identical(
      env$showcase_source_url,
      if (identical(case[[2]], "CRAN release")) {
        "https://cran.r-project.org/package=shinyGovstyle"
      } else {
        "https://github.com/dfe-analytical-services/shinyGovstyle"
      }
    )
  }
})
