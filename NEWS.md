# shinyGovstyle (development version)

## Breaking changes

* Error message element ids changed from `<inputId>error` to `<inputId>-error`
  (matching the hint id format `<inputId>-hint`). This affects
  `radio_button_Input()`, `checkbox_Input()`, `date_Input()`, `text_Input()`,
  `text_area_Input()`, `file_Input()`, and `input_field()`. `error_on()` and
  `error_off()` have been updated to match and continue to work transparently;
  only custom CSS or JS that targets `#fooerror` selectors needs updating to
  `#foo-error`.

## Bug fixes

* `header()` no longer emits spurious deprecation warnings for `main_link`,
  `secondary_link`, `main_alt_text`, and `secondary_alt_text` when those
  arguments are not used.
* Error messages on input components now use `role="alert"` so they are
  announced by screen readers when toggled via `error_on()`.

## Minor improvements and bug fixes

* `radio_button_Input()`, `checkbox_Input()`, and `date_Input()` now wrap their
  contents in a `<fieldset>` with a `<legend>` (previously they used a
  `<label>` inside the fieldset, which is invalid and meant screen readers did
  not announce the question as group context). Any hint or error message is
  linked to the fieldset via `aria-describedby`, so screen readers read the
  hint/error when the group receives focus. `radio_button_Input()`,
  `checkbox_Input()`, and `date_Input()` gain `label_size`
  (`"s"`/`"m"`/`"l"`/`"xl"`, default `"m"`) and `heading_level` (1-6, optional)
  arguments that control the legend size and optionally wrap it as a page
  heading following the GDS pattern.
* `radio_button_Input()` inputs and labels are now programmatically associated
  via matching `id`/`for` attributes, and checkbox labels now also carry `for`
  attributes.
* `govTabs` now includes full ARIA roles (`tablist`, `tab`, `tabpanel`) and
  attributes (`aria-selected`, `aria-controls`, `aria-labelledby`) so screen
  readers correctly identify and navigate tabs.

# shinyGovstyle 0.2.0

## Breaking changes

* `header()` arguments `main_text` and `secondary_text` have been renamed to
  `org_name` and `service_name` respectively. The old names are deprecated and
  will be removed in a future version.
* `value_box()` has had the redundant `inputId` argument removed.

## New features

* New `download_link()`, `download_button()`, and `download_radios()` functions
  for download components.
* New `external_link()` function for creating safe, accessible external links
  that open in a new tab.
* New `gov_list()` function to render styled ordered and unordered lists.
* New `service_navigation()` function with `update_service_navigation()` and
  `service_nav_link()` helpers for the GOV.UK service navigation component.
* New `skip_to_main()` function to add a skip-to-main-content accessibility
  link.

## Minor improvements and bug fixes

* Accordion sections now toggle by clicking anywhere in the section header, not
  just the title text.
* File upload input now uses GDS-like styling.
* `footer()` now supports links.
* `gov_table()` now supports reactive tables, sorting, and pagination.
* `gov_table()` no longer crashes when `width_overwrite = NULL`.
* `header()` alt text validation softened from errors to warnings.
* `header()` has been fixed to correctly size and align on small screens, and
  `service_name` now wraps correctly on narrow viewports.
* Many functions now cross-reference related functions in their help files.
* Table caption placement fixed.
* Updated govuk-frontend CSS from v5.4.0 to v6.1.0.
* `value_box()` updated to use GOV.UK tag colours.

# shinyGovstyle 0.1.1

* No user facing changes, moving to using snapshot testing for backlink_Input

# shinyGovstyle 0.1.0

* Update the css to v5.4.0 and made fixes associated with that.
* No longer requires rem remover step to update for future changes.
* One of the major changes in the css is a change in look and functionality for the accordion. Show / hide all works as expected now.
* Another major change to how the radio buttons look and feel, in line with the v5.4.0 design examples.
* Added additional functions to the `run_example` for ease of testing.
* Added the contents_links() function as a helper for getting the styling and behaviour for left navigation.


# shinyGovstyle 0.0.8

* Update the css to v4.0.0 and made fixes associated with that.
* One of the major changes in the css is a change in look for the accordion.
* Added new functions `gov_main_layout`, `gov_row`, `gov_box` and `gov_text` to 
give better control over the layouts.
* Added tabs as a component using the `govTab` command.
* Added summary list as a component using the `gov_summary` command.
* Added error summary component (`error_summary`) and error summary 
update (`error_summary_update`).


# shinyGovstyle 0.0.7

* Improved the header so that you can adjust the logo size to suit.
* Fix some errors that appeared in the footer.
* Fix the word count function so that you only need to enter word count limit 
  on the `text_area` function.  You can change the limit on `word_count` if 
  needed.
* Change the `run_example` to a better versions that show more ways you can you
  the package.
* Change the `backlink_Input` to a button so that you can use server to move
  between panels etc.
* Added tags through the `tag_Input` function plus added to the `use_example`.
* Added cookie banner through the `cookieBanner` function.
* Added accordion through the `accordion` function.
* Added tables through the `govTable` function.

# shinyGovstyle 0.0.6

* Fix minor bugs from the issues list including data default and radio default.
* Added units test.
* Added an example function.
* Added a `NEWS.md` file to track changes to the package.
* Added a notification banner function.
* Got ready for CRAN release.
* Added output value to the documentation.
