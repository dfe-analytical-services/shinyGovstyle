# Shared width argument (internal)

Documentation-only function. Holds the canonical `@param` entry for a
component's own `width`, inherited via `@inheritParams` by every
component that wraps a `.govuk-width-container`.
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md)
documents its `width` separately, since there it sets an ambient default
for child components rather than the component's own width.

## Usage

``` r
width_arg(width)
```

## Arguments

- width:

  Width of the component. One of `"standard"` (the default, GOV.UK's
  usual 960px content width), `"three-quarters"` (three-quarters of the
  viewport, never narrower than standard), `"full"` (no max-width, so
  the container fills the viewport, with grid gutters also removed), or
  a CSS length (e.g. `"1400px"`, `"90vw"`) for a custom max-width.
