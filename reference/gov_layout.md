# Page Layout Function

This function loads the page layout, This doesn't work as well as the
`gov_main_layout` and associated functions. This is being kept for now
as a simpler version where grids are not needed.

## Usage

``` r
gov_layout(..., inputID = "main", size = "full")
```

## Arguments

- ...:

  include the components of the UI that you want within the main page.

- inputID:

  ID of the main div. Defaults to "main"

- size:

  Layout of the page. Optional are full, one-half, two-thirds, one-third
  and one-quarter. Defaults to "full"

## Value

a HTML shiny layout div

## See also

Other Govstyle page structure:
[`banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/banner.md),
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`header()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/header.md),
[`layouts`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::gov_layout(
    size = "full",
    shinyGovstyle::panel_output(
      inputId = "panel1",
      main_text = "Application Complete",
      sub_text = paste(
        "Thank you for submitting your application.",
        "Your reference is xvsiq"
      )
    ),
    shinyGovstyle::footer(full = TRUE)
  )
)

server <- function(input, output, session) {}
if (interactive()) shinyApp(ui = ui, server = server)
```
