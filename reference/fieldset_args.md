# Shared fieldset arguments (internal)

Documentation-only function. Holds the canonical `@param` entries for
`label_size` and `heading_level`, which are inherited by the input
functions that build on `govFieldset()` via `@inheritParams`.

## Usage

``` r
fieldset_args(label_size, heading_level)
```

## Arguments

- label_size:

  Size modifier for the legend. One of `"m"`, `"s"`, `"l"`, or `"xl"`,
  matching the GDS `govuk-fieldset__legend--*` classes. Defaults to
  `"m"`.

- heading_level:

  Optional heading level for the legend. If supplied (an integer 1-6),
  the legend text is wrapped in a `<hN>` with the GDS
  `govuk-fieldset__heading` class, following the GDS pattern for using a
  question as the page heading. Defaults to `NULL` (no heading wrap).
