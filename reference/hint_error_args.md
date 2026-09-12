# Shared input-state arguments (internal)

Documentation-only function. Holds the canonical `@param` entries for
the trio of params that describe an input's visible state (`hint_label`,
`error`, `error_message`), inherited by functions via `@inheritParams`.
Functions without a `hint_label` in their signature inherit only the
applicable subset.

## Usage

``` r
hint_error_args(hint_label, error, error_message)
```

## Arguments

- hint_label:

  Optional hint text shown beneath the label to guide the user. `NULL`
  (default) omits the hint.

- error:

  If `TRUE`, render the component in its error state and reserve a slot
  for the error message. Defaults to `FALSE`.

- error_message:

  Text shown when `error` is `TRUE`. Defaults to `NULL`.
