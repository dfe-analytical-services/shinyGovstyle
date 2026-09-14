---
editor_options: 
  markdown: 
    wrap: 72
---

# shinyGovstyle (development version)

## Breaking changes

* Error message element ids changed from `<inputId>error` to `<inputId>-error`
  (matching the hint id format `<inputId>-hint`). This affects
  `radio_button_Input()`, `checkbox_Input()`, `date_Input()`, `text_Input()`,
  `text_area_Input()`, `file_Input()`, and `input_field()`. `error_on()` and
  `error_off()` have been updated to match and continue to work transparently;
  only custom CSS or JS that targets `#fooerror` selectors needs updating to
  `#foo-error`.
* `insert_text()` argument `text` has been renamed to `content` to reflect
  that it now accepts more than plain text. The old name is deprecated and
  will be removed in a future version.
* `word_count()` has been deprecated as it is no longer required for
  `text_area_Input()`, which now tracks and announces the word count
  entirely client-side.

## New features

* `external_link()`'s `add_warning` argument now also accepts `"icon"`, in
  addition to `TRUE`/`FALSE`. Setting `add_warning = "icon"` adds a small
  decorative arrow icon after the link text, giving sighted users a visual
  warning that the link opens in a new tab without repeating the "(opens in
  new tab)" text — useful for grouped links (see the "Grouped links" section
  of the "Headings and text" vignette). The icon is hidden from screen
  readers, which get the same hidden warning as `add_warning = FALSE`.
* New `update_page_title()` function to update the browser tab title from
  server code, mirroring `update_service_navigation()`. Compose a title
  in the GOV.UK recommended format `"<page> | <service>"` by supplying
  both `page_title` and `service_name`.
* `service_navigation()` gains `auto_page_title` and `page_title_suffix`
  arguments. With `auto_page_title = TRUE` (the default) the browser tab
  title is kept in sync with the active nav link, both for direct clicks
  and for programmatic navigation via `update_service_navigation()`.
* New `service_navigation_server()` wires every nav link to its tab
  panel in a single server-side call, eliminating the per-link
  `observeEvent()` boilerplate that multi-page apps previously needed.
* New `navigate_to()` combines `updateTabsetPanel()` and
  `update_service_navigation()` into one call for programmatic
  navigation (next / back buttons, footer shortcuts, modal links).
  Accepts a `panel` argument when the nav link inputId and the tab
  panel value differ.
* New `update_radio_button_Input()` function, the server-side companion to
  `radio_button_Input()` (mirroring `shiny::updateRadioButtons()`). Use it to
  change the selected option, choices, or label of a radio group from the
  server, for example to keep a cookies settings radio in sync with a cookie
  banner choice. See the new "Cookies and analytics" vignette.
* `insert_text()` (`content`), `panel_output()` (`sub_text`), `noti_banner()`
  (`body_txt`), `details()` (`help_text`), `banner()` (`label`),
  `warning_text()` (`text`), and `gov_summary()` (`info`) now accept `shiny`
  tag objects (e.g. `shiny::tags$b("Bold")`) and `shiny::tagList()` values in
  addition to plain character strings.
* `gov_list()` (`list`) and `accordion()` (`descriptions`) now accept `shiny`
  tag objects and `shiny::tagList()` values, so list items and accordion
  sections can contain links and other rich content. `accordion()` section
  content is no longer forced into a single paragraph, so it can hold block
  content such as lists or multiple paragraphs (plain-string sections are
  unchanged).
* The `label` and `hint_label` / `hint_input` arguments of `label_hint()`,
  `text_Input()`, `text_area_Input()`, `date_Input()`, `select_Input()`,
  `checkbox_Input()`, and `radio_button_Input()` now consistently accept plain
  strings, HTML strings, `shiny` tag objects, and `shiny::tagList()` values.
  Previously labels accepted HTML strings but not tags, while hints accepted
  tags but not HTML strings.
