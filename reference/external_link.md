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

  Boolean for adding "(opens in new tab)" at the end of the link text to
  warn users of the behaviour. Be careful and consider accessibility
  before removing the visual warning

- footer:

  Apply standard GDS footer CSS styling. Logical, default = FALSE

## Value

shiny tag object

## Details

Intentionally basic wrapper for HTML anchor elements making it easier to
create safe external links with standard and accessible behaviour. For
more information on how the tag is generated, see
[`htmltools::tags()`](https://rstudio.github.io/htmltools/reference/builder.html).

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
shiny::tags$ul(
  shiny::tags$li(
    external_link(
      "https://shiny.posit.co/",
      "R Shiny documentation",
      add_warning = FALSE
    )
  ),
  shiny::tags$li(
    external_link(
      "https://www.python.org/",
      "Python documentation",
      add_warning = FALSE
    )
  ),
  shiny::tags$li(
    external_link(
      "https://nextjs.org/",
      "Next.js documentation",
      add_warning = FALSE
    )
  )
)
#> <ul>
#>   <li><a href="https://shiny.posit.co/" class="govuk-link" target="_blank" rel="noopener noreferrer">R Shiny documentation<span class="sr-only"> (opens in new tab)</span></a></li>
#>   <li><a href="https://www.python.org/" class="govuk-link" target="_blank" rel="noopener noreferrer">Python documentation<span class="sr-only"> (opens in new tab)</span></a></li>
#>   <li><a href="https://nextjs.org/" class="govuk-link" target="_blank" rel="noopener noreferrer">Next.js documentation<span class="sr-only"> (opens in new tab)</span></a></li>
#> </ul>
```
