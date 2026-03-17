# Header Function

This function create a header banner. For use at top of the screen

## Usage

``` r
header(
  main_text = "Shiny example app",
  secondary_text = NULL,
  logo = "shinyGovstyle/images/Dept_logo.svg",
  main_link = NULL,
  secondary_link = NULL,
  logo_alt_text = "Departmental logo",
  main_alt_text = NULL,
  secondary_alt_text = NULL,
  logo_width = 66,
  logo_height = 34
)
```

## Arguments

- main_text:

  Main text that goes in the header

- secondary_text:

  Secondary header to supplement the main text the main text

- logo:

  Add a link to a logo which will apply in the header. Use crown to use
  the crown SVG version on GOV UK

- main_link:

  Add a link for clicking on main text **\[deprecated\]**

- secondary_link:

  Add a link for clicking on secondary header **\[deprecated\]**

- logo_alt_text:

  Add alternative text for the logo. Should be used when a logo is used

- main_alt_text:

  Add alternative text for the main link. Should be used when a main
  link is used **\[deprecated\]**

- secondary_alt_text:

  Add alternative text for the secondary link. Should be used when a
  secondary link is used **\[deprecated\]**

- logo_width:

  Change the logo size width CSS to improve fit

- logo_height:

  Change the logo size height CSS to improve fit

## Value

a header HTML shiny tag object

## See also

Other Govstyle page structure:
[`banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/banner.md),
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`gov_layout()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_layout.md),
[`layouts`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md)

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo = "shinyGovstyle/images/moj_logo.png",
    logo_alt_text = "Ministry of Justice Logo"
  )
)

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
