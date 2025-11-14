# Cookie Banner Function

This function creates a cookie banner. You need to have
[`shinyjs::useShinyjs()`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html)
enabled for this to work. All the Ids are preset. See example for how to
structure.

## Usage

``` r
cookieBanner(service_name)
```

## Arguments

- service_name:

  Name for this service to add to banner

## Value

a cookie banner HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"),
  #Needs shinyjs to work
  shinyjs::useShinyjs(),
  shinyGovstyle::cookieBanner("The best thing"),
  shinyGovstyle::gov_layout(size = "two-thirds"),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {
  # Set of observeEvent to create a path through the cookie banner
  observeEvent(input$cookieAccept, {
    shinyjs::show(id = "cookieAcceptDiv")
    shinyjs::hide(id = "cookieMain")
  })

  observeEvent(input$cookieReject, {
    shinyjs::show(id = "cookieRejectDiv")
    shinyjs::hide(id = "cookieMain")
  })

  observeEvent(input$hideAccept, {
    shinyjs::toggle(id = "cookieDiv")
  })

  observeEvent(input$hideReject, {
    shinyjs::toggle(id = "cookieDiv")
  })

  observeEvent(input$cookieLink, {
    # Need to link here to where further info is located. You can use
    # updateTabsetPanel to have a cookie page for instance
  })

}
if (interactive()) shinyApp(ui = ui, server = server)
```
