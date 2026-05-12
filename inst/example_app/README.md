# shinyGovstyle example app

A Shiny app that showcases the components available in the `shinyGovstyle` package. The main branch version of this app is deployed at:
https://department-for-education.shinyapps.io/shinygovstyle-example-app/

## Code structure

```
inst/example_app/
├── global.R          # Loads libraries and sources all module files
├── ui.R              # Page layout: header, service navigation, tab container, footer
├── server.R          # Tab navigation observers and cookie banner event handlers
├── modules/
│   ├── mod_action_types.R    # Button and download components
│   ├── mod_cookies.R         # Cookie settings page
│   ├── mod_feedback_types.R  # Banners, warning text, error summaries
│   ├── mod_select_types.R    # Radio buttons, checkboxes, date inputs, selects
│   ├── mod_tables_tabs.R     # Tables, accordions, tabs
│   └── mod_text_types.R      # Text inputs, text areas, labels
└── tests/
    ├── testthat.R                        
    └── testthat/
        ├── setup-shinytest2.R            # shinytest2 setup file
        └── test-basic_load.R             # Checks the app title loads correctly
```

Each module follows the standard Shiny module pattern: a `mod_<name>_ui()` function for the UI and a `mod_<name>_server()` function for the server logic, both namespaced with the same `id`.

Navigation between tabs is driven by the `service_navigation` component and by next / back buttons within modules. The `server.R` contains observers that update the hidden `tabsetPanel` (`tab-container`) in response to both.

## Running the app locally

From the project root in R:

```r
shiny::runApp("inst/example_app")
```

## Running the tests

The example app has its own `shinytest2` tests, these are skipped on CRAN. To run the app's own internal test suite directly (from the project root)

```r
shinytest2::test_app("inst/example_app")
```
