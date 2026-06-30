# Update a Govstyle radio button input on the client

Server-side companion to
[`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md),
mirroring
[`shiny::updateRadioButtons()`](https://rdrr.io/pkg/shiny/man/updateRadioButtons.html).
Use it to change the selected option, the available choices, or the
label of an existing radio button group from within an observer, for
example to keep a cookies settings radio in sync with a choice the user
made elsewhere.

## Usage

``` r
update_radio_button_Input(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  label = NULL,
  choices = NULL,
  selected = NULL,
  inline = FALSE,
  small = FALSE,
  choiceNames = NULL,
  choiceValues = NULL
)
```

## Arguments

- session:

  The `session` object passed to the Shiny server function. Defaults to
  the current reactive domain.

- inputId:

  The id of the
  [`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md)
  to update

- label:

  New label for the input, or `NULL` to leave unchanged

- choices:

  New vector of choices, or `NULL` to leave unchanged (if elements of
  the vector are named then that name rather than the value is displayed
  to the user)

- selected:

  The value to select, or `NULL` to leave unchanged

- inline:

  Whether the radios are inline. Only applies when `choices` (or
  `choiceNames`/`choiceValues`) are also supplied, since regenerating
  the options replaces the whole option container; if you do not re-pass
  it the layout falls back to default. Defaults to FALSE

- small:

  Whether to use the smaller radios. Only applies when `choices` (or
  `choiceNames`/`choiceValues`) are also supplied, since regenerating
  the options replaces the whole option container; if you do not re-pass
  it the layout falls back to default. Defaults to FALSE

- choiceNames, choiceValues:

  As in
  [`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md),
  an alternative to `choices` allowing richer labels. Both must be
  supplied together

## Value

Called for its side effect of sending a message to the client; no return
value

## Details

Only the arguments you supply are sent to the client; everything left at
its default of `NULL` is left untouched. Because it relies on
`session$sendInputMessage()`, the `inputId` is namespaced automatically
when called inside a Shiny module, so pass the unnamespaced id just as
you would to
[`shiny::updateRadioButtons()`](https://rdrr.io/pkg/shiny/man/updateRadioButtons.html).

This function is deliberately agnostic about why you are updating the
radio, which makes it a useful building block for packages that layer
extra behaviour (such as analytics cookie consent) on top of
shinyGovstyle. See the cookies and analytics vignette for an example of
extending it.

## See also

[`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md)

Other Govstyle select inputs:
[`button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/button_Input.md),
[`checkbox_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/checkbox_Input.md),
[`file_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/file_Input.md),
[`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md),
[`select_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/select_Input.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyjs::useShinyjs(),
  shinyGovstyle::radio_button_Input(
    inputId = "cookies",
    label = "Do you want to accept analytics cookies?",
    choices = c("Yes" = "yes", "No" = "no"),
    selected = "no",
    inline = TRUE
  ),
  shinyGovstyle::button_Input(inputId = "accept", label = "Accept cookies")
)

server <- function(input, output, session) {
  # Keep the radio in sync with a choice made elsewhere
  shiny::observeEvent(input$accept, {
    shinyGovstyle::update_radio_button_Input(
      session,
      inputId = "cookies",
      selected = "yes"
    )
  })
}
if (interactive()) shinyApp(ui = ui, server = server)
```
