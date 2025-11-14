# Input Field Function

This function inserts number of text inputs. Useful for addresses.

## Usage

``` r
input_field(
  legend,
  labels,
  inputIds,
  widths = NULL,
  types = "text",
  error = FALSE,
  error_message = NULL
)
```

## Arguments

- legend:

  Legend that goes above the fieldset

- labels:

  A list of labels for the text inputs

- inputIds:

  A list input slots that will be used to access the value

- widths:

  control the size of the box based on number of characters required.
  Options are 30, 20, 10, 5, 4, 3, 2. NULL will not limit the size

- types:

  text box types. Will default to text

- error:

  Whenever to icnlud error handling. Defaults to FALSE

- error_message:

  Message to display on error. Defaults to NULL

## Value

a input field of HTML as a shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  # Required for error handling function
  shinyjs::useShinyjs(),
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::banner(
    inputId = "banner", type = "beta", 'This is a new service'
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::input_field(
      legend ="List of three text boxes in a field",
      labels = c("Field 1", "Field 2", "Field 3"),
      inputIds = c("field1", "field2", "field3"),
      widths = c(30,20,10),
      error = TRUE
    ),
   # Button to trigger error
   shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {
  # Trigger error on blank submit of field2
  observeEvent(input$submit, {
    if (input$field2 == ""){
      shinyGovstyle::error_on(
        inputId = "field2",
        error_message = "Please complete"
      )
    } else {
      shinyGovstyle::error_off(
        inputId = "field2"
      )
    }
  })
}
if (interactive()) shinyApp(ui = ui, server = server)
```
