# Tag Function

This function creates a tag.

## Usage

``` r
tag_Input(inputId, text, colour = "navy")
```

## Arguments

- inputId:

  The Id to access the tag

- text:

  The text in the tag

- colour:

  The colour of the tag. Default is navy. Other options are grey, green,
  teal, blue, purple, magenta, red, orange and yellow

## Value

a tag HTML shiny tag object

## See also

Other Govstyle feedback types:
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
[`insert_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/insert_text.md),
[`label_hint()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/label_hint.md),
[`noti_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/noti_banner.md),
[`panel_output()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/panel_output.md),
[`value_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/value_box.md),
[`warning_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/warning_text.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(
    size = "two-thirds",
    shinyGovstyle::tag_Input("tag1", "Complete"),
    shinyGovstyle::tag_Input("tag2", "Incomplete", "red")
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
