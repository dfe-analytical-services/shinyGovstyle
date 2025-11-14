# Date Input Function

This function create a date input that follows GDS component

## Usage

``` r
date_Input(
  inputId,
  label,
  hint_label = NULL,
  error = FALSE,
  error_message = NULL,
  day = NULL,
  month = NULL,
  year = NULL
)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- label:

  Display label for the control, or `NULL` for no label

- hint_label:

  Display hint label for the control, or `NULL` for no hint label

- error:

  Whenever to include error components.Defaults to `FALSE`

- error_message:

  Error handling message? Defaults to `NULL`

- day:

  Select a default day on start up. Defaults to `NULL`

- month:

  Select a default month on start up. Defaults to `NULL`

- year:

  Select a default year on start up. Defaults to `NULL`

## Value

a data input HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  # Required for error handling function.
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
    # Simple date input
    shinyGovstyle::date_Input(
      inputId = "dob_input",
      label = "Please enter your birthday"
    ),
    # Error date input
    shinyGovstyle::date_Input(
      inputId = "dob_input2",
      label = "Please enter your birthday",
      hint_label = "For example, 12 11 2007",
      error = TRUE
    ),
    # Button to trigger error
    shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {
  # Trigger error on blank submit of dob_input2
  observeEvent(input$submit, {
    if (input$dob_input2 == "//") {
      shinyGovstyle::error_on(inputId = "dob_input2")
    } else {
      shinyGovstyle::error_off(inputId = "dob_input2")
    }
  })
}

if (interactive()) shinyApp(ui = ui, server = server)
```
