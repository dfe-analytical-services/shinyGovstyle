test_that("accordion works", {

  accordion_check <- accordion(
          "acc1",
          c("Writing well for the web",
            "Writing well for specialists",
            "Know your audience",
            "How people read"
           ),
          c("This is the content for Writing well for the web.",
            "This is the content for Writing well for specialists.",
            "This is the content for Know your audience.",
            "This is the content for How people read."
           ))

  expect_equal(length(accordion_check$children[[2]]), 4)

})


test_that("accordion numbering works past 9", {

  accordion_numbering_check <- accordion(
    "acc1",
    c("Writing well for the web",
      "Writing well for specialists",
      "Know your audience",
      "How people read",
      "Accordian title 5",
      "Accordion title 6",
      "Accordion title 7",
      "Accordion title 8",
      "Accordion title 9",
      "Accordion title 10",
      "Accordion title 11",
      "Accordion title 12"
    ),
    c("This is the content for Writing well for the web.",
      "This is the content for Writing well for specialists.",
      "This is the content for Know your audience.",
      "This is the content for How people read.",
      "Accordian content 5",
      "Accordion content 6",
      "Accordion content 7",
      "Accordion content 8",
      "Accordion content 9",
      "Accordion content 10",
      "Accordion content 11",
      "Accordion content 12"
    ))


  heading1 <- accordion_numbering_check$children[[2]][[1]]$children[[1]]$children[[1]]$children[[1]]$attribs$name
  heading11 <- accordion_numbering_check$children[[2]][[11]]$children[[1]]$children[[1]]$children[[1]]$attribs$name

  expect_equal(stringr::str_sub(heading1, -2), "01")
  expect_equal(stringr::str_sub(heading11, -2), "11")

})
