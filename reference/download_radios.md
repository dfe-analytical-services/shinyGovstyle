# Download with extension radios

Download with extension radios

## Usage

``` r
download_radios(
  id = "download_radios",
  download_type = "table",
  file_types = c("CSV", "ODS", "XLSX"),
  file_sizes = c("< 1 GB", "< 1 GB", "< 1 GB"),
  small = FALSE
)
```

## Arguments

- id:

  Shiny element Id. Default is "download_radios", but must be customised
  to be unique if multiple instances of this module are being used in a
  single app. Must match up to the ID of a `download_radios_helper()`
  instance in server code

- download_type:

  Element being downloaded. Expected to be along the lines of
  "underlying data", "table", "current data view". Default is "table"

- file_types:

  File formats to offer, can be any combination of "CSV", "XLSX", "ODS".
  Default is a vector of all 3

- file_sizes:

  Estimated file sizes for each file format. This needs to be a vector
  of the same length as file_types

- small:

  Set radio buttons to small size (logical, default: FALSE)

## Value

UI containing radio selection and download button

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
