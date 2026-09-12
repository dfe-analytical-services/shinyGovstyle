# File Input Function

This function create a file upload component. It uses the basis of the
shiny fileInput function, but restyles the label and adds error onto it.

## Usage

``` r
file_Input(
  inputId,
  label,
  multiple = FALSE,
  accept = NULL,
  width = NULL,
  buttonLabel = "Choose file",
  placeholder = "No file chosen",
  error = FALSE,
  error_message = NULL
)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- label:

  Display label for the control, or `NULL` for no label

- multiple:

  Whether the user should be allowed to select and upload multiple files
  at once. Does not work on older browsers, including Internet Explorer
  9 and earlier

- accept:

  A character vector of MIME types; gives the browser a hint of what
  kind of files the server is expecting

- width:

  The width of the input, e.g. `'400px'`, or `'100\%'`

- buttonLabel:

  The label used on the button. Can be text or an HTML tag object

- placeholder:

  The text to show before a file has been uploaded

- error:

  If `TRUE`, render the component in its error state and reserve a slot
  for the error message. Defaults to `FALSE`.

- error_message:

  Text shown when `error` is `TRUE`. Defaults to `NULL`.

## Value

a file input HTML shiny tag object

## See also

Other Govstyle select inputs:
[`button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/button_Input.md),
[`checkbox_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/checkbox_Input.md),
[`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md),
[`select_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/select_Input.md),
[`update_radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_radio_button_Input.md)

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
    # Simple file input
    shinyGovstyle::file_Input(inputId = "file1", label = "Upload a file"),
    # Error file
    shinyGovstyle::file_Input(
      inputId = "file2",
      label = "Upload a file",
      error = TRUE
    ),
    # Button to trigger error
    shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {
  # Trigger error on blank submit of file2
  observeEvent(input$submit, {
    if (is.null(input$file2)){
      shinyGovstyle::error_on(inputId = "file2")
    } else {
      shinyGovstyle::error_off(
        inputId = "file2"
      )
    }
  })
}
if (interactive()) shinyApp(ui = ui, server = server)
```
