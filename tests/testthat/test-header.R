test_that("multiplication works", {
  header_check <- header("Test", "Again")

  expect_identical(
    header_check$children[[2]]$attribs$class,
    "govuk-header__container govuk-width-container"
  )
})

# testing for alt text

test_that("all alt text works", {
  alt_check <- header(
    main_text = "test text",
    secondary_text = "test text 2",
    logo = "shinyGovstyle/images/moj_logo.png",
    main_link = "test_link.com",
    secondary_link = "test_link2.com",
    logo_alt_text = "this is a test for alt text for the logo",
    main_alt_text = "alt text for main link",
    secondary_alt_text = "alt text for secondary link"
  )


  expect_identical(
    alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][["attribs"]][["href"]],
    "test_link.com"
  )

  expect_identical(
    alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][["attribs"]][["aria-label"]],
    "alt text for main link"
  )

  expect_identical(
    alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][["children"]][[1]][["children"]][[1]][["attribs"]][["alt_text"]],
    "this is a test for alt text for the logo"
  )

  expect_identical(
    alt_check[["children"]][[2]][["children"]][[2]][["children"]][[1]][["attribs"]][["href"]],
    "test_link2.com"
  )

  expect_identical(
    alt_check[["children"]][[2]][["children"]][[2]][["children"]][[1]][["attribs"]][["aria-label"]],
    "alt text for secondary link"
  )
})


test_that("only logo alt works", {
  logo_alt_check <- header(
    main_text = "test text",
    secondary_text = "test text 2",
    logo = "shinyGovstyle/images/moj_logo.png",
    logo_alt_text = "this is a test for alt text for the logo"
  )


  expect_identical(
    logo_alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][["children"]][[1]][["children"]][[1]][["attribs"]][["alt_text"]],
    "this is a test for alt text for the logo"
  )
})


test_that("only main link alt works", {
  main_alt_check <- header(
    main_text = "test text",
    secondary_text = "test text 2",
    main_link = "test_link.com",
    main_alt_text = "alt text for main link"
  )


  expect_identical(
    main_alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][["attribs"]][["href"]],
    "test_link.com"
  )

  expect_identical(
    main_alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][["attribs"]][["aria-label"]],
    "alt text for main link"
  )
})

test_that("only secondary link alt works", {
  secondary_alt_check <- header(
    main_text = "test text",
    secondary_text = "test text 2",
    secondary_link = "test_link2.com",
    secondary_alt_text = "alt text for secondary link"
  )


  expect_identical(
    secondary_alt_check[["children"]][[2]][["children"]][[2]][["children"]][[1]][["attribs"]][["href"]],
    "test_link2.com"
  )

  expect_identical(
    secondary_alt_check[["children"]][[2]][["children"]][[2]][["children"]][[1]][["attribs"]][["aria-label"]],
    "alt text for secondary link"
  )
})

# testing for errors
test_that("errors are as expected", {
  expect_error(
    header(
      main_text = "test text",
      secondary_text = "test text 2",
      logo = "shinyGovstyle/images/moj_logo.png"
    ),
    "Please use logo_alt_text to provide alternative text for the logo you used."
  )

  expect_error(
    header(
      main_text = "test text",
      secondary_text = "test text 2",
      main_link = "test_link.com"
    ),
    "Please use main_alt_text to provide alternative text for the main link you used."
  )

  expect_error(
    header(
      main_text = "test text",
      secondary_text = "test text 2",
      logo = "shinyGovstyle/images/moj_logo.png",
      secondary_link = "test_link2.com",
      logo_alt_text = "this is a test for alt text for the logo"
    ),
    "Please use secondary_alt_text to provide alternative text for the secondary link you used."
  )
})
