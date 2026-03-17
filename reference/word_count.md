# Word Count Function

This function create tracks the word count and should be used with the
text area function.

## Usage

``` r
word_count(inputId, input, word_limit = NULL)
```

## Arguments

- inputId:

  The input slot of the text area that you want to affect

- input:

  The text input that is associated with the box

- word_limit:

  Change the word limit if needed. Default will keep as what was used in
  text area component

## Value

no value returned. Updates the word count in a shiny app

## See also

Other Govstyle text types:
[`date_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/date_Input.md),
[`gov_list()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_list.md),
[`heading_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/heading_text.md),
[`input_field()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/input_field.md),
[`text_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/text_Input.md),
[`text_area_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/text_area_Input.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyjs::useShinyjs(),
  shinyGovstyle::header(
    "Justice", "", logo = "shinyGovstyle/images/moj_logo.png"
  ),
  gov_layout(
    size = "full",
    text_area_Input(
      inputId = "text_area",
      label = "Can you provide more detail?",
      hint_label = paste(
        "Do not include personal or financial information,",
        "like your National Insurance number or credit card details."
      ),
      word_limit = 300
    )
  ),
  footer(TRUE)
)

server <- function(input, output, session) {
  shiny::observeEvent(input$text_area,
    word_count(
      inputId = "text_area",
      input = input$text_area
    )
  )
}
if (interactive()) shinyApp(ui = ui, server = server)
```
