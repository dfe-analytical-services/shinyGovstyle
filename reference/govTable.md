# Table Function

This function inserts a gov styled table. Format is with header looking
rows and columns

## Usage

``` r
govTable(
  inputId,
  df,
  caption,
  caption_size = "l",
  num_col = NULL,
  width_overwrite = NULL
)
```

## Arguments

- inputId:

  Input Id for the table

- df:

  expects a dataframe to create a table

- caption:

  adds a caption to the table as a header

- caption_size:

  adjust the size of caption. Options are s, m, l, xl, with l as the
  default

- num_col:

  adds numeric class format to these columns

- width_overwrite:

  change width. Need to include width for every column. Columns must add
  up to 1. Options are three-quarters, two-thirds, one-half, one-third,
  one-quarter. Default is `NULL`

## Value

a table HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::govTable(
      "tab1",
      shinyGovstyle::transport_data_small,
      "Test",
      "l",
      num_col = c(2,3),
      width_overwrite = c("one-half", "one-quarter", "one-quarter")
    )
  )
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
