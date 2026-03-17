# Checkbox Function

This function inserts a checkbox group

## Usage

``` r
checkbox_Input(
  inputId,
  cb_labels,
  checkboxIds,
  label,
  hint_label = NULL,
  small = FALSE,
  error = FALSE,
  error_message = NULL
)
```

## Arguments

- inputId:

  Input Id for the group of checkboxes

- cb_labels:

  Add the names of the options that will appear

- checkboxIds:

  Add the values for each checkbox

- label:

  Insert the text for the checkbox group

- hint_label:

  Insert optional hint/secondary text. Defaults to NULL

- small:

  change the sizing to a small version of the checkbox. Defaults to
  `FALSE`

- error:

  Whenever you want to include error handle on the component

- error_message:

  If you want a default error message

## Value

a checkbox HTML shiny tag object

## See also

Other Govstyle select inputs:
[`button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/button_Input.md),
[`file_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/file_Input.md),
[`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md),
[`select_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/select_Input.md)

## Examples

``` r
ui <- shiny::fluidPage(
  # Required for error handling function
  shinyjs::useShinyjs(),
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"),
  shinyGovstyle::banner(
    inputId = "banner", type = "beta", 'This is a new service'),
  shinyGovstyle::gov_layout(size = "two-thirds",
    # Simple checkbox
    shinyGovstyle::checkbox_Input(
      inputId = "check1",
      cb_labels = c("Option 1", "Option 2", "Option 3"),
      checkboxIds = c("op1", "op2", "op3"),
      label = "Choice option"
    ),
    # Error checkbox
    shinyGovstyle::checkbox_Input(
      inputId = "check2",
      cb_labels = c("Option 1", "Option 2", "Option 3"),
      checkboxIds = c("op1", "op2", "op3"),
      label = "Choice option",
      hint_label = "Select the best fit",
      error = TRUE,
      error_message = "Select one"
    ),
    # Button to trigger error
    shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {
  # Trigger error on blank submit of eventId2
  observeEvent(input$submit, {
    if (is.null(input$check2)){
      shinyGovstyle::error_on(inputId = "check2")
    } else {
      shinyGovstyle::error_off(inputId = "check2")
    }
  })
}

if (interactive()) shinyApp(ui = ui, server = server)
```
