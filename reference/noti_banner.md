# Notification Banner Function

This function creates a notification banner.

## Usage

``` r
noti_banner(
  inputId,
  title_txt = "Important",
  body_txt = NULL,
  type = "standard"
)
```

## Arguments

- inputId:

  The input Id for the banner

- title_txt:

  The wording that appears in the title

- body_txt:

  The wording that appears in the banner body

- type:

  The type of banner. Options are standard and success. Standard is
  default

## Value

a notification HTML shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"
  ),
  shinyGovstyle::noti_banner(
    inputId = "banner", title_txt = "Important", body_txt = "Example text"
  )
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
