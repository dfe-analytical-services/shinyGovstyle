# Text Area Input Function

This function create a text area input.

## Usage

``` r
text_area_Input(
  inputId,
  label,
  hint_label = NULL,
  row_no = 5,
  error = FALSE,
  error_message = NULL,
  word_limit = NULL
)
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- label:

  Display label for the control, or `NULL` for no label

- hint_label:

  Display hint label for the control, or `NULL` for no hint label

- row_no:

  Size of the text entry box. Defaults to 5

- error:

  Whenever to include error handling. Defaults to `FALSE`

- error_message:

  Message to display on error. Defaults to `NULL`

- word_limit:

  Add a word limit to the display. Defaults to `NULL`

## Value

a text area box HTML shiny tag object

## Examples

``` r
text_area_Input(
  "taId",
  "Can you provide more detail?",
  paste(
    "Do not include personal or financial information, like your",
    "National Insurance number or credit card details."
  )
)
#> <div class="govuk-form-group govuk-character-count" id="taIddiv">
#>   <label class="govuk-label">Can you provide more detail?</label>
#>   <div class="govuk-hint">Do not include personal or financial information, like your National Insurance number or credit card details.</div>
#>   <textarea id="taId" class="govuk-textarea" rows="5"></textarea>
#> </div>
```
