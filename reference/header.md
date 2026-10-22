# Generic header with an optional centred service title

A page-level header based on GOV.UK Frontend's Generic header. The
linked organisation identity uses the upstream structure. The separate
service title is a shinyGovstyle extension: centred on wide screens and
stacked below the organisation on smaller screens. Use one header per
page.

## Usage

``` r
header(
  org_name = "Shiny example app",
  service_name = NULL,
  logo = NULL,
  main_text = lifecycle::deprecated(),
  secondary_text = lifecycle::deprecated(),
  main_link = lifecycle::deprecated(),
  secondary_link = lifecycle::deprecated(),
  logo_alt_text = "Departmental logo",
  main_alt_text = lifecycle::deprecated(),
  secondary_alt_text = lifecycle::deprecated(),
  logo_width = 66,
  logo_height = 34,
  width = "standard",
  homepage_url = "/",
  classes = NULL,
  attributes = list()
)
```

## Arguments

- org_name:

  Organisation name. Use `NULL` for an image-only identity, with
  meaningful `logo_alt_text`.

- service_name:

  Optional service title, outside the homepage link.

- logo:

  URL or app-relative path to your own logo. Defaults to `NULL` (text
  only). The `"crown"` shortcut is no longer supported; use your own
  logo or `NULL` instead.

- main_text:

  **\[deprecated\]** Use `org_name` instead. Will be removed in
  shinyGovstyle 1.0.0.

- secondary_text:

  **\[deprecated\]** Use `service_name` instead. Will be removed in
  shinyGovstyle 1.0.0.

- main_link, secondary_link, main_alt_text, secondary_alt_text:

  **\[deprecated\]** Have no effect and will be removed in shinyGovstyle
  1.0.0. Use `homepage_url` for the organisation link.

- logo_alt_text:

  Alternative text for a custom logo. Use `""` when the adjacent
  organisation name already identifies it. An image-only identity
  requires meaningful alternative text to name the homepage link.

- logo_width, logo_height:

  Image dimensions, in pixels for numeric values or as CSS lengths.
  Applied to each image independently.

- width:

  Width of the component. One of `"standard"` (the default, GOV.UK's
  usual 960px content width), `"three-quarters"` (three-quarters of the
  viewport, never narrower than standard), `"full"` (no max-width, so
  the container fills the viewport, with grid gutters also removed), or
  a CSS length (e.g. `"1400px"`, `"90vw"`) for a custom max-width.

- homepage_url:

  Organisation homepage URL. Defaults to `/` (the domain root). For an
  app hosted at `https://example.org/my-app/`, use
  `homepage_url = "/my-app/"` to return to that app instead.

- classes:

  Additional CSS classes for the outer header.

- attributes:

  Named list of HTML attributes for the outer header, such as
  `list(id = "site-header")` or a named `data-brand` attribute. Use
  `classes` for CSS classes; the banner role cannot be overridden.

## Value

A header HTML Shiny tag object.

## Details

This replaces the previous branded-header markup for v1.0.0. Update CSS
selectors from `govuk-header*` to the Generic header classes or the
package-owned `shinygovstyle-header*` classes. The organisation now
links to `homepage_url`; `service_name` remains supported and is not a
link.

Generic header does not remove branding elsewhere in your app. Review
fonts, colours, favicons and footer imagery separately against the
[guidance on using Frontend without GOV.UK
branding](https://frontend.design-system.service.gov.uk/using-govuk-frontend-without-govuk-branding/).
The header uses a system sans-serif font rather than GDS Transport.

## See also

Other Govstyle page structure:
[`cookieBanner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/cookieBanner.md),
[`footer()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/footer.md),
[`gov_page()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_page.md),
[`layouts`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/layouts.md),
[`phase_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/phase_banner.md),
[`skip_to_main()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/skip_to_main.md)

## Examples

``` r
header("Example organisation")
#> <header class="govuk-generic-header shinygovstyle-header " role="banner">
#>   <div class="govuk-generic-header__container shinygovstyle-header__container  govuk-width-container">
#>     <div class="govuk-generic-header__logo">
#>       <a href="/" class="govuk-generic-header__homepage-link shinygovstyle-header__link">
#>         <span class="shinygovstyle-header__organisation">Example organisation</span>
#>       </a>
#>     </div>
#>   </div>
#> </header>
header("Example organisation", "My service", homepage_url = "/my-app/")
#> <header class="govuk-generic-header shinygovstyle-header " role="banner">
#>   <div class="govuk-generic-header__container shinygovstyle-header__container shinygovstyle-header__container--with-service govuk-width-container">
#>     <div class="govuk-generic-header__logo">
#>       <a href="/my-app/" class="govuk-generic-header__homepage-link shinygovstyle-header__link">
#>         <span class="shinygovstyle-header__organisation">Example organisation</span>
#>       </a>
#>     </div>
#>     <div class="shinygovstyle-header__service-name">My service</div>
#>   </div>
#> </header>
header(
  "Ministry of Justice", "My service",
  logo = "shinyGovstyle/images/moj_logo.png",
  logo_alt_text = "", homepage_url = "/my-app/"
)
#> <header class="govuk-generic-header shinygovstyle-header " role="banner">
#>   <div class="govuk-generic-header__container shinygovstyle-header__container shinygovstyle-header__container--with-service govuk-width-container">
#>     <div class="govuk-generic-header__logo">
#>       <a href="/my-app/" class="govuk-generic-header__homepage-link shinygovstyle-header__link">
#>         <img src="shinyGovstyle/images/moj_logo.png" class="shinygovstyle-header__image" alt="" style="width:66px;height:34px;"/>
#>          
#>         <span class="shinygovstyle-header__organisation">Ministry of Justice</span>
#>       </a>
#>     </div>
#>     <div class="shinygovstyle-header__service-name">My service</div>
#>   </div>
#> </header>
```
