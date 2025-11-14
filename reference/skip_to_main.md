# Skip to main content link

This function generates a 'Skip to main content' link, which is
typically used by keyboard users to bypass content and navigate directly
to the main content of a page.

## Usage

``` r
skip_to_main(id = "main")
```

## Arguments

- id:

  An optional parameter to specify the Id of the main content section,
  will be automatically preceeded by a hash '#'. Default is "main" to
  match the "#main" Id within `gov_main()`.

## Value

A Shiny tag representing the 'Skip to main content' link

## Examples

``` r
ui <- shiny::fluidPage(
  skip_to_main(),
  header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  gov_main_layout(
    heading_text("Example heading"),
  )
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session){}

if (interactive()) shinyApp(ui = ui, server = server)
```
