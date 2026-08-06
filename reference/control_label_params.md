# Shared parameter documentation

Internal documentation object holding the standard descriptions for the
label and hint arguments shared across the form-control components. Pull
these into a function with `@inheritParams control_label_params` so the
rich-content wording stays consistent in one place.

## Arguments

- label:

  Display label for the control, or `NULL` for no label. Accepts a plain
  character string, an HTML string, or `shiny` tag objects such as
  `shiny::tags$b("Bold")` or a
  [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

- hint_label:

  Display hint label for the control, or `NULL` for no hint label.
  Accepts the same rich content as `label`, so it can include a link.

- hint_input:

  Display hint label for the control, or `NULL` for no hint label.
  Accepts the same rich content as `label`, so it can include a link.
