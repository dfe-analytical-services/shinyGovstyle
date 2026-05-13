# Plan: `gov_summary` breakpoint fix + full GOV.UK feature parity

**Branch**: `fix/89-gov-summary-word-break-and-spec-gaps`
**Closes**: [#89](https://github.com/dfe-analytical-services/shinyGovstyle/issues/89) and adds full feature parity with the GOV.UK summary list spec.

---

## Why the original CSS fix is dropped

The earlier plan proposed adding `word-break: normal` to `.govuk-summary-list__key`. After re-investigation that change is **not warranted**:

- `word-break: normal` is the browser default; alongside `overflow-wrap: break-word` (which govuk-frontend sets intentionally) it would have no effect.
- The mid-character breaking is govuk-frontend's intended behaviour for narrow key columns and the same code runs on the official design system website.
- Manual testing confirmed the design system *does* break at similar widths; it's just less visible because of font / padding differences.

The actual fix the user wants is **structural**: delay the side-by-side table layout until a wider viewport so the key column is never as narrow as ~100–120px in normal Shiny layouts.

---

## Change 1 — Push the side-by-side layout from `tablet` (641px) to `desktop` (769px)

govuk-frontend switches `.govuk-summary-list` from block layout to `display: table; table-layout: fixed` at `min-width: 40.0625em` (641px). At that breakpoint the key column is fixed at 30% of the container, which inside a `gov_layout(size = "two-thirds")` works out to ~110–120px — narrow enough to break single English words like "information" or "Correspondence".

**Approach**: ship a `summary-overrides.css` that reverts the table layout to stacked layout for the range `40.0625em` – `48.0525em` (641px to 768px). Above 769px the original govuk-frontend rules take over and the side-by-side layout kicks in.

**Files**:
- `inst/www/css/summary-overrides.css` (NEW)
- `R/summary.R` (register the dependency on the returned tag)

**CSS**:

```css
/*
 * Summary list breakpoint override.
 *
 * govuk-frontend switches the summary list to a fixed-layout table at 40.0625em
 * (641px). In Shiny apps using gov_layout(size = "two-thirds") the resulting
 * 30% key column is around 110-120px - too narrow for typical English key
 * names, forcing overflow-wrap: break-word to break words mid-character.
 *
 * This override keeps the stacked layout in place until the desktop breakpoint
 * (48.0625em / 769px), matching the rest of the GOV.UK responsive grid.
 *
 * Above 769px the original govuk-frontend rules apply unchanged.
 */
@media (min-width: 40.0625em) and (max-width: 48.0525em) {
  .govuk-summary-list {
    display: block;
    margin-bottom: 20px;
  }
  .govuk-summary-list__row {
    display: block;
    margin-bottom: 15px;
  }
  .govuk-summary-list__key,
  .govuk-summary-list__value,
  .govuk-summary-list__actions {
    display: block;
    width: auto;
    padding: 0;
    text-align: left;
    vertical-align: baseline;
  }
  .govuk-summary-list__value,
  .govuk-summary-list__actions {
    margin-bottom: 15px;
  }
  .govuk-summary-list__row--no-actions::after {
    content: none;
  }
  /* Actions list inline-block + border separators mirror the mobile rules. */
  .govuk-summary-card__action,
  .govuk-summary-list__actions-list-item {
    margin-right: 10px;
    padding-right: 10px;
    border-right: 1px solid;
    border-right-color: var(--govuk-border-colour, #cecece);
    margin-left: 0;
    padding-left: 0;
  }
  .govuk-summary-card__action:last-child,
  .govuk-summary-list__actions-list-item:last-child {
    margin-right: 0;
    padding-right: 0;
    border: 0;
  }
  .govuk-summary-card__action:not(:first-child),
  .govuk-summary-list__actions-list-item:not(:first-child) {
    border-left: 0;
  }
}
```

**Wire-up in `R/summary.R`** (same pattern as `header-overrides.css` in `R/header.R:206`):

```r
summary_css <- htmltools::htmlDependency(
  name = "summary",
  version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
  src = c(href = "shinyGovstyle/css"),
  stylesheet = "summary-overrides.css"
)
htmltools::attachDependencies(attachDependency(tag), summary_css, append = TRUE)
```

---

## Change 2 — Full feature parity with the GOV.UK summary list spec

The current `gov_summary()` covers two of the eleven documented variants. The eleven (and current coverage):

| # | Variant | Current support |
|---|---------|------|
| 1 | Basic list with actions | partial (single "Change" action only) |
| 2 | List without actions | yes |
| 3 | Multiple actions per row | no |
| 4 | Mixed actions (some rows with, some without) | no — `--no-actions` class never emitted |
| 5 | No border on whole list | yes |
| 6 | No border on a single row | no |
| 7 | "Missing information" pattern (link inside value) | works via raw HTML, but not first-class |
| 8 | Summary card — title only | no |
| 9 | Summary card — title + card actions | no |
| 10 | HTML values | yes (`shiny::HTML`) |
| 11 | HTML keys | no |

Spec gaps that affect spec-correct rendering even without API changes:
- Action buttons have no `<span class="govuk-visually-hidden">` for screen reader context.
- Rows without actions are missing `govuk-summary-list__row--no-actions`, which the govuk CSS uses to inject an empty 20% pseudo-cell so the row borders align with rows that *do* have actions. This is independent of the breakpoint change — at desktop+ the table layout returns and the misalignment is visible.

### API design

Keep the existing vector API working (backwards-compatible) and add a richer list-of-rows API on the same function. Add a separate `gov_summary_card()` wrapper for the card variant.

```r
gov_summary(
  inputId,
  headers = NULL,         # legacy: character vector of keys
  info = NULL,            # legacy: character vector of values
  rows = NULL,            # NEW: list of row spec lists (richer API)
  action = FALSE,         # legacy: TRUE/FALSE; ignored when rows supplied
  border = TRUE
)
```

**Row spec** (each element of `rows`):

```r
list(
  key = "Name",              # required - character or htmltools tag for HTML keys
  value = "Sarah Philips",   # required - character (passed through HTML()) or tag
  actions = list(            # optional - list of action specs; NULL or empty = no actions
    list(
      id = "change_name",
      text = "Change",
      visually_hidden_text = "name"
    )
  ),
  no_border = FALSE          # optional - adds govuk-summary-list__row--no-border
)
```

Behaviour:
- When `rows` is `NULL`, fall back to the existing `headers` + `info` + `action` API. That codepath gets the two spec fixes baked in (visually hidden text + `--no-actions` class on rows with no action).
- When `rows` is supplied, `headers` / `info` / `action` are ignored.
- A row with no `actions` (or `actions = list()`) automatically gets `govuk-summary-list__row--no-actions`.
- A row with `no_border = TRUE` adds `govuk-summary-list__row--no-border`.
- `key` and `value` can be either a character string (treated as plain text, or as HTML for `value` to preserve current behaviour) or a `shiny.tag` / `htmltools` object (rendered as-is — covers variants 7, 10, 11).
- Each action renders as a `<button class="govuk-link action-button">` with an inner `<span class="govuk-visually-hidden"> visually_hidden_text</span>`. Multiple actions in one row are wrapped in `<ul class="govuk-summary-list__actions-list">` with `<li class="govuk-summary-list__actions-list-item">` items.

### Summary card wrapper

```r
gov_summary_card(
  ...,                  # passes through to gov_summary()
  title,                # character - card title text
  heading_level = 2L,   # integer 1-6 - controls <h2> vs <h3> etc
  actions = NULL        # optional - list of action specs, same shape as row actions
)
```

Renders:

```html
<div class="govuk-summary-card">
  <div class="govuk-summary-card__title-wrapper">
    <h{heading_level} class="govuk-summary-card__title">{title}</h{heading_level}>
    <!-- if actions: -->
    <ul class="govuk-summary-card__actions">
      <li class="govuk-summary-card__action">
        <button class="govuk-link action-button" id="...">
          {text}<span class="govuk-visually-hidden"> {visually_hidden_text}</span>
        </button>
      </li>
      ...
    </ul>
  </div>
  <div class="govuk-summary-card__content">
    <!-- gov_summary(...) output here -->
  </div>
</div>
```

Single-action cards use the single `govuk-summary-card__actions` rendering pattern (no `<ul>` wrapper when there's exactly one).

---

## Change 3 — Tests

Extend `tests/testthat/test-summary.R` with structural assertions and a small set of snapshot tests:

- Legacy vector API still renders the same row count and the action button when `action = TRUE`.
- Legacy `action = FALSE` rows include `govuk-summary-list__row--no-actions` (regression test for the spec gap).
- Each rendered action button contains a `<span class="govuk-visually-hidden">` with the key text.
- `rows` API: a row with `actions = NULL` gets `--no-actions`; a row with two actions emits a `<ul class="govuk-summary-list__actions-list">` with two `<li>` children.
- `rows` API: a row with `no_border = TRUE` gets `govuk-summary-list__row--no-border`.
- `rows` API: a tag passed as `key` is rendered without re-escaping (HTML key support).
- `gov_summary_card()` renders the card wrapper with the correct heading level; `actions = NULL` omits the `<ul>` entirely.
- The `summary-overrides.css` dependency is attached to the returned tag.

---

## Change 4 — Docs and examples

- Update roxygen for `gov_summary()` to document `rows` and the new row spec.
- Add roxygen for `gov_summary_card()`.
- Add an example in `inst/example_app/modules/mod_feedback_types.R` (after the existing call at line 80) showing the rich `rows` API plus a `gov_summary_card()` example.
- `NEWS.md`: one entry under the next version covering issue #89 plus the new features.

---

## Files touched

| File | Change |
|------|--------|
| `inst/www/css/summary-overrides.css` | **NEW** — breakpoint override CSS |
| `R/summary.R` | **EDIT** — refactor to support `rows`, add visually hidden text, emit `--no-actions` and `--no-border`, attach new CSS dep |
| `R/summary.R` (same file) or `R/summary_card.R` | **NEW** — `gov_summary_card()` |
| `man/gov_summary.Rd`, `man/gov_summary_card.Rd` | regenerated by `devtools::document()` |
| `NAMESPACE` | regenerated — exports `gov_summary_card` |
| `tests/testthat/test-summary.R` | **EDIT** — new test cases (legacy + rows + card) |
| `inst/example_app/modules/mod_feedback_types.R` | **EDIT** — show new variants |
| `NEWS.md` | **EDIT** — changelog entry |

---

## Implementation order

1. Add `inst/www/css/summary-overrides.css` with the breakpoint override.
2. Refactor `R/summary.R`:
   - Extract a `build_action()` helper that returns a single `<button>` with hidden text.
   - Extract a `build_actions_cell()` helper that wraps either a single action or a `<ul>` of actions.
   - Extract a `build_row()` helper that handles classes, key (text or tag), value (HTML or tag), actions.
   - Branch `gov_summary()` on `is.null(rows)` to call the helper from either the legacy vector pathway or the rows pathway.
   - Attach `summary-overrides.css` as a dependency on the return value.
3. Add `gov_summary_card()` (same file or new file).
4. Update tests.
5. Update example app and NEWS.
6. `devtools::document()` + `devtools::test()` + `devtools::check()`.

---

## Out of scope / follow-ups

- A breakpoint override for the action `<a>`-vs-`<button>` question: shinyGovstyle uses `<button class="action-button">` for Shiny reactivity. This is fine for the package's purpose and isn't being changed.
- Suggesting govuk-frontend itself improve mid-character word breaking — would be a separate upstream conversation, not actionable here.
