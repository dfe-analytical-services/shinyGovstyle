---
name: update-govuk
description: Update shinyGovstyle's precompiled GOV.UK Frontend assets using the existing manual process, review release notes, repair upgrade regressions, test the showcase, and leave changes staged on a local branch without committing. Use when asked to perform a GOV.UK Frontend upgrade, not for an assessment alone.
---

# Update GOV.UK Frontend

Follow the existing asset-copying and manual CSS-editing process. Do not introduce
a Sass build, asset transformation pipeline, or styling refactor as part of this
skill. Do not commit, push, deploy, create a PR, or send messages outside this chat.

## Invocation and sources of truth

- Codex: `$update-govuk`, or select the skill in the skill picker. An optional
  version can follow the invocation, for example `$update-govuk 6.1.0`.
- Claude Code: ask it to read and follow `.agents/skills/update-govuk/SKILL.md`,
  optionally supplying a target version. Without `.claude/skills`, Claude Code does
  not auto-register `/update-govuk`.
- Other agents: read this file and follow the same procedure from the repository root.
- Read `AGENTS.md`, `.github/CONTRIBUTING.md` (both the upgrade section and the
  pre-PR checklist), and `css_changes.md` before starting. The staged-only boundary
  above takes precedence over the contributing guide's eventual PR instructions.
