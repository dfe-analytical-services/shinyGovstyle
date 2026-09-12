#' External link
#'
#' Intentionally basic wrapper for HTML anchor elements making it easier to
#' create safe external links with standard and accessible behaviour. For more
#' information on how the tag is generated, see [htmltools::tags()].
#'
#' @description
#' It is commonplace for external links to open in a new tab, and when we do
#' this we should be careful...
#'
#' This function automatically adds the following to your link:
#' * `target="_blank"` to open in new tab
#' * `rel="noopener noreferrer"` to prevent [reverse tabnabbing](
#' https://owasp.org/www-community/attacks/Reverse_Tabnabbing)
#'
#' By default this function also adds "(opens in new tab)" to your link text
#' to warn users of the behaviour.
#'
#' This also adds "This link opens in a new tab" as a visually hidden span
#' element within the HTML outputted to warn non-visual users of the behaviour.
#'
#' The function will error if you end with a full stop, give a warning for
#' particularly short link text and will automatically trim any leading or
#' trailing white space inputted into link_text.
#'
#' If you are displaying lots of links together and want to save space by
#' avoiding repeating (opens in new tab), then you can set add_warning = FALSE
#' and add a line of text above all of the links saying something like 'The
#' following links open in a new tab'.
#'
#' Setting add_warning = FALSE removes the visible text warning entirely, so
#' sighted users lose the visual cue that the link behaves differently. Set
#' add_warning = "icon" instead to add a small decorative arrow icon after the
#' link text, giving sighted users a visual warning without repeating the full
#' "(opens in new tab)" text. The icon is purely decorative (hidden from
#' screen readers, which still get the same hidden warning as add_warning =
#' FALSE), so it should be paired with an explanatory sentence above a group
#' of links, not relied on as the only warning.
#'
#' Related links and guidance:
#'
#' * [Government digital services guidelines on the use of links](
#' https://design-system.service.gov.uk/styles/links/)
#'
#' * [Anchor tag HTML element and its properties](
#' https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a)
#'
#' * [WCAG 2.2 success criteria 2.4.4: Link Purpose (In Context)](
#' https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context)
#'
#' * [Web Accessibility standards link text behaviour](
#' https://www.w3.org/TR/WCAG20-TECHS/G200.html)
#'
#' @param href URL that you want the link to point to
#' @param link_text Text that will appear describing your link, must be
#' descriptive of the page you are linking to. Vague text like 'click here' or
#' 'here' will cause an error, as will ending in a full stop. Leading and
#' trailing white space will be automatically trimmed. If the string is shorter
#' than 7 characters a console warning will be thrown. There is no way to hush
#' this other than providing more detail
#' @param add_warning One of TRUE (default), FALSE, or "icon", controlling how
#' users are warned that the link opens in a new tab. TRUE appends "(opens in
#' new tab)" to the visible link text. FALSE removes the visible text (a
#' visually hidden span still warns screen reader users) with no replacement
#' visual cue, for use with an explanatory sentence above a group of links.
#' "icon" behaves like FALSE but also adds a small decorative arrow icon
#' after the link text, giving sighted users a visual cue without repeating
#' the full text. Be careful and consider accessibility before moving away
#' from the default
#' @param footer Apply standard GDS footer CSS styling. Logical,
#' default = FALSE
#' @return shiny tag object
#' @family Govstyle actions
#' @export
#'
#' @examples
#' external_link("https://shiny.posit.co/", "R Shiny")
#'
#' external_link(
#'   "https://shiny.posit.co/",
#'   "R Shiny",
#'   add_warning = FALSE
#' )
#'
#' # Give sighted users a visual warning without repeating the text
#' external_link(
#'   "https://shiny.posit.co/",
#'   "R Shiny",
#'   add_warning = "icon"
#' )
#'
#' # This will trim and show as 'R Shiny'
#' external_link("https://shiny.posit.co/", "  R Shiny")
#'
#' # Example of within text
#' shiny::tags$p(
#'   "Oi, ", external_link("https://shiny.posit.co/", "R Shiny"), " is great."
#' )
#'
#' # Example of multiple links together
#' shiny::tags$h2("Related resources")
#' shiny::tags$p("The following links open in a new tab.")
#' gov_list(
#'   list = list(
#'     external_link(
#'       "https://shiny.posit.co/",
#'       "R Shiny documentation",
#'       add_warning = FALSE
#'     ),
#'     external_link(
#'       "https://www.python.org/",
#'       "Python documentation",
#'       add_warning = FALSE
#'     ),
#'     external_link(
#'       "https://nextjs.org/",
#'       "Next.js documentation",
#'       add_warning = FALSE
#'     )
#'   ),
#'   style = "bullet"
#' )
external_link <- function(
  href,
  link_text,
  add_warning = TRUE,
  footer = FALSE
) {
  valid_add_warning <- isTRUE(add_warning) ||
    isFALSE(add_warning) ||
    identical(add_warning, "icon")
  if (!valid_add_warning) {
    stop('add_warning must be TRUE, FALSE, or "icon"')
  }

  # Trim white space as I don't trust humans not to accidentally include
  link_text <- stringr::str_trim(link_text)

  # Create a basic check for raw URLs
  is_url <- function(text) {
    url_pattern <- "^(https://|http://|www\\.)"
    grepl(url_pattern, text)
  }

  # Check for vague link text on our list
  if (is_url(link_text)) {
    stop(paste0(
      link_text,
      " has been recognised as a raw URL, please change the link_text value",
      "to a description of the page being linked to instead"
    ))
  }

  # Check against curated data set for link text we should banish into room 101
  if (tolower(link_text) %in% shinyGovstyle::bad_link_text$bad_link_text) {
    stop(
      paste0(
        link_text,
        " is not descriptive enough and has has been recognised as bad link",
        " text, please replace the link_text argument with more descriptive",
        " text."
      )
    )
  }

  # Check if link text ends in a full stop
  if (grepl("\\.$", link_text)) {
    stop("link_text should not end with a full stop")
  }

  # Give a console warning if link text is under 7 characters
  # Arbritary number that allows for R Shiny to be link text without a warning
  if (nchar(link_text) < 7) {
    warning(paste0(
      "the link_text: ",
      link_text,
      ", is shorter than 7 characters, this is",
      " unlikely to be descriptive for users, consider having more detailed",
      " link text"
    ))
  }

  # Assuming all else has passed, make the link text a nice accessible link
  if (isTRUE(add_warning)) {
    link_text <- paste(link_text, "(opens in new tab)")
    hidden_span <- NULL # don't have extra hidden text if clear in main text
  } else {
    # FALSE and "icon" both rely on the hidden span to warn screen readers
    hidden_span <-
      htmltools::span(class = "sr-only", " (opens in new tab)")
  }

  # Purely decorative arrow icon, hidden from screen readers, giving sighted
  # users a visual cue in place of the (opens in new tab) text
  if (identical(add_warning, "icon")) {
    icon_svg <- shiny::tag(
      "svg",
      list(
        xmlns = "http://www.w3.org/2000/svg",
        width = "12",
        height = "12",
        viewBox = "0 0 12 12",
        `aria-hidden` = "true",
        focusable = "false",
        style = "margin-left: 4px; vertical-align: middle;",
        shiny::tag(
          "path",
          list(
            d = "M5 1H1v10h10V7",
            stroke = "currentColor",
            `stroke-width` = "1.2",
            fill = "none"
          )
        ),
        shiny::tag(
          "path",
          list(
            d = "M6 1h5v5M11 1L5 7",
            stroke = "currentColor",
            `stroke-width` = "1.2",
            fill = "none",
            `stroke-linecap` = "round",
            `stroke-linejoin` = "round"
          )
        )
      )
    )
  } else {
    icon_svg <- NULL
  }

  if (!is.logical(footer)) {
    stop(
      "The footer parameter should logical TRUE/FALSE. Received:\n",
      class(footer),
      ": ",
      footer
    )
  }

  if (footer) {
    link_gds_class <- "govuk-link govuk-footer__link"
  } else {
    link_gds_class <- "govuk-link"
  }

  # Create the link object
  link <- htmltools::tags$a(
    href = href,
    class = link_gds_class,
    # white space hack
    htmltools::HTML(paste0(link_text, hidden_span, icon_svg)),
    target = "_blank",
    rel = "noopener noreferrer",
    .noWS = c("outside")
  )

  # Attach CSS from inst/www/css/sr-only.css
  dependency <- htmltools::htmlDependency(
    name = "sr-only",
    version = as.character(utils::packageVersion("shinyGovstyle")[[1]]),
    src = c(href = "shinyGovstyle/css"),
    stylesheet = "sr-only.css"
  )

  # Also attach the base shinyGovstyle dependencies (stylesheet and the
  # update_page_title handler) so update_page_title() works in apps that use
  # external_link() without any other shinyGovstyle component.
  link <- attachDependency(link)

  # Return the link with the CSS attached
  htmltools::attachDependencies(link, dependency, append = TRUE)
}
