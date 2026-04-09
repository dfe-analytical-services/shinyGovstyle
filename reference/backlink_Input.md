# Back Link Function

This function adds a back link to the page

## Usage

``` r
backlink_Input(inputId, label = "Back")
```

## Arguments

- inputId:

  The input slot that will be used to access the value

- label:

  The link text for the backlink, default is "Back"

## Value

a backlink HTML shiny tag object

## See also

Other Govstyle navigation:
[`contents_link()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/contents_link.md),
[`service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/service_navigation.md),
[`update_service_navigation()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/update_service_navigation.md)

## Examples

``` r
ui <- shiny::fluidPage(
  header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shiny::navlistPanel(
    "",
    id = "nav",
    widths = c(2, 10),
    well = FALSE,
    # Create first panel
    shiny::tabPanel(
      "Select Types",
      value = "panel1",
      gov_layout(
        size = "two-thirds",
        backlink_Input("link1"),
        shiny::tags$br(),
        shiny::tags$br()
      )
    ),
    shiny::tabPanel(
      "Tab2",
      value = "panel2"
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)

server <- function(input, output, session) {
  # Slightly confused in that it goes forward rather than back
  # but shows how to use
  observeEvent(input$link1, {
    updateTabsetPanel(session, "nav", selected = "panel2")
  })
}

if (interactive()) shinyApp(ui = ui, server = server)
```
