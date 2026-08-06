# Select Function

This function inserts a select box

## Usage

``` r
select_Input(inputId, label, select_text, select_value)
```

## Arguments

- inputId:

  Input Id for the component

- label:

  Display label for the control, or `NULL` for no label. Accepts a plain
  character string, an HTML string, or `shiny` tag objects such as
  `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

- select_text:

  Add the text that will apply in the drop down as a list

- select_value:

  Add the value that will be used for each selection

## Value

a select input HTML shiny tag object

## See also

Other Govstyle select inputs:
[`button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/button_Input.md),
[`checkbox_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/checkbox_Input.md),
[`file_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/file_Input.md),
[`radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/radio_button_Input.md),
[`update_radio_button_Input()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_radio_button_Input.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png",
    logo_alt_text = "Ministry of Justice logo"
  ),
  shinyGovstyle::gov_layout(
    size = "full",
    select_Input(
      inputId = "sorter",
      label = "Sort by",
      select_text = c(
        "Recently published",
        "Recently updated",
        "Most views",
        "Most comments"
      ),
      select_value = c("published", "updated", "view", "comments")
    ),
    shiny::tags$br()
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
