# Error Summary Update Function

This function changes the text that displays in the error summary box.
Requires
[`shinyjs::useShinyjs()`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html)
to work.

## Usage

``` r
error_summary_update(inputId, error_list)
```

## Arguments

- inputId:

  The input Id of the error summary you want to update

- error_list:

  An updated list of text values to be displayed in the error body

## Value

an update error summary box

## Examples

``` r
ui <- shiny::fluidPage(
  shinyjs::useShinyjs(),
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    error_summary(
      inputId = "errorId",
      error_title = "Error title",
      error_list = c("error item1", "error item2")
    )
  ),
  shinyGovstyle::button_Input("btn1", "Change error summary"),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {
  shiny::observeEvent(input$btn1, {
    error_summary_update(
      "errorId",
      c("error item1", "error item2", "error item3")
    )
  },
  ignoreInit = TRUE
  )
}

if (interactive()) shinyApp(ui = ui, server = server)
```
