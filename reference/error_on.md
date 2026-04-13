# Error on Function

This function turns on the error for the component. Can be used to
validate inputs.

## Usage

``` r
error_on(inputId, error_message = NULL)
```

## Arguments

- inputId:

  The input id that you to to turn the error on for

- error_message:

  if you want to add an additional error message Defaults to NULL,
  showing the original designed error message

## Value

no return value. This toggles on error CSS

## See also

Other Govstyle errors:
[`error_off()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/error_off.md),
[`error_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/error_summary.md),
[`error_summary_update()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/error_summary_update.md)

## Examples

``` r
ui <- shiny::fluidPage(
  # Required for error handling function
  shinyjs::useShinyjs(),
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "beta", 'This is a new service'
  ),
  shinyGovstyle::gov_layout(size = "two-thirds",
    # Error text box
    shinyGovstyle::text_Input(
      inputId = "eventId",
      label = "Event Name",
      error = TRUE),
    # Button to trigger error
    shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {
  # Trigger error on blank submit of eventId2
  observeEvent(input$submit, {
    if (input$eventId != ""){
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
