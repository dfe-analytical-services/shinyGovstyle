# A demo-only control that previews shinyGovstyle::gov_page()'s `width`
# option live. This is NOT a shinyGovstyle package feature: gov_page(width =
# ...) is a static, render-time argument, not something end users switch in a
# real app. This module fakes a live switch purely for the showcase, by
# flipping the same data-govuk-page-width attribute the package's own CSS
# already keys off (see inst/www/css/width-overrides.css).
#
# The toggle's look is adapted from GOV.UK's "Language navigation" component
# (https://design-system.service.gov.uk/components/language-navigation/),
# which is still a Trial component and isn't in shinyGovstyle's vendored
# GOV.UK Frontend CSS. The markup/CSS below were copied from the live
# rendered component and renamed from govuk-language-navigation* to
# shinygovstyle-width-toggle*, since this isn't the real component and this
# CSS is app-only, not shipped as part of the package.

mod_width_toggle_ui <- function(id) {
  shiny::tagList(
    shiny::tags$style(shiny::HTML(
      "
      .shinygovstyle-width-toggle {
        font-family: \"GDS Transport\", arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        font-weight: 400;
        font-size: 1.1875rem;
        line-height: 1.31579;
        margin-bottom: 20px;
        color: var(--govuk-text-colour, #0b0c0c);
      }
      .shinygovstyle-width-toggle__list {
        display: inline-flex;
        flex-wrap: wrap;
        row-gap: 10px;
        margin: 0;
        padding: 0;
        list-style-type: none;
      }
      .shinygovstyle-width-toggle__list-item {
        display: flex;
        align-items: center;
      }
      .shinygovstyle-width-toggle__list-item:not(:last-child)::after {
        content: \"\";
        display: block;
        height: 1em;
        margin-right: 10px;
        margin-left: 10px;
        border-right: 1px solid var(--govuk-border-colour, #cecece);
      }
      .shinygovstyle-width-toggle__link {
        font-family: \"GDS Transport\", arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        text-decoration: underline max(1px, 0.0625rem);
        text-underline-offset: 0.1578em;
      }
      .shinygovstyle-width-toggle__link:hover {
        text-decoration-thickness: max(3px, 0.1875rem, 0.12em);
        text-decoration-skip-ink: none;
      }
      .shinygovstyle-width-toggle__link:focus {
        outline: 3px solid transparent;
        background-color: var(--govuk-focus-colour, #fd0);
        box-shadow: 0 -2px var(--govuk-focus-colour, #fd0),
          0 4px var(--govuk-focus-text-colour, #0b0c0c);
        text-decoration: none;
      }
      .shinygovstyle-width-toggle__link:link {
        color: var(--govuk-link-colour, #1a65a6);
      }
      .shinygovstyle-width-toggle__link:visited {
        color: var(--govuk-link-visited-colour, #54319f);
      }
      .shinygovstyle-width-toggle__link:hover {
        color: var(--govuk-link-hover-colour, #0f385c);
      }
      .shinygovstyle-width-toggle__link:active {
        color: var(--govuk-link-active-colour, #0b0c0c);
      }
      .shinygovstyle-width-toggle__link:focus {
        color: var(--govuk-focus-text-colour, #0b0c0c);
      }
      "
    )),
    shiny::uiOutput(shiny::NS(id, "toggle"))
  )
}

mod_width_toggle_server <- function(id, initial = "full") {
  shiny::moduleServer(id, function(input, output, session) {
    tiers <- c(
      full = "Full",
      "three-quarters" = "Three quarters",
      standard = "Standard"
    )
    current <- shiny::reactiveVal(initial)

    output$toggle <- shiny::renderUI({
      active <- current()

      items <- lapply(names(tiers), function(tier) {
        label <- tiers[[tier]]
        content <- if (identical(tier, active)) {
          shiny::tags$span(
            class = "shinygovstyle-width-toggle__text",
            `aria-current` = "true",
            label
          )
        } else {
          shiny::actionLink(
            inputId = session$ns(paste0("set_", tier)),
            label = label,
            class = "shinygovstyle-width-toggle__link"
          )
        }
        shiny::tags$li(class = "shinygovstyle-width-toggle__list-item", content)
      })

      shiny::tags$nav(
        class = "shinygovstyle-width-toggle",
        `aria-label` = "Page width",
        shiny::tags$ul(class = "shinygovstyle-width-toggle__list", items)
      )
    })

    # One observer per tier (lapply, not a for loop, so each closure keeps
    # its own copy of `tier` rather than all three sharing the loop's final
    # value).
    lapply(names(tiers), function(tier) {
      shiny::observeEvent(input[[paste0("set_", tier)]], {
        current(tier)
        shinyjs::runjs(sprintf(
          paste0(
            "document.querySelector('[data-govuk-page-width]')",
            ".setAttribute('data-govuk-page-width', '%s');"
          ),
          tier
        ))
      })
    })
  })
}
