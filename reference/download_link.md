# Download link

The `download_link()` provides a standard way to provide a download
link, which facilitates important accessible / positive user experience
elements, namely:

- file type

- file size

These are necessary in order for users to understand what they are
downloading, both in terms of being able to decide if they are
comfortable with downloading the file over their current connection and
if it's in a form they're able to deal with once it is downloaded. If
the exact file size is not easily determined, then it may be acceptable
to provide an estimate or an upper limit.

## Usage

``` r
download_link(outputId, link_text, file_type = "CSV", file_size = NULL)
```

## Arguments

- outputId:

  The name of the output slot that the
  [`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)
  is assigned to

- link_text:

  Text that will appear describing the download action. Vague text like
  'click here' or 'here' will cause an error, as will ending in a full
  stop. Leading and trailing white space will be automatically trimmed.
  If the string is shorter than 7 characters a console warning will be
  thrown. There is no way to hush this other than providing more detail

- file_type:

  The file type to be download (default: CSV)

- file_size:

  The file size if known. Needs to be a string ending in one of KB, MB,
  GB or rows

## Value

shiny tag object

## Examples

``` r
ui <- shiny::fluidPage(
  gov_text("Choose a data set to download."),
  select_Input(
    "dataset",
    "Data set",
    select_text = c("Car road tests", "New York air quality"),
    select_value = c("mtcars", "airquality")
  ),
  gov_text(
    download_link(
      "download_data",
      "Download selected data set",
      file_size = "4 KB"
    )
  )
)

server <- function(input, output) {
  # The requested data set
  data <- reactive({
    get(input$dataset)
  })

  output$download_data <- downloadHandler(
    filename = function() {
      # Use the selected dataset as the suggested file name
      paste0(input$dataset, ".csv")
    },
    content = function(file) {
      # Write the dataset to the `file` that will be downloaded
      write.csv(data(), file)
    }
  )
}

if (interactive()) shiny::shinyApp(ui, server)
```
