# Shared table title documentation (internal)

Documentation-only object. Holds the `subtitle` parameter and the "Table
titles" section shared by
[`govTable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govTable.md),
[`govReactable()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable.md),
and
[`govReactableOutput()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/govReactable-shiny.md),
pulled in with `@inheritParams table_title_params` and
`@inheritSection table_title_params Table titles`.

## Arguments

- subtitle:

  Optional line under the caption, in smaller, lighter text: what the
  data is, where and when it covers, and the units if every value shares
  them (e.g. `"Cost of bikes (£), England, 2025"`). It becomes part of
  the table's accessible name, with the caption. Needs a `caption`.
  Plain text is escaped and shown as written; use
  [`shiny::HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  or tags for markup. `NULL` (default) shows no subtitle

## Table titles

Every table needs a title. The [Analysis Function guidance on
tables](https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-tables/)
suggests two parts, which match two arguments:

- `caption`: a short headline stating the message, e.g.
  `"Costs peaked in March"`.

- `subtitle`: what the data is, where and when, e.g.
  `"Cost of bikes, vans and buses (£), England, January to May 2025"`.
  Include the units if every value shares them.

A headline is optional. Without one, put the what, where and when in
`caption` and leave out `subtitle`.

Put the source of the data under the table (for example with
[`gov_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md)),
not in the title.

Screen reader users hear the caption and subtitle together when they
reach the table, so keep them short and don't repeat information. See
also the [GOV.UK Design System table
component](https://design-system.service.gov.uk/components/table/).
