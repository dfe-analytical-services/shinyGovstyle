# Download with extension radios handler

Download with extension radios handler

## Usage

``` r
download_radios_handler(id = "download_radios", file_name, file_contents)
```

## Arguments

- id:

  Shiny element Id. Default is "download_radios", but must be customised
  to be unique if multiple instances of this module are being used in a
  single app. Must match up to the ID of a
  [`download_radios()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/download_radios.md)
  instance in UI code

- file_name:

  Name of the file to be downloaded

- file_contents:

  Contents to write to the download file

## Value

Output for use with
[`download_radios()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/download_radios.md)

## Examples

``` r
ui <- shiny::fluidPage(
  download_radios("download_file",
    file_types = c("CSV", "ODS"),
    file_sizes = c("2 KB", "5 KB")
  )
)

server <- function(input, output, session) {
  output$download_file <- download_radios_handler(
    "download_file",
    file_name = "simple_data_frame",
    file_contents = mtcars
  )
}

if (interactive()) shinyApp(ui, server)
```
