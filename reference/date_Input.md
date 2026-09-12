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
  year = NULL,
  label_size = c("m", "s", "l", "xl"),
  heading_level = NULL
)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.

- label:

  Display label for the control, or `NULL` for no label. Accepts a plain
  character string, an HTML string, or `shiny` tag objects such as
  `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

- hint_label:

  Display hint label for the control, or `NULL` for no hint label.
  Accepts the same rich content as `label`, so it can include a link.

- error:

  If `TRUE`, render the component in its error state and reserve a slot
  for the error message. Defaults to `FALSE`.

- error_message:

  Text shown when `error` is `TRUE`. Defaults to `NULL`.

- day:

  Select a default day on start up. Defaults to `NULL`

- month:

  Select a default month on start up. Defaults to `NULL`

- year:

  Select a default year on start up. Defaults to `NULL`

- label_size:

  Size modifier for the legend. One of `"m"`, `"s"`, `"l"`, or `"xl"`,
  matching the GDS `govuk-fieldset__legend--*` classes. Defaults to
  `"m"`.

- heading_level:

  Optional heading level for the legend. If supplied (an integer 1-6),
  the legend text is wrapped in a `<hN>` with the GDS
  `govuk-fieldset__heading` class, following the GDS pattern for using a
  question as the page heading. Defaults to `NULL` (no heading wrap).

## Value

a data input HTML shiny tag object

## See also

Other Govstyle text types:
[`gov_list()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_list.md),
[`heading_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/heading_text.md),
[`input_field()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/input_field.md),
[`text_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/text_Input.md),
[`text_area_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/text_area_Input.md),
[`word_count()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/word_count.md)

## Examples

``` r
ui <- shiny::fluidPage(
  # Required for error handling function.
  shinyjs::useShinyjs(),
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
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
    # Rich content: a link in the hint
    shinyGovstyle::date_Input(
      inputId = "dob_input3",
      label = "Please enter your birthday",
      hint_label = shiny::tagList(
        "Check the format in the ",
        shinyGovstyle::external_link("https://www.gov.uk", "GOV.UK guidance")
      )
    ),
    # Button to trigger error
    shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
  ),
  shinyGovstyle::footer(full = TRUE)
)

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
