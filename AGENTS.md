# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Guiding principles

Two constraints sit above everything else and should drive judgement calls when the implementation could go more than one way:

- **Faithful wrapper around the [GOV.UK Design System](https://design-system.service.gov.uk/).** Components should look and behave the way GOV.UK documents them. When in doubt, the design-system page for that component is the spec — match its markup, classes, and interaction patterns rather than inventing variants.
- **Accessibility is a feature, not a polish step.** The package's value is making accessible Shiny apps easy. New or changed UI must meet the latest [WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) guidelines — keyboard operability, programmatic label/control associations, ARIA roles and states where appropriate, sufficient contrast, screen-reader-friendly structure. If a change would regress accessibility for the sake of API ergonomics or visual tweaks, flag it rather than ship it.
- **Where the package extends beyond GOV.UK, the extension is an opinionated guardrail.** Some components fill Shiny-specific gaps the design system doesn't cover — e.g. `govReactable()` for interactive data tables, `external_link()` for safe external links, `value_box()` for headline figures. These are not neutral wrappers: they bake in accessibility defaults (e.g. `external_link()` errors on vague link text and auto-adds "(opens in new tab)" plus an `sr-only` span; `govReactable()` forces `showSortIcon = FALSE` because the default icon is inaccessible; `value_box()` warns on deprecated colour names). When extending or adding a new component, follow that pattern — pick safe defaults, validate inputs that commonly cause accessibility failures, and document *why* a constraint is fixed rather than overridable.

## Before you raise a PR — read CONTRIBUTING.md first

The authoritative pre-PR checklist lives in [`.github/CONTRIBUTING.md`](.github/CONTRIBUTING.md). Follow its "Before you raise a PR" section verbatim — Air formatting, `lintr::lint_package()`, `devtools::test()`, `devtools::document()`, `devtools::check()`, comparing UI changes against the [GOV.UK Design System](https://design-system.service.gov.uk/), and logging any CSS edits in `css_changes.md`. The same file documents the branching/PR flow (branch off `main`, squash on merge) and the GOV.UK Frontend upgrade procedure.

## Common commands

In a terminal at the repo root:

- `air format .` — format all R files in place (requires the [Air](https://posit-dev.github.io/air/) CLI). The GitHub Action will suggest the same edits if you skip this locally.

In an R session at the repo root:

- `devtools::load_all(); lintr::lint_package()` — lint. `load_all()` first avoids false positives, per CONTRIBUTING.md.
- `devtools::test()` — run the full testthat suite.
- `devtools::test(filter = "banner")` — run a single file (`tests/testthat/test-banner.R`).
- `devtools::document()` — regenerate `man/` after any roxygen change.
- `devtools::check()` — full `R CMD check`; treat errors and warnings as blocking, notes are usually fine.
- `shinyGovstyle::run_example()` — launch the showcase app in `inst/example_app/` for manual verification of UI components.

## Architecture

This is a thin R wrapper around the precompiled GOV.UK Frontend bundle. The pieces fit together as follows:

- **Static assets live in `inst/www/`** — the CSS (`inst/www/css/govuk-frontend-x.x.x.min.css`), JS bindings (`inst/www/js/*.js`), fonts, and images are precompiled exports from [govuk-frontend](https://github.com/alphagov/govuk-frontend) releases. They are not built from source here.
- **`R/zzz.R`'s `.onLoad` registers `inst/www/` under the Shiny resource path `shinyGovstyle/`** at package load. This is why all htmlDependency `src` values reference `shinyGovstyle/css` and `shinyGovstyle/js`.
- **One component per file in `R/`** (e.g. `R/banner.R`, `R/date_Input.R`, `R/govReactable.R`). Each exported function builds an `htmltools` tag and calls `attachDependency()` from `R/attachDependency.R` to attach the shared CSS plus, for interactive widgets, the relevant JS binding. The `widget` argument switches between `radio`, `date`, `accordion`, `govTab`, `contents_link`, and `service_navigation` bindings — add a new branch there when introducing a new JS-backed widget.
- **`inst/example_app/`** plays two roles: it's the manual showcase launched by `run_example()` *and* the end-to-end test target. `inst/example_app/tests/testthat/test-basic_load.R` drives it via `shinytest2::AppDriver`, so the example app needs to stay runnable.
- **Upgrading GOV.UK Frontend** is a manual asset swap: drop the new precompiled files into `inst/www/`, update the CSS filename in `R/attachDependency.R`, reapply every edit catalogued in `css_changes.md`, and bump `package.json`. Full steps in CONTRIBUTING.md.
- **Tag trees vs htmlwidgets handle CSS dependencies differently; `attachDependency()` papers over the gap.** Most components in `R/` build `htmltools` tags (e.g. `header()`, `footer()`, `text_Input()`); for those, `attachDependency(tag)` writes the dep to `attr(tag, "html_dependencies")` and `htmltools::renderTags()` picks it up when the page renders. Htmlwidget wrappers (currently only `govReactable()`, but any future `reactable` / `DT` / `leaflet` style wrapper) return an `htmlwidget` object whose rendering path (`htmlwidgets:::toHTML.htmlwidget`, then `shinyRenderWidget`) only reads `widget$dependencies` and silently discards anything attached via `attr()`. The widget's CSS will then "work" only because some other component on the same page happens to load the same stylesheet, which is exactly the trap PR #166 (commit `baf9359`) found and struggled with. `attachDependency()` now branches on `inherits(tag, "htmlwidget")` and writes to `widget$dependencies` for widgets, so callers in `R/` always use the same one-liner regardless of return type. `govReactable()` is the canonical widget example and uses `widget = "reactable"` to pull in a separate override stylesheet (`inst/www/css/reactable-overrides.css`) alongside the main govuk CSS.

## Conventions worth knowing

- **Some exports use camelCase / PascalCase** (e.g. `checkbox_Input`, `cookieBanner`, `govReactable`) for backwards compatibility with existing user code. These lines carry a `# nolint` comment so `lintr::lint_package()` stays clean — grep for `# nolint` in `R/` to find them. Do not rename them without a deliberate breaking-change decision.
- **Any hand-edit to `inst/www/css/govuk-frontend-x.x.x.min.css` must be logged in `css_changes.md`** — that file is the single source of truth used to reapply local overrides whenever the upstream CSS is refreshed.
- **Formatting is enforced by [Air](https://posit-dev.github.io/air/)**, not by manual style choices. A GitHub Action runs Air on every PR and posts ReviewDog suggestions; accepting them in a single batched commit is the expected workflow.
