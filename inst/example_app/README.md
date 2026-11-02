# shinyGovstyle example app

A Shiny app that showcases the components available in the `shinyGovstyle` package.
Two versions are hosted on Posit Connect:

| Version | Address to fill in |
| --- | --- |
| CRAN release | TODO_CONNECT_CRAN_URL |
| Development (main) | TODO_CONNECT_DEV_URL |

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
```

Each module follows the standard Shiny module pattern: a `mod_<name>_ui()` function for the UI and a `mod_<name>_server()` function for the server logic, both namespaced with the same `id`.

Navigation between tabs is driven by the `service_navigation` component and by next / back buttons within modules. The `server.R` contains observers that update the hidden `tabsetPanel` (`tab-container`) in response to both.

## Running the app locally

From the project root in R:

```r
shiny::runApp("inst/example_app")
```

The **Showcase loads** GitHub workflow uses shinytest2 to check the app starts
on each pull request and push to main. Check UI changes manually.
