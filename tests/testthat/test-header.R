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
    alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][[
      "attribs"
    ]][["href"]],
    "test_link.com"
  )

  expect_identical(
    alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][[
      "attribs"
    ]][["aria-label"]],
    "alt text for main link"
  )

  expect_identical(
    alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][[
      "children"
    ]][[1]][["children"]][[1]][["attribs"]][["alt_text"]],
    "this is a test for alt text for the logo"
  )

  expect_identical(
    alt_check[["children"]][[2]][["children"]][[2]][["children"]][[1]][[
      "attribs"
    ]][["href"]],
    "test_link2.com"
  )

  expect_identical(
    alt_check[["children"]][[2]][["children"]][[2]][["children"]][[1]][[
      "attribs"
    ]][["aria-label"]],
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
    logo_alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][[
      "children"
    ]][[1]][["children"]][[1]][["attribs"]][["alt_text"]],
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
    main_alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][[
      "attribs"
    ]][["href"]],
    "test_link.com"
  )

  expect_identical(
    main_alt_check[["children"]][[2]][["children"]][[1]][["children"]][[1]][[
      "attribs"
    ]][["aria-label"]],
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
    secondary_alt_check[["children"]][[2]][["children"]][[2]][["children"]][[
      1
    ]][["attribs"]][["href"]],
    "test_link2.com"
  )

  expect_identical(
    secondary_alt_check[["children"]][[2]][["children"]][[2]][["children"]][[
      1
    ]][["attribs"]][["aria-label"]],
    "alt text for secondary link"
  )
})

# testing for errors
test_that("errors are as expected", {
  expect_warning(
    header(
      main_text = "test text",
      secondary_text = "test text 2",
      logo = "shinyGovstyle/images/moj_logo.png"
    ),
    paste(
      "Please use logo_alt_text to provide alternative text",
      "for the logo you used."
    )
  )

  expect_warning(
    header(
      main_text = "test text",
      secondary_text = "test text 2",
      main_link = "test_link.com"
    ),
    paste(
      "Please use main_alt_text to provide alternative text",
      "for the main link you used."
    )
  )

  expect_warning(
    header(
      main_text = "test text",
      secondary_text = "test text 2",
      logo = "shinyGovstyle/images/moj_logo.png",
      secondary_link = "test_link2.com",
      logo_alt_text = "this is a test for alt text for the logo"
    ),
    paste(
      "Please use secondary_alt_text to provide alternative text",
      "for the secondary link you used."
    )
  )
})

test_that("heading_text returns correct heading level", {
  # Test default level (should be h1)
  h1 <- heading_text("Test", size = "xl")
  expect_true(grepl("<h1", as.character(h1)))

  # Test level 2
  h2 <- heading_text("Test", size = "l", level = 2)
  expect_true(grepl("<h2", as.character(h2)))

  # Test level 3
  h3 <- heading_text("Test", size = "m", level = 3)
  expect_true(grepl("<h3", as.character(h3)))

  # Test invalid level throws error
  expect_error(
    heading_text("Test", level = 0),
    "level must be an integer between 1 and 6"
  )
  expect_error(
    heading_text("Test", level = 7),
    "level must be an integer between 1 and 6"
  )
})
