# Check list length
test_that("list length", {
  gov_list_check <- gov_list(list = c("a", "b", "c"))

  expect_equal(3, length(gov_list(list = c("a", "b", "c"))$children[[1]]))
})

# Check list type
test_that("bulleted list type", {
  gov_list_check <- gov_list(list = c("a", "b", "c"))

  expect_equal("ul", gov_list_check[[1]])
})

# Check list class
test_that("bulleted list class", {
  gov_list_check <- gov_list(list = c("a", "b", "c"))

  expect_equal("govuk-list ", gov_list_check$attribs$class[[1]])
})

# Check bullet list type
test_that("bulleted list type", {
  gov_list_check <- gov_list(list = c("a", "b", "c"), style = "bullet")

  expect_equal("ul", gov_list_check[[1]])
})

# Check bullet list class
test_that("bulleted list class", {
  gov_list_check <- gov_list(list = c("a", "b", "c"), style = "bullet")

  expect_equal("govuk-list govuk-list--bullet",
               gov_list_check$attribs$class[[1]])
})


# Check numbered list type
test_that("numbered list type", {
  gov_list_check <- gov_list(list = c("a", "b", "c"), style = "number")

  expect_equal("ol", gov_list_check[[1]])
})

# Check numbered list class
test_that("numbered list class", {
  gov_list_check <- gov_list(list = c("a", "b", "c"), style = "number")

  expect_equal("govuk-list govuk-list--number",
               gov_list_check$attribs$class[[1]])
})
