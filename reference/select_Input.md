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

  Insert the text for the label

- select_text:

  Add the text that will apply in the drop down as a list

- select_value:

  Add the value that will be used for each selection

## Value

a select input HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
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
