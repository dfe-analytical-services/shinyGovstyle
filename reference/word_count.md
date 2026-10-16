# Word Count Function

**\[deprecated\]**

`word_count()` was deprecated in shinyGovstyle 0.3.0 and will be removed
in shinyGovstyle 1.0.0.
[`text_area_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/text_area_Input.md)
now counts words in the browser and announces the count to screen
readers, so no server code is needed. Set the limit with
`text_area_Input(word_limit = )` and delete the `observeEvent()` that
called `word_count()`.

## Usage

``` r
word_count(inputId, input, word_limit = NULL)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- input:

  The text input that is associated with the box

- word_limit:

  Change the word limit if needed. Default will keep as what was used in
  text area component

## Value

no value returned. Updates the word count in a shiny app

## Examples

``` r
# The word count is handled by text_area_Input() alone; no server-side
# word_count() observer is needed.
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    "Justice", "", logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_main_layout(
    shinyGovstyle::text_area_Input(
      inputId = "text_area",
      label = "Can you provide more detail?",
      hint_label = paste(
        "Do not include personal or financial information,",
        "like your National Insurance number or credit card details."
      ),
      word_limit = 300
    )
  ),
  shinyGovstyle::footer(TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