* `banner()` gains a `feedback_url` argument that auto-generates the standard
  GOV.UK phase banner feedback text (e.g. "This is a new service - your
  feedback (opens in new tab) will help us to improve it."), or contact-style
  text if `feedback_url` is a `mailto:` link. `label` is now optional, but
  exactly one of `label` or `feedback_url` must be supplied.
* `external_link()` now natively supports `mailto:` links: when `href` starts
  with `mailto:`, the "opens in new tab" attributes, text, and icon are all
  skipped, since a mailto link hands off to the mail client rather than
  opening a new tab. Existing link-text validations still apply.

## Bug fixes

* `service_navigation()` now syncs the browser tab title with the active
  page by default. Screen readers announce the title on navigation,
  so a static title is an accessibility issue for multi-page dashboards.
  This is a behaviour change — set `auto_page_title = FALSE` on
  `service_navigation()` to restore the previous behaviour.
* `header()` no longer emits spurious deprecation warnings for `main_link`,
  `secondary_link`, `main_alt_text`, and `secondary_alt_text` when those
  arguments are not used.
* Error messages on input components now use `role="alert"` so they are
  announced by screen readers when toggled via `error_on()`.
* The visually hidden "Error:" prefix on input component error messages now
  comes before the message text, so screen readers announce "Error: Enter your
  name" rather than "Enter your name Error:". The prefix also survives
  `error_on(error_message = ...)`, which previously replaced it.
* `error_on()` now escapes a plain string `error_message` instead of sending it
  to the browser as raw HTML, so it renders the same way as the message baked
  into the component (`<` and `&` are no longer swallowed, and interpolated
  user content can no longer inject markup). Pass a `shiny` tag,
  `shiny::tagList()`, or `shiny::HTML()` to render markup deliberately.
* `date_Input()` now renders its hint before the error message, matching the
  GOV.UK Design System and the other input components.
* `govReactable()` table row, sort-header, and pagination highlights are now
  visible in Windows High Contrast / forced-colours mode.
* `details()` now applies the same HTML handling to `help_text` as it does to
  `label`, so HTML strings render consistently across both arguments.
* `warning_text()` now renders HTML strings in `text` consistently with other
  body-content components.
* `govTable()` no longer errors with "evaluation nested too deeply: infinite
  recursion" on large tables (around 1200+ rows). It now warns when given more
  than 50 rows and recommends `govReactable()` for very large or interactive
  tables.
* The `radio_button_Input()` client binding now correctly replaces all options
  when sent an `options` update (the previous selectors did not match the
  rendered markup, so option replacement silently did nothing).
* `radio_button_Input()`'s client binding now correctly reads and updates the
  group label (`update_radio_button_Input(label = ...)`, and Shiny's
  built-in bookmarking) — the previous selector targeted the old
  `<label for=...>` markup, which no longer exists now that the label
  renders inside a `<legend>` via the shared fieldset helper.
* `govTable()` now renders rows in dataframe order (row order was previously
  silently reversed).
* `text_area_Input()`'s word-limit message is now a live region
  (`aria-live="polite"`), announced to screen readers a short pause after the
  user stops typing, matching the GOV.UK Design System character count
  component. Previously it updated visually on every keystroke but was never
  announced.

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
  attributes. `date_Input()` Day/Month/Year labels are likewise associated
  with their underlying inputs via `for`/`id`.
* `govTabs` now includes full ARIA roles (`tablist`, `tab`, `tabpanel`) and
  attributes (`aria-selected`, `aria-controls`, `aria-labelledby`) so screen
  readers correctly identify and navigate tabs.

# shinyGovstyle 0.2.0

## Breaking changes

-   `header()` arguments `main_text` and `secondary_text` have been
    renamed to `org_name` and `service_name` respectively. The old names
    are deprecated and will be removed in a future version.
-   `value_box()` has had the redundant `inputId` argument removed.

## New features

-   New `download_link()`, `download_button()`, and `download_radios()`
    functions for download components.
-   New `external_link()` function for creating safe, accessible
    external links that open in a new tab.
-   New `gov_list()` function to render styled ordered and unordered
    lists.
-   New `service_navigation()` function with
    `update_service_navigation()` and `service_nav_link()` helpers for
    the GOV.UK service navigation component.
-   New `skip_to_main()` function to add a skip-to-main-content
    accessibility link.

## Minor improvements and bug fixes

-   Accordion sections now toggle by clicking anywhere in the section
    header, not just the title text.
-   File upload input now uses GDS-like styling.
-   `footer()` now supports links.
-   `gov_table()` now supports reactive tables, sorting, and pagination.
-   `gov_table()` no longer crashes when `width_overwrite = NULL`.
-   `header()` alt text validation softened from errors to warnings.
-   `header()` has been fixed to correctly size and align on small
    screens, and `service_name` now wraps correctly on narrow viewports.
-   Many functions now cross-reference related functions in their help
    files.
-   Table caption placement fixed.
-   Updated govuk-frontend CSS from v5.4.0 to v6.1.0.
-   `value_box()` updated to use GOV.UK tag colours.

# shinyGovstyle 0.1.1

-   No user facing changes, moving to using snapshot testing for
    backlink_Input

# shinyGovstyle 0.1.0

-   Update the css to v5.4.0 and made fixes associated with that.
-   No longer requires rem remover step to update for future changes.
-   One of the major changes in the css is a change in look and
    functionality for the accordion. Show / hide all works as expected
    now.
-   Another major change to how the radio buttons look and feel, in line
    with the v5.4.0 design examples.
-   Added additional functions to the `run_example` for ease of testing.
-   Added the contents_links() function as a helper for getting the
    styling and behaviour for left navigation.

# shinyGovstyle 0.0.8

-   Update the css to v4.0.0 and made fixes associated with that.
-   One of the major changes in the css is a change in look for the
    accordion.
-   Added new functions `gov_main_layout`, `gov_row`, `gov_box` and
    `gov_text` to give better control over the layouts.
-   Added tabs as a component using the `govTab` command.
-   Added summary list as a component using the `gov_summary` command.
-   Added error summary component (`error_summary`) and error summary
    update (`error_summary_update`).

# shinyGovstyle 0.0.7

-   Improved the header so that you can adjust the logo size to suit.
-   Fix some errors that appeared in the footer.
-   Fix the word count function so that you only need to enter word
    count limit on the `text_area` function. You can change the limit on
    `word_count` if needed.
-   Change the `run_example` to a better versions that show more ways
    you can you the package.
-   Change the `backlink_Input` to a button so that you can use server
    to move between panels etc.
-   Added tags through the `tag_Input` function plus added to the
    `use_example`.
-   Added cookie banner through the `cookieBanner` function.
-   Added accordion through the `accordion` function.
-   Added tables through the `govTable` function.

# shinyGovstyle 0.0.6

-   Fix minor bugs from the issues list including data default and radio
    default.
-   Added units test.
-   Added an example function.
-   Added a `NEWS.md` file to track changes to the package.
-   Added a notification banner function.
-   Got ready for CRAN release.
-   Added output value to the documentation.
