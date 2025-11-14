# Text Input Function

This function create a text input.

## Usage

``` r
text_Input(
  inputId,
  label,
  hint_label = NULL,
  type = "text",
  width = NULL,
  error = FALSE,
  error_message = NULL,
  prefix = NULL,
  suffix = NULL
)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- label:

  Display label for the control, or `NULL` for no label

- hint_label:

  Display hint label for the control, or `NULL` for no hint label

- type:

  Type of text input to accept. Defaults to text

- width:

  control the size of the box based on number of characters required.
  Options are 30, 20, 10, 5, 4, 3, 2. NULL will not limit the size

- error:

  Whenever to include error handling. Defaults to FALSE

- error_message:

  Message to display on error. Defaults to NULL

- prefix:

  Add a prefix to the box. Defaults to NULL

- suffix:

  Add a suffix to the box. Defaults to NULL

## Value

a text input HTML shiny tag object

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
    # Simple text box
    shinyGovstyle::text_Input(inputId = "eventId", label = "Event Name"),
    # Error text box
    shinyGovstyle::text_Input(
      inputId = "eventId2",
      label = "Event Name",
      hint_label = "This can be found on the letter",
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
    if (input$eventId2 != "") {
      shinyGovstyle::error_off(inputId = "eventId2")
    } else {
      shinyGovstyle::error_on(
        inputId = "eventId2",
        error_message = "Please complete"
      )
    }
  })
}

if (interactive()) shinyApp(ui = ui, server = server)
```
