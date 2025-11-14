# Error off Function

This function turns off the the error o the component, once issues have
been sorted.

## Usage

``` r
error_off(inputId)
```

## Arguments

- inputId:

  The input Id to turn error handling on for

## Value

no return value. This toggles off error CSS

## Examples

``` r
ui <- shiny::fluidPage(
  # Required for error handling function
  shinyjs::useShinyjs(),
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "beta", 'This is a new service'
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    # Error text box
    shinyGovstyle::text_Input(
      inputId = "eventId",
      label = "Event Name",
      error = TRUE
    ),
    # Button to trigger error
    shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {
  # Trigger error on blank submit of eventId2
  observeEvent(input$submit, {
    if (input$eventId != "") {
      shinyGovstyle::error_off(inputId = "eventId")
    } else {
      shinyGovstyle::error_on(
        inputId = "eventId",
        error_message = "Please complete"
      )
    }
  })
}

if (interactive()) shinyApp(ui = ui, server = server)
```
