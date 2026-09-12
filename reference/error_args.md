# Shared error-state arguments (internal)

Documentation-only function. Holds the canonical `@param` entries for
the pair of params that describe an input's error state (`error`,
`error_message`), inherited by functions via `@inheritParams`. Used by
components whose `label`/`hint_label` docs are instead covered by
[control_label_params](https://dfe-analytical-services.github.io/shinyGovstyle/reference/control_label_params.md),
to avoid documenting `hint_label` twice.

## Usage

``` r
error_args(error, error_message)
```

## Arguments

- error:

  If `TRUE`, render the component in its error state and reserve a slot
  for the error message. Defaults to `FALSE`.

- error_message:

  Text shown when `error` is `TRUE`. Defaults to `NULL`.
