# External link

It is commonplace for external links to open in a new tab, and when we
do this we should be careful...

This function automatically adds the following to your link:

- `target="_blank"` to open in new tab

- `rel="noopener noreferrer"` to prevent [reverse
  tabnabbing](https://owasp.org/www-community/attacks/Reverse_Tabnabbing)

By default this function also adds "(opens in new tab)" to your link
text to warn users of the behaviour.

This also adds "This link opens in a new tab" as a visually hidden span
element within the HTML outputted to warn non-visual users of the
behaviour.

The function will error if you end with a full stop, give a warning for
particularly short link text and will automatically trim any leading or
trailing white space inputted into link_text.

If you are displaying lots of links together and want to save space by
avoiding repeating (opens in new tab), then you can set add_warning =
FALSE and add a line of text above all of the links saying something
like 'The following links open in a new tab'.

Setting add_warning = FALSE removes the visible text warning entirely,
so sighted users lose the visual cue that the link behaves differently.
Set add_warning = "icon" instead to add a small decorative arrow icon
after the link text, giving sighted users a visual warning without
repeating the full "(opens in new tab)" text. The icon is purely
decorative (hidden from screen readers, which still get the same hidden
warning as add_warning = FALSE), so it should be paired with an
explanatory sentence above a group of links, not relied on as the only
warning.

Related links and guidance:

- [Government digital services guidelines on the use of
  links](https://design-system.service.gov.uk/styles/links/)

- [Anchor tag HTML element and its
  properties](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a)

- [WCAG 2.2 success criteria 2.4.4: Link Purpose (In
  Context)](https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context)

- [Web Accessibility standards link text
  behaviour](https://www.w3.org/TR/WCAG20-TECHS/G200.html)

## Usage

``` r
external_link(href, link_text, add_warning = TRUE, footer = FALSE)
```

## Arguments

- href:

  URL that you want the link to point to

- link_text:

  Text that will appear describing your link, must be descriptive of the
  page you are linking to. Vague text like 'click here' or 'here' will
  cause an error, as will ending in a full stop. Leading and trailing
  white space will be automatically trimmed. If the string is shorter
  than 7 characters a console warning will be thrown. There is no way to
  hush this other than providing more detail

- add_warning:

  One of TRUE (default), FALSE, or "icon", controlling how users are
  warned that the link opens in a new tab. TRUE appends "(opens in new
  tab)" to the visible link text. FALSE removes the visible text (a
  visually hidden span still warns screen reader users) with no
  replacement visual cue, for use with an explanatory sentence above a
  group of links. "icon" behaves like FALSE but also adds a small
  decorative arrow icon after the link text, giving sighted users a
  visual cue without repeating the full text. Be careful and consider
  accessibility before moving away from the default

- footer:

  Apply standard GDS footer CSS styling. Logical, default = FALSE

## Value

shiny tag object

## Details

Intentionally basic wrapper for HTML anchor elements making it easier to
create safe external links with standard and accessible behaviour. For
more information on how the tag is generated, see
[`htmltools::tags()`](https://rstudio.github.io/htmltools/reference/builder.html).

## See also

Other Govstyle actions:
[`download_button()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/download_button.md),
[`download_link()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/download_link.md),
[`download_radios()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/download_radios.md),
[`download_radios_handler()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/download_radios_handler.md)

## Examples

``` r
external_link("https://shiny.posit.co/", "R Shiny")
#> <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny (opens in new tab)</a>

external_link(
  "https://shiny.posit.co/",
  "R Shiny",
  add_warning = FALSE
)
#> <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny<span class="sr-only"> (opens in new tab)</span></a>

# Give sighted users a visual warning without repeating the text
external_link(
  "https://shiny.posit.co/",
  "R Shiny",
  add_warning = "icon"
)
#> <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny<span class="sr-only"> (opens in new tab)</span><svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" aria-hidden="true" focusable="false" style="margin-left: 4px; vertical-align: middle;">
#>   <path d="M5 1H1v10h10V7" stroke="currentColor" stroke-width="1.2" fill="none"></path>
#>   <path d="M6 1h5v5M11 1L5 7" stroke="currentColor" stroke-width="1.2" fill="none" stroke-linecap="round" stroke-linejoin="round"></path>
#> </svg></a>

# This will trim and show as 'R Shiny'
external_link("https://shiny.posit.co/", "  R Shiny")
#> <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny (opens in new tab)</a>

# Example of within text
shiny::tags$p(
  "Oi, ", external_link("https://shiny.posit.co/", "R Shiny"), " is great."
)
#> <p>
#>   Oi, <a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny (opens in new tab)</a> is great.
#> </p>

# Example of multiple links together
shiny::tags$h2("Related resources")
#> <h2>Related resources</h2>
shiny::tags$p("The following links open in a new tab.")
#> <p>The following links open in a new tab.</p>
gov_list(
  list = list(
    external_link(
      "https://shiny.posit.co/",
      "R Shiny documentation",
      add_warning = FALSE
    ),
    external_link(
      "https://www.python.org/",
      "Python documentation",
      add_warning = FALSE
    ),
    external_link(
      "https://nextjs.org/",
      "Next.js documentation",
      add_warning = FALSE
    )
  ),
  style = "bullet"
)
#> <ul class="govuk-list govuk-list--bullet">
#>   <li><a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny documentation<span class="sr-only"> (opens in new tab)</span></a></li>
#>   <li><a href="https://www.python.org/" class="govuk-link" target="_blank" rel="noopener noreferrer">Python documentation<span class="sr-only"> (opens in new tab)</span></a></li>
#>   <li><a href="https://nextjs.org/" class="govuk-link" target="_blank" rel="noopener noreferrer">Next.js documentation<span class="sr-only"> (opens in new tab)</span></a></li>
#> </ul>
```
