# Summary card

Wraps a
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md)
in a GOV.UK summary card with a titled header. Use summary cards when
you need to show multiple summary lists and need to tell them apart, for
example in a multi-section check-your-answers page.

## Usage

``` r
gov_summary_card(
  inputId,
  title,
  heading_level = 2L,
  headers,
  info,
  border = TRUE
)
```

## Arguments

- inputId:

  The Id for the inner summary list `<dl>` element.

- title:

  Character string. The card title text.

- heading_level:

  Integer (1-6). HTML heading level for the card title. Default `2L`.

- headers:

  See
  [`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md).

- info:

  See
  [`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md).

- border:

  See
  [`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md).

## Value

An HTML shiny tag object.

## See also

Other Govstyle feedback types:
[`confirmation_panel()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/confirmation_panel.md),
[`details()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/details.md),
[`gov_summary()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_summary.md),
[`gov_tag()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/gov_tag.md),
[`inset_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/inset_text.md),
[`label_hint()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/label_hint.md),
[`noti_banner()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/noti_banner.md),
[`value_box()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/value_box.md),
[`warning_text()`](https://dfe-analytical-services.github.io/shinyGovstyle/reference/warning_text.md)

## Examples

``` r
ui <- shinyGovstyle::gov_page(
  shinyGovstyle::header(
    org_name = "Example",
    service_name = "User Examples"
  ),
  shinyGovstyle::gov_main_layout(
    shinyGovstyle::gov_summary_card(
      inputId = "cardID",
      title = "Lead tenant",
      headers = c("Age", "Nationality"),
      info = c("38", "French")
    )
  ),
  shinyGovstyle::footer(full = TRUE)
)
if (interactive()) {
  shinyApp(ui = ui, server = function(input, output, session) {})
}
```
