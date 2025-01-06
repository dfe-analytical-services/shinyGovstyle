# Contributing to shinyGovstyle

Ideas for shinyGovstyle should first be raised as a [GitHub issue](https://github.com/moj-analytical-services/shinyGovstyle/issues) after which anyone is free to write the code and create a pull request for review.

For support and information on package development in R, we recommend using the [R Packages (2e) guide by Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/), this contains a wealth of information and best practice for all kinds of activities around package development in R.

## Raising new changes

New changes should be made on a branch off of the latest version of the master branch.

If you don't have access to push to the repo itself, you should start by creating a [fork of the repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository). You'll then be able to make a new branch in your own repo and push your suggested changes to that.

Once ready, you should raise [a PR in the main GitHub repository](https://github.com/moj-analytical-services/shinyGovstyle/compare), pointing at the `master` branch and one of the package maintainers will be able to review your changes.

Once a pull request is reviewed and ready to be merged in, all commits in the PR should be squashed as a part of the merge to keep the Git history shorter and easier to navigate.

The `master` branch acts as the development version of the package for users, releases of stable package versions to CRAN will be made by the maintainers when they feel it is appropriate to do so.

### Code owners

We make use of [GitHub's CODEOWNERS file](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) to set default reviewers for the repo and for specific parts of the code.

## CSS changes

All changes made to the main `inst/www/css/govuk-frontend-norem.css` file should be logged in the `css_changes.md` file, this way they can easily be reapplied whenever the CSS assests from GOV.UK are updated.

Alternatively, you can start a separate CSS file if your styling is separate to the GOV.UK styling.

## Updating to latest GOV.UK Frontend version

Currently we take [static precompiled exports of the GOV.UK Frontend files](https://frontend.design-system.service.gov.uk/install-using-precompiled-files/), and then store them in the `inst/` directory. Usual steps involved:

1. Locate the latest (or desired) [GOV.UK Frontend version on GitHub](https://github.com/alphagov/govuk-frontend/releases)

2. Download and unzip the ZIP folder, copying the assets (including fonts and images) into the `inst/www/` folder

3. Update the CSS file name in `attachDependency.R` script

4. Apply any changes from `css_changes.md` manually, to preserve previous edits

5. Test all the code functions as expected using `devtools::check()`

6. Manually test the examples using `shinyGovstyle::run_example()`, ensuring the styling is as expected

If unsure on the styling and expected appearance, use the [GOV.UK Design System site](https://design-system.service.gov.uk/) to explore the components in more detail and official guidance for their use.

## Code of Conduct

Please note that the shinyGovstyle project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project you agree to abide by its terms.
