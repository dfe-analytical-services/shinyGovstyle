# Run examples

This function runs an example R Shiny app showcasing different parts of
the package. Code for the app can be found in the inst/example_app
folder in the source code.

## Usage

``` r
run_example()
```

## Value

runs an R Shiny app with examples in

## Details

The app uses the [bslib package](https://rstudio.github.io/bslib/) as is
generally recommended for Shiny apps.

The app is also deployed at the following URL:
https://department-for-education.shinyapps.io/shinygovstyle-example-app/

## Examples

``` r
if (interactive()) run_example()
```
