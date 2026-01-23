#' Header Function
#'
#' This function create a header banner. For use at top of the screen
#' @param main_text Main text that goes in the header
#' @param secondary_text Secondary header to supplement the main text
#' @param logo Add a link to a logo which will apply in the header. Use crown to
#' use the crown SVG version on GOV UK
#' @param main_link Add a link for clicking on main text
#' @param secondary_link Add a link for clicking on secondary header
#' @param logo_alt_text Add alternative text for the logo. Should be used when a
#' logo is used
#' @param main_alt_text Add alternative text for the main link. Should be used
#' when a main link is used
#' @param secondary_alt_text Add alternative text for the secondary link. Should
#' be used when a secondary link is used
#' @param logo_width Change the logo size width CSS to improve fit
#' @param logo_height Change the logo size height CSS to improve fit
#' @return a header HTML shiny tag object
#' @keywords header
#' @family Govstyle page structure
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png",
#'     logo_alt_text = "Ministry of Justice Logo"
#'   )
#' )
#'
#' server <- function(input, output, session) {}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
header <- function(
  main_text,
  secondary_text,
  logo = NULL,
  main_link = "#",
  secondary_link = "#",
  logo_alt_text = NULL,
  main_alt_text = NULL,
  secondary_alt_text = NULL,
  logo_width = 36,
  logo_height = 32
) {
  # checks for alt text
  if (!is.null(logo) && is.null(logo_alt_text)) {
    warning(
      paste(
        "Please use logo_alt_text to provide alternative",
        "text for the logo you used."
      )
    )
  }

  if (main_link != "#" && is.null(main_alt_text)) {
    warning(
      paste(
        "Please use main_alt_text to provide alternative",
        "text for the main link you used."
      )
    )
  }

  if (secondary_link != "#" && is.null(secondary_alt_text)) {
    warning(
      paste(
        "Please use secondary_alt_text to provide alternative",
        "text for the secondary link you used."
      )
    )
  }

  if (is.null(logo)) {
    logo_src <- "null"
  } else {
    logo_src <- logo
  }

  gov_header <- shiny::tags$header(
    class = "govuk-header",
    role = "banner",
    shinyjs::inlineCSS(paste0(
      ".govuk-header__logotype-crown-fallback-image {width: ",
      logo_width,
      "px;
      height: ",
      logo_height,
      "px;}",
      ".govuk-header__link:focus .govuk-header__logotype-crown-fallback-image",
      ", .govuk-header__link:active .govuk-header__logotype-crown-fallback-",
      "image {filter: invert(1);}"
    )),
    shiny::tags$div(
      class = "govuk-header__container govuk-width-container",
      shiny::tags$div(
        class = "govuk-header__logo",
        shiny::tags$a(
          href = main_link,
          `aria-label` = main_alt_text,
          class = "govuk-header__link govuk-header__link--homepage",
          shiny::tags$span(
            class = "govuk-header__logotype",
            if (logo_src == "crown") {
              shiny::tags$svg(
                `aria-hidden` = "true",
                focusable = "false",
                class = "govuk-header__logotype-crown",
                xmlns = "http://www.w3.org/2000/svg",
                viewBox = "0 0 132 97",
                height = "30",
                width = "36",
                shiny::tags$path(
                  fill = "currentColor",
                  `fill-rule` = "evenodd",
                  d = paste0(
                    "M25 30.2c3.5 1.5 7.7-.2 9.1-3.7 1.5-3.6-.2-7.8-3.9-9.2-3",
                    ".6-1.4-7.6.3-9.1 3.9-1.4 3.5.3 7.5 3.9 9zM9 39.5c3.6 1.5",
                    " 7.8-.2 9.2-3.7 1.5-3.6-.2-7.8-3.9-9.1-3.6-1.5-7.6.2-9.1",
                    " 3.8-1.4 3.5.3 7.5 3.8 9zM4.4 57.2c3.5 1.5 7.7-.2 9.1-3.",
                    "8 1.5-3.6-.2-7.7-3.9-9.1-3.5-1.5-7.6.3-9.1 3.8-1.4 3.5.3",
                    " 7.6 3.9 9.1zm38.3-21.4c3.5 1.5 7.7-.2 9.1-3.8 1.5-3.6-.",
                    "2-7.7-3.9-9.1-3.6-1.5-7.6.3-9.1 3.8-1.3 3.6.4 7.7 3.9 9.",
                    "1zm64.4-5.6c-3.6 1.5-7.8-.2-9.1-3.7-1.5-3.6.2-7.8 3.8-9.",
                    "2 3.6-1.4 7.7.3 9.2 3.9 1.3 3.5-.4 7.5-3.9 9zm15.9 9.3c-",
                    "3.6 1.5-7.7-.2-9.1-3.7-1.5-3.6.2-7.8 3.7-9.1 3.6-1.5 7.7",
                    ".2 9.2 3.8 1.5 3.5-.3 7.5-3.8 9zm4.7 17.7c-3.6 1.5-7.8-.",
                    "2-9.2-3.8-1.5-3.6.2-7.7 3.9-9.1 3.6-1.5 7.7.3 9.2 3.8 1.",
                    "3 3.5-.4 7.6-3.9 9.1zM89.3 35.8c-3.6 1.5-7.8-.2-9.2-3.8-",
                    "1.4-3.6.2-7.7 3.9-9.1 3.6-1.5 7.7.3 9.2 3.8 1.4 3.6-.3 7",
                    ".7-3.9 9.1zM69.7 17.7l8.9 4.7V9.3l-8.9 2.8c-.2-.3-.5-.6-",
                    ".9-.9L72.4 0H59.6l3.5 11.2c-.3.3-.6.5-.9.9l-8.8-2.8v13.1",
                    "l8.8-4.7c.3.3.6.7.9.9l-5 15.4v.1c-.2.8-.4 1.6-.4 2.4 0 4",
                    ".1 3.1 7.5 7 8.1h.2c.3 0 .7.1 1 .1.4 0 .7 0 1-.1h.2c4-.6",
                    " 7.1-4.1 7.1-8.1 0-.8-.1-1.7-.4-2.4V34l-5.1-15.4c.4-.2.7",
                    "-.6 1-.9zM66 92.8c16.9 0 32.8 1.1 47.1 3.2 4-16.9 8.9-26",
                    ".7 14-33.5l-9.6-3.4c1 4.9 1.1 7.2 0 10.2-1.5-1.4-3-4.3-4",
                    ".2-8.7L108.6 76c2.8-2 5-3.2 7.5-3.3-4.4 9.4-10 11.9-13.6",
                    " 11.2-4.3-.8-6.3-4.6-5.6-7.9 1-4.7 5.7-5.9 8-.5 4.3-8.7-",
                    "3-11.4-7.6-8.8 7.1-7.2 7.9-13.5 2.1-21.1-8 6.1-8.1 12.3-",
                    "4.5 20.8-4.7-5.4-12.1-2.5-9.5 6.2 3.4-5.2 7.9-2 7.2 3.1-",
                    ".6 4.3-6.4 7.8-13.5 7.2-10.3-.9-10.9-8-11.2-13.8 2.5-.5 ",
                    "7.1 1.8 11 7.3L80.2 60c-4.1 4.4-8 5.3-12.3 5.4 1.4-4.4 8",
                    "-11.6 8-11.6H55.5s6.4 7.2 7.9 11.6c-4.2-.1-8-1-12.3-5.4l",
                    "1.4 16.4c3.9-5.5 8.5-7.7 10.9-7.3-.3 5.8-.9 12.8-11.1 13",
                    ".8-7.2.6-12.9-2.9-13.5-7.2-.7-5 3.8-8.3 7.1-3.1 2.7-8.7-",
                    "4.6-11.6-9.4-6.2 3.7-8.5 3.6-14.7-4.6-20.8-5.8 7.6-5 13.",
                    "9 2.2 21.1-4.7-2.6-11.9.1-7.7 8.8 2.3-5.5 7.1-4.2 8.1.5.",
                    "7 3.3-1.3 7.1-5.7 7.9-3.5.7-9-1.8-13.5-11.2 2.5.1 4.7 1.",
                    "3 7.5 3.3l-4.7-15.4c-1.2 4.4-2.7 7.2-4.3 8.7-1.1-3-.9-5.",
                    "3 0-10.2l-9.5 3.4c5 6.9 9.9 16.7 14 33.5 14.8-2.1 30.8-3",
                    ".2 47.7-3.2z"
                  )
                )
              )
            } else {
              shiny::tags$img(
                src = logo,
                class = "govuk-header__logotype-crown-fallback-image",
                alt_text = logo_alt_text
              )
            },
            shiny::tags$span(main_text, class = "govuk-header__logotype-text")
          )
        )
      ),
      shiny::tags$div(
        class = "govuk-header__content",
        shiny::tags$a(
          href = secondary_link,
          secondary_text,
          `aria-label` = secondary_alt_text,
          class = "govuk-header__link govuk-header__service-name"
        )
      )
    )
  )
  attachDependency(gov_header)
}