- Use [GOV.UK Frontend releases](https://github.com/alphagov/govuk-frontend/releases),
  [installation guidance](https://frontend.design-system.service.gov.uk/install-using-precompiled-files/)
  and the [Design System](https://design-system.service.gov.uk/) as upstream references.
- Read [the browser checklist](references/browser-checklist.md) before capturing
  the baseline, and use it again after the update.

## 1. Prepare and choose the release

1. Inspect the current branch, index, tracked and untracked changes, and any Git
   operation in progress. Never stash, reset, discard, overwrite or stage unrelated
   work. If existing work would interfere with branching, testing or exact staging,
   explain the conflict and ask the user how to proceed before modifying files.
2. Locate Git, R/Rscript, Air, the contributing guide's R tools, Pandoc and a
   Chromium browser with available automation tools. Discover executable locations
   rather than hard-coding a maintainer's paths. Report missing tools; never count
   an unavailable check as passed. Continue independent checks where possible.
3. Fetch `origin/main`; if it cannot be refreshed, report the blocker instead of
   silently using an old ref. Record its full commit SHA. Inspect version metadata
   and asset references at that commit, including `package.json`,
   `R/attachDependency.R` and `inst/www/`. Investigate any version disagreement.
4. Use the user's exact target version, or resolve the latest stable upstream
   release live. Exclude prereleases unless explicitly requested. If the installed
   version already matches, report that no upgrade is needed without creating a
   branch. Ask before treating an older target as a downgrade.
5. Create `update/govuk-<version>` from the refreshed `origin/main` in the current
   checkout, with `<version>` being the release number without a leading `v`.
   Use `git switch --no-track -c <branch> origin/main`. Never use `-C` or overwrite
   an existing branch; ask whether to resume an existing branch or use another name.
   After switching, reread the repository guidance and files from this base.

## 2. Review upstream and record the baseline

Read every intervening release note, including breaking changes, migrations,
accessibility changes and new components. Link each relevant change to affected
package components. Review new components for potential Shiny use, but recommend
them rather than adding new exports automatically.

Start a tracked report at `.github/govuk-updates/<version>.md`. Record the base SHA,
old and target versions, date, release links and downloaded release URL. Preserve
any existing report when resuming. Keep raw logs, screenshots and downloaded
archives in a task-specific temporary directory outside the repository and link
to them in the chat; keep the tracked report readable without those local files.

Before editing assets, run the existing unit and showcase tests and inspect the
unchanged local showcase and deployed baseline using the browser checklist.
Record baseline failures, browser states, viewport sizes and screenshot evidence.
The deployment may lag main or differ in dependencies: never assume it proves the
recorded base SHA is deployed. Record observable asset versions and any uncertainty.
If the baseline is unavailable, continue independent work and label attribution
of any differences uncertain.

## 3. Update using the existing manual process

1. Inspect `R/attachDependency.R`, `R/zzz.R`, `R/font.R`, `inst/www/`, the showcase
   and affected component markup/bindings. Distinguish upstream assets from
   package-owned files before copying anything.
2. Download and extract the official release ZIP into a temporary directory.
   Inventory its CSS, JavaScript, fonts and images against the current files.
   Copy the required upstream assets into the existing package layout. Preserve
   package bindings, override stylesheets and departmental images; never replace
   the whole `inst/www/` directory. Remove superseded upstream assets only after
   checking their ownership and references. Keep applicable licence notices.
3. Update the stylesheet reference in `R/attachDependency.R`, the pinned version
   in `package.json`, and any other verified versioned asset references. Search
   for obsolete references, including source maps and font/image URLs.
4. Manually reapply each applicable item in `css_changes.md`. For vague instructions
   such as URL changes or font extraction, inspect the existing implementation and
   compare it with the matching pristine old upstream release if needed. Preserve
   optional font loading. Assess whether upstream already fixes a workaround;
   document any retained, adapted or retired customisation and its evidence.
   Do not silently guess or omit an unresolved customisation.
5. Check which JavaScript is actually attached. The repository uses its own
   component bindings; copying an upstream bundle does not mean it is initialised.
   Do not add upstream `initAll()` as a routine upgrade step or double-initialise
   components. Check markup and custom bindings against changed upstream CSS.
6. Log every substantive edit with its reason and verification in the report.
   Keep `css_changes.md` accurate for all edits to the upstream stylesheet. Retain
   the current file organisation and exported R interfaces.

## 4. Test and repair

Follow the contributing checklist: Air formatting, `devtools::load_all()` before
`lintr::lint_package()`, `devtools::test()`, `devtools::document()` and
`devtools::check()`. Review documentation changes and all generated diffs. Keep
unrelated formatting or documentation churn out of the staged update without
discarding user work. Record errors, warnings, skips and environment failures.

Run `shinytest2::test_app("inst/example_app")` explicitly: the package-level suite
must not be assumed to run the nested showcase tests. Ensure child R processes
load the updated checkout, not an older installed package. If needed, install this
checkout into a temporary R library and pass that library to child processes;
do not overwrite the user's normal installed package. Verify the served asset
version and path after each restart.

Complete the browser checklist at desktop and mobile widths, then investigate
differences against the local baseline, deployment and relevant release notes.
Repair bounded upgrade-related compatibility problems and add focused regression
tests where useful, following the repository's stable tag-helper conventions.
Retest affected behaviour and rerun applicable package checks after repairs.
Do not change tests merely to accept broken behaviour.

Preserve intentional upstream improvements where compatible with the package's
accessibility guardrails. Ask before a public API break or substantial redesign.
Report unrelated existing defects without expanding the task to repair them.
When a repair cannot be completed safely, leave the evidence and unresolved issue
explicitly recorded rather than claiming a successful upgrade.

## 5. Stage and report

Finish the tracked report with:

- Versions, branch, base SHA, release/source links and baseline availability.
- A change log: file/component, change, reason, upstream expectation, verification.
- Test commands and results, with passed, failed, skipped and unavailable separate.
- Browser scenarios and comparison results, separating expected upstream changes,
  repaired regressions, pre-existing problems and uncertain differences.
- Unresolved failures, severity, reproduction steps and outstanding manual checks.
- New upstream components/features worth adopting, their usefulness to this package
  and likely integration effort; explicitly say when none were identified.

Review `git diff` and stage only explicit task-owned paths, including the report
and relevant tests/docs. Never use blanket `git add .` or `git add -A`. Check
`git diff --cached --check`, inspect `git diff --cached` and `git status --short`,
and verify HEAD still equals the recorded base commit. If concurrent edits make
ownership unclear, ask rather than staging them.

Leave the changes staged even if some checks remain failed or unavailable, but
label the result as needing attention rather than ready. Summarise the branch,
versions, changes and reasons, test results, behaviour changes, adoption suggestions,
remaining issues and report/evidence locations in the triggering chat. State that
nothing was committed or pushed. Stop only task-owned app/test processes and clean
up temporary browser state; retain useful evidence through the handoff.
