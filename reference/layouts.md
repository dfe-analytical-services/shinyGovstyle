# Page Layout Functions

These function loads the page layout in a gov layout. There is a
selection of components that can sit within each other. The
gov_main_layout is the overarching layout. The gov_row creates a each
row and gov_box creates a box within the row. The gov_text is a
container for text bodies.

## Usage

``` r
gov_main_layout(..., inputID = "main")

gov_row(...)

gov_box(..., size = "full")

gov_text(...)
```

## Arguments

- ...:

  include the components of the UI that you want within the main page.
  These components are made to flow through each other. See example

- inputID:

  ID of the main div. Defaults to "main"

- size:

  size of the box in the row. Optional are full, one-half, two-thirds,
  one-third and one-quarter. Defaults to "full"

## Value

a HTML shiny layout div

## Examples

``` r
ui <- shiny::fluidPage(
  shinyGovstyle::header(
    main_text = "Example",
    secondary_text = "User Examples",
    logo="shinyGovstyle/images/moj_logo.png"),
  shinyGovstyle::gov_main_layout(
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "full",
        shinyGovstyle::gov_text("govuk-grid-column-full")
      )
    ),
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "one-half",
        shinyGovstyle::gov_text("govuk-grid-column-one-half")
      ),
      shinyGovstyle::gov_box(
        size = "one-half",
        shinyGovstyle::gov_text("govuk-grid-column-one-half")
      )
    ),
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "one-third",
        shinyGovstyle::gov_text("govuk-grid-column-one-third")
      ),
      shinyGovstyle::gov_box(
        size = "two-third",
        shinyGovstyle::gov_text("govuk-grid-column-two-third")
      )
    ),
    shinyGovstyle::gov_row(
      shinyGovstyle::gov_box(
        size = "one-quarter",
        shinyGovstyle::gov_text("govuk-grid-column-one-quarter")
      ),
      shinyGovstyle::gov_box(
        size = "three-quarters",
        shinyGovstyle::gov_text("govuk-grid-column-three-quarters")
      )
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)
#> Warning: Please use logo_alt_text to provide alternative text for the logo you used.

server <- function(input, output, session) {}

if (interactive()) shinyApp(ui = ui, server = server)
```
