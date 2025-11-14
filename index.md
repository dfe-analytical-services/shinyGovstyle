# shinyGovstyle

> Apply GOV.UK styled components and formats in shiny

## Overview

This package provides custom widgets to style R Shiny apps using the
GOV.UK design system. The components can be previewed in our [example
showcase
app](https://department-for-education.shinyapps.io/shinygovstyle-example-app/).  

![example app demonstration](reference/figures/example_app.gif)

example app demonstration

To view details and advice on how to use the GOV.UK components please
visit <https://design-system.service.gov.uk/components/>, most
components should be available to use through this package.

### Installation

You can install the latest stable version from CRAN

``` r
install.packages("shinyGovstyle")
```

If you want to make use of the development version then install directly
from GitHub.

``` r
pak::pak("dfe-analytical-services/shinyGovstyle")
```

This has previously also been available on conda though is no longer
actively maintained, if you are using the package in this way, please
let us know!

    conda install r-shinygovstyle

To use error and word count elements you will need to load
`useShinyjs()` from shinyjs in your ui.R file

``` r
shinyjs::useShinyjs()
```

### Contributing

Ideas, bug reports, and requests for new components should be [raised as
GitHub
issue](https://github.com/dfe-analytical-services/shinyGovstyle/issues/new).
It’s often worth checking the existing [issues
log](https://github.com/dfe-analytical-services/shinyGovstyle/issues)
incase there is already an existing discussion you can conrtibute to.

More details on contributing can be found in the
[CONTRIBUTING.md](https://dfe-analytical-services.github.io/shinyGovstyle/CONTRIBUTING.md)
file.

This package is also released with a [Contributor Code of
Conduct](https://dfe-analytical-services.github.io/shinyGovstyle/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

### Available components

Details of all available components and how to use them can be found in
the [package
documentation](https://dfe-analytical-services.github.io/shinyGovstyle/reference/index.html).

The package contains an [example showcase
app](https://department-for-education.shinyapps.io/shinygovstyle-example-app/)
you can view or run yourself, showcasing available components. The code
for the example app is in the `inst/example_app/` folder. You can easily
run the app from the console using:

``` r
shinyGovstyle::run_example()
```
