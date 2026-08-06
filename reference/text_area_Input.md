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

  Display label for the control, or `NULL` for no label. Accepts a plain
  character string, an HTML string, or `shiny` tag objects such as
  `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

- hint_label:

  Display hint label for the control, or `NULL` for no hint label.
  Accepts the same rich content as `label`, so it can include a link.

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

## See also

Other Govstyle text types:
[`date_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/date_Input.md),
[`gov_list()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_list.md),
[`heading_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/heading_text.md),
[`input_field()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/input_field.md),
[`text_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/text_Input.md),
[`word_count()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/word_count.md)

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

# Rich content: a link in the hint
text_area_Input(
  "taId2",
  "Can you provide more detail?",
  shiny::tagList(
    "Read the ",
    shinyGovstyle::external_link("https://www.gov.uk", "guidance on detail")
  )
)
#> <div class="govuk-form-group govuk-character-count" id="taId2div">
#>   <label class="govuk-label">Can you provide more detail?</label>
#>   <div class="govuk-hint">
#>     Read the <a href="https://www.gov.uk" class="govuk-link" target="_blank" rel="noopener noreferrer">guidance on detail (opens in new tab)</a></div>
#>   <textarea id="taId2" class="govuk-textarea" rows="5"></textarea>
#> </div>
```
