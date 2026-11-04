# GOV.UK upgrade browser checks

Use the available browser tools in the host agent; this checklist does not require
a particular plugin or a new browser-test framework. If the tools cannot perform
a check, record it as unavailable and explain the remaining manual action.

## Establish comparable runs

- Inspect `inst/example_app/ui.R`, `server.R` and `modules/` to enumerate current
  pages and controls; the examples below are a starting inventory, not a fixed limit.
- Before editing, launch the source checkout in a fresh R process from the repo
  root with `devtools::load_all(quiet = TRUE)` followed by
  `shiny::runApp("inst/example_app", host = "127.0.0.1", port = <free-port>, launch.browser = FALSE)`.
  This is the source-checkout equivalent of `shinyGovstyle::run_example()`. Replace
  the port placeholder with an available port and record the PID and URL. Background
  launchers on Windows should use hidden windows. Wait for Shiny to connect.
- Compare with the [deployed main showcase](https://department-for-education.shinyapps.io/shinygovstyle-example-app/).
  Use synthetic test values only. Uploads use small synthetic files; don't follow
  feedback links to submit issues or send anything outside the showcase.
- Use Chromium at 1280 x 900 and 390 x 844 CSS pixels, zoom 100%, with matching
  cookie, navigation and input state for each comparison. Record browser version.
  Keep desktop/mobile cookie state consistent by resetting or using fresh sessions.
- Capture the local pre-update baseline before assets are overwritten. Restart
  the app in a fresh R process and use a fresh browser session after updating;
  confirm stylesheet URLs and the served GOV.UK version to avoid stale-cache results.
- Capture equivalent page and interaction states before and after. Record relevant
  DOM/ARIA attributes and screenshots rather than relying only on pixel similarity.
  If attribution remains uncertain, reproduce against the recorded base in a
  temporary copy outside the repo; do not reset the working checkout.

## Exercise every page at both widths

Record each scenario as passed, failed, unavailable or not applicable, with a reason
for the latter two. Adapt control names to the current showcase. Check actual
effects and Shiny outputs where exposed, not just that a click can be issued.

| Area | Scenarios and observations |
| --- | --- |
| Page shell | All navigation destinations, active navigation state, page title changes, next-page buttons and footer links; skip link reaches main content; width modes, headers and mobile menu work without clipping or horizontal overflow. |
| Select types | Inline/stacked radios, checkboxes, select options, conditional content and file input; labels activate their controls, values update and validation is usable. Use synthetic upload content. |
| Text types | Text/number/date/text-area controls present on the page; valid, empty and invalid inputs, clear/re-enter values, limits and character/word counts; labels, hints and errors remain associated. |
| Action types | Buttons, links and downloads present on the page; activation, disabled states, focus and resulting UI changes. Check hover and active appearance as well as the resting state. |
| Tables, tabs, accordions | Sorting and other exposed table controls; tab selection and keyboard navigation; each accordion section and show/hide all; visible content matches selection/expanded state and ARIA attributes. |
| Feedback | Error summaries, banners, notifications, tags, value boxes and other displayed feedback; contrast, wrapping, visibility and focus destinations. |
| Cookies | Accept/reject controls, confirmation/dismissal and cookie-page links; navigate back and check the resulting state. Reset consent before comparing runs. |
| Custom styling | Inspect the elements affected by every applicable `css_changes.md` entry, including contents links, backlink, radio alignment, tab border, table captions, link focus and optional fonts. |

## Cross-cutting checks

- Tab and Shift+Tab through interactive controls. Check visible and unobscured
  focus, logical order, no traps, and Enter/Space/arrow/Escape behaviour where
  applicable to each component's semantics. Check focus after navigation/errors.
- Inspect accessible names, label/control associations, hint/error references,
  unique IDs, selected/expanded states and hidden content. Compare interactions
  with current GOV.UK guidance, not solely the deployed app's existing behaviour.
- Exercise two independent instances of tabs/accordions or other affected widgets
  when upstream changes could affect scoping. If the showcase lacks a necessary
  case, use a small temporary fixture outside the repo or a focused regression
  test. Also verify affected htmlwidgets render with their own dependencies.
- Inspect browser console errors and failed resource requests. Verify CSS,
  JavaScript, font and image URLs resolve, and custom bindings still work. Font
  loading should remain opt-in via `font()`; don't add it to the deployed showcase.
- Test forced-colours mode and 200% zoom/reflow where supported by browser tools.
  Check borders, focus indicators, text and usable controls; restore temporary
  browser settings afterwards. Record inaccessible tooling as a testing gap.
- Follow CONTRIBUTING's manual assistive-technology checks. NVDA/VoiceOver
  announcements need an actual screen-reader pass. Accessibility-tree inspection
  and ARIA assertions do not establish spoken output; clearly mark that pass as
  unperformed when it cannot be done and list the specific remaining scenarios.

## Record differences

For each difference, record the page/component, viewport and reproduction steps,
old and new results, upstream release-note link where relevant, severity, repair
and retest result. Classify it as expected upstream change, upgrade regression,
pre-existing issue, environment/deployment difference or uncertain attribution.
An expected upstream change still needs assessment against accessibility guardrails.

Include browser coverage gaps and baseline availability in the final chat response.
Never treat an unreachable deployment or an unperformed browser
scenario as a successful comparison.
