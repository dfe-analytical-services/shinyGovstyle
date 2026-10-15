---
name: update-govuk
description: Update shinyGovstyle's precompiled GOV.UK Frontend assets, reapply documented CSS changes, verify the showcase, and leave the upgrade staged locally. Use when asked to upgrade GOV.UK Frontend.
---

# Update GOV.UK Frontend

Use the existing precompiled asset process. Do not add a Sass build or refactor the styling as part of an upgrade. Leave the work staged on a local branch; do not commit, push, deploy, create a PR or contact anyone outside this chat.

Read `AGENTS.md`, the upgrade and pre-PR sections of `.github/CONTRIBUTING.md`, and `css_changes.md`. Use [GOV.UK Frontend releases](https://github.com/alphagov/govuk-frontend/releases) and the [Design System](https://design-system.service.gov.uk/) for upstream changes and expected behaviour. Read [the browser checklist](references/browser-checklist.md) before comparing the showcase.

## Prepare

1. Inspect the branch, index and working tree. Protect unrelated work; if it prevents safe branching or staging, resolve that with the user before changing files.
2. Refresh `origin/main` and record its SHA. Check the installed version in `package.json`, `R/attachDependency.R` and `inst/www/`. Use the user's target version, or get the latest stable release from GitHub's live `/repos/alphagov/govuk-frontend/releases/latest` endpoint. Check the tag, asset URL, `draft` and `prerelease` fields. Report an unavailable source rather than guessing. Stop if already current; ask before a downgrade.
3. Create `update/govuk-<version>` from `origin/main` without overwriting an existing branch. Reread repository guidance after switching. Read release notes from the installed version through the target, including patch releases, and note relevant user-visible and accessibility changes.
4. Record a local baseline: run the existing tests, inspect the showcase at desktop and mobile widths, and note any existing failures. The deployed showcase is useful context but may run a different revision. Keep release files, logs and screenshots in a task-specific temporary directory outside the repository.

## Update and check the assets

1. Download the official precompiled release ZIP. Compare its contents with `inst/www/`; copy only the required upstream CSS, JS, fonts and images. Preserve package-owned assets, bindings and applicable licence notices. Update versioned references in `R/attachDependency.R` and `package.json`. Then read the updated local `package.json` and use its `govuk-frontend` version to update the README badge URL and alt text; the badge version must match both `package.json` and the stylesheet referenced by `R/attachDependency.R`, and the documentation link stays unchanged. Remove superseded upstream files only after checking references. Remove dangling source-map comments if maps are not copied.
2. Pretty-print the copied CSS while keeping its `.min.css` name. Check that formatting did not change CSS values or selectors. Reapply **every** applicable change in `css_changes.md`, including font extraction and in-place edits. Put override rules in the documented block, preserving their media-query scope. For each override, check competing upstream declarations, specificity and interactive states; being later in the file alone does not guarantee the intended result. If upstream has changed a rule, decide whether to adapt or retire the customisation and update `css_changes.md` accordingly.
3. Review the asset diff against the pristine release: all differences should be accounted for by documented CSS edits or removed source-map comments, and copied binary assets should match. Check font and image URLs, optional font loading, obsolete version references, and the CSS/JS actually served by the showcase. The package has its own JS bindings; do not initialise the upstream bundle automatically or twice.

## Verify and hand off

Follow the relevant checks in CONTRIBUTING, including lint, tests, documentation and `devtools::check()`. Run `shinytest2::test_app("inst/example_app")` explicitly with `NOT_CRAN=true`; confirm tests ran and that child processes used this checkout rather than an older installed package. Use [the browser checklist](references/browser-checklist.md) after the update at desktop and mobile widths, comparing with the baseline. Repair upgrade regressions and rerun affected checks. Record failures, skips and unavailable checks accurately; do not change tests merely to accept broken behaviour.

Inspect the full diff. Stage only task-owned paths, then check `git diff --cached --check`, the staged diff, `git status --short` and the base SHA. If ownership is unclear, ask before staging. Leave the changes staged even when a check remains unresolved, and label that limitation clearly.

In the final response, give the versions and branch, the asset and CSS changes with their evidence, test and browser results, and unresolved issues. Include two short sections: **Changes to be aware of** for relevant release-note changes and possible package follow-ups, and **Didn't copy across smoothly** for changed selectors, moved assets, repairs or other deviations. Say when there were no deviations. State that nothing was committed or pushed.
