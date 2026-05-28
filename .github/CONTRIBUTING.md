# Contributing to shinyGovstyle

Ideas for shinyGovstyle should first be raised as a [GitHub issue](https://github.com/dfe-analytical-services/shinyGovstyle/issues) after which anyone is free to write the code and create a pull request for review.

For support and information on package development in R, we recommend using the [R Packages (2e) guide by Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/), this contains a wealth of information and best practice for all kinds of activities around package development in R.

For a technical overview of the package, principles and common helpful commands, please refer to [AGENTS.md](../AGENTS.md).

## Formatting

We use [Air](https://posit-dev.github.io/air/) to format the code and save any styling debate across the repo and keep us as close as we can to the expected lintr standards with minimal effort. 

If you're working in VSCode or Positron, there is a settings.json file in the repo that includes format on save by default and should work for you without any additional work as long as you have the Air extension installed.

Air is still in development, so it's worth checking [their documentation](https://posit-dev.github.io/air/editors.html) if you're a new contributor and want to see the best ways to use it within your chosen IDE.

### Air suggestions on your PR

If you can't run Air locally (or miss something), don't worry, we have a GitHub Action that runs Air on every PR and uses **ReviewDog** to leave inline suggestions on anything that doesn't match our formatting.

These suggestions are purely about formatting and styling, so it's generally safe to accept them all as-is, you don't need to second-guess them.

If there are several suggestions, the easiest way to apply them is to go to the **Files changed** tab on your PR and add each suggestion to a batch, then commit them all together as one commit. This avoids triggering CI on every individual change.

### no lint

There are a number of places where the original function and argument names do not follow snake_case and therefore fail lintr's checks. To preserve backwards compatibility we've added `# nolint` to these lines so that we can turn on lintr checks for the package without creating breaking changes for everyone who uses it.

## Raising new changes

### Before you raise a PR

Run through these checks locally first — it makes review faster and avoids back-and-forth:

- **Format with Air.** If you can't run Air locally, the GitHub Action will offer the same suggestions on your PR (see [Air suggestions on your PR](#air-suggestions-on-your-pr)).
- **Lint** by running `devtools::load_all(); lintr::lint_package()` and resolving any new issues, loading the package before linting helps to avoid false positives.
- **Run all tests locally** with `devtools::test()` and then `devtools::check()`, in the latter, don't worry about notes, but pay attention to any errors or warnings.
- **Tests and documentation.** Add or update tests for any new behaviour, re-run `devtools::document()` so the `man/` pages stay in sync, and review the vignettes, README, and other doc files in the repo to see if any of them should also be updated.
- **Design system check.** If you've added or changed a UI component, compare it against the [GOV.UK Design System](https://design-system.service.gov.uk/) to make sure looks and behaves consistently with the GOVUK guidance.
- **Accessibility check.** For any UI component change, test it with assistive tech manually.
    - **Keyboard only.** Tab / Shift+Tab through the component, activate with Enter or Space, escape modals or menus with Esc. Focus should be visible at every stop.
    - **Screen reader.** [NVDA](https://www.nvaccess.org/download/) on Windows (free), or VoiceOver on macOS (⌘F5). Confirm labels, errors, and state changes are announced. `role="alert"` regressions and missing `for` / `id` associations only show up here.
    - **Forced colours / High Contrast.** Windows Settings, Accessibility, Contrast themes; or Chromium DevTools, Rendering, "Emulate CSS media feature forced-colors: active". Confirm all visual elements translate appropriately in the high contrast themes. As an example of potential issues, `box-shadow`, `background-color`, and `text-shadow` are dropped in forced-colours mode and need a `border` or `outline` based fallback inside an `@media (forced-colors: active)` block (see `inst/www/css/reactable-overrides.css` for a worked example).

    This isn't a full audit, just a smoke test. If you're touching `inst/www/css/govuk-frontend-x.x.x.min.css` directly, or adding a new component, do a fuller pass.
- **CSS changes.** If you've edited `inst/www/css/govuk-frontend-x.x.x.min.css`, log the change in `css_changes.md` (see the [CSS changes](#css-changes) section).

### Branching and raising a PR

New changes should be made on a branch off of the latest version of the main branch.

If you don't have access to push to the repo itself, you should start by creating a [fork of the repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository). You'll then be able to make a new branch in your own repo and push your suggested changes to that.

Once ready, you should raise [a PR in the main GitHub repository](https://github.com/dfe-analytical-services/shinyGovstyle/compare), pointing at the `main` branch and one of the package maintainers will be able to review your changes.

Once a pull request is reviewed and ready to be merged in, all commits in the PR should be squashed as a part of the merge to keep the Git history shorter and easier to navigate.

The `main` branch acts as the development version of the package for users, releases of stable package versions to CRAN will be made by the maintainers when they feel it is appropriate to do so.

### Code owners

We make use of [GitHub's CODEOWNERS file](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) to set default reviewers for the repo and for specific parts of the code.

## CSS changes

All changes made to the main `inst/www/css/govuk-frontend-x.x.x.min.css` file should be logged in the `css_changes.md` file, this way they can easily be reapplied whenever the CSS assests from GOV.UK are updated.

Alternatively, you can start a separate CSS file if your styling is separate to the GOV.UK styling.

## Updating to latest GOV.UK Frontend version

[Dependabot](https://docs.github.com/en/code-security/getting-started/dependabot-quickstart-guide) is set up to raise PRs when a new version of GOV.UK Frontend is released, these PRs are only a prompt, we still need to manually update the files and test everything works as expected.

Currently we take [static precompiled exports of the GOV.UK Frontend files](https://frontend.design-system.service.gov.uk/install-using-precompiled-files/), and then store them in the `inst/` directory. Usual steps involved:

1. Locate the latest (or desired) [GOV.UK Frontend version on GitHub](https://github.com/alphagov/govuk-frontend/releases)

2. Download and unzip the ZIP folder, copying the assets (including fonts and images) into the `inst/www/` folder

3. Update the CSS file name in `attachDependency.R` script

4. Apply any changes from `css_changes.md` manually, to preserve previous edits

5. Test all the code functions as expected using `devtools::check()`

6. Manually test the examples using `shinyGovstyle::run_example()`, ensuring the styling is as expected

7. Update the version of GOV.UK frontend in the `package.json` file to match the version you've just added

If unsure on the styling and expected appearance, use the [GOV.UK Design System site](https://design-system.service.gov.uk/) to explore the components in more detail and official guidance for their use.

## Code of Conduct

Please note that the shinyGovstyle project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project you agree to abide by its terms.
