# Shared download arguments (internal)

Documentation-only function. Holds the canonical `@param` entries for
`outputId`, `file_type` and `file_size`, inherited by the
download-button family via `@inheritParams`.

## Usage

``` r
download_args(outputId, file_type, file_size)
```

## Arguments

- outputId:

  The name of the output slot that the
  [`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)
  is assigned to.

- file_type:

  File extension shown to the user (e.g. `"CSV"`, `"PDF"`). Defaults to
  `"CSV"`.

- file_size:

  Optional human-readable file size; a string ending in `KB`, `MB`,
  `GB`, or `rows`.
