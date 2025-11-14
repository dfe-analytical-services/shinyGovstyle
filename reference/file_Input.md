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

  The input slot that will be used to access the value

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

  Whenever to icnlud error handling. Defaults to FALSE

- error_message:

  Message to display on error. Defaults to NULL

## Value

a file input HTML shiny tag object

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
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

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
