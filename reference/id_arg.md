# Shared id argument (internal)

Documentation-only function. Holds the canonical `@param` entry for
`inputId`, inherited by consumers via `@inheritParams`.

## Usage

``` r
id_arg(inputId)
```

## Arguments

- inputId:

  The id assigned to the component's root element. For Shiny input
  components this is also the name used to access the value via
  `input$<inputId>`.
