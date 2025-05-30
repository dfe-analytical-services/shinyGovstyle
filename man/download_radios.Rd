% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_radios.R
\name{download_radios}
\alias{download_radios}
\title{Download with extension radios}
\usage{
download_radios(
  id = "download_radios",
  download_type = "table",
  file_types = c("CSV", "ODS", "XLSX"),
  file_sizes = c("< 1 GB", "< 1 GB", "< 1 GB"),
  small = FALSE
)
}
\arguments{
\item{id}{Shiny element ID. Default is "download_radios", but must be customised to be unique
if multiple instances of this module are being used in a single app. Must match up to the ID
of a `download_radios_helper()` instance in server code.}

\item{download_type}{Element being downloaded. Expected to be along the lines of "underlying
data", "table", "current data view". Default is "table".}

\item{file_types}{File formats to offer, can be any combination of "CSV", "XLSX", "ODS". Default
is a vector of all 3.}

\item{file_sizes}{Estimated file sizes for each file format. This needs to be a vector of the
same length as file_types.}

\item{small}{Set radio buttons to small size (logical, default: FALSE)}
}
\value{
UI containing radio selection and download button
}
\description{
Download with extension radios
}
\examples{
if (interactive()) {
  library(shiny)
  library(shinyGovstyle)

  ui <- fluidPage(
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

  # How to run the minimal app given in this example =======================
  shinyApp(ui, server)
}
}
