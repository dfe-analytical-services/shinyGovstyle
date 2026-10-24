# A demo-only control that previews shinyGovstyle::gov_page()'s width
# option live. This is not a package feature: gov_page(width = ...) is a
# render-time argument. The showcase changes the data-govuk-page-width
# attribute used by the package's width CSS.
#
# These are toggle buttons rather than navigation links because they change
# the appearance of the current page. The styling is local to the showcase.

width_tiers <- c(
  full = "Full",
  "three-quarters" = "Three quarters",
  standard = "Standard"
)

mod_width_toggle_ui <- function(id, initial = "full") {
  shiny::tagList(
    shiny::tags$style(shiny::HTML(
      "
      .shinygovstyle-width-toggle {
        display: inline-flex;
        flex-wrap: wrap;
        row-gap: 10px;
        font-family: \"GDS Transport\", arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        font-size: 1.1875rem;
        line-height: 1.31579;
        margin-bottom: 10px;
        color: var(--govuk-text-colour, #0b0c0c);
      }
      .shinygovstyle-width-toggle__item {
        display: flex;
        align-items: center;
      }
      .shinygovstyle-width-toggle__item:not(:last-child)::after {
        content: \"\";
        display: block;
        height: 1em;
        margin-right: 10px;
        margin-left: 10px;
        border-right: 1px solid var(--govuk-border-colour, #cecece);
      }
      .shinygovstyle-width-toggle .shinygovstyle-width-toggle__button {
        appearance: none;
        background: transparent;
        border: 0;
        border-radius: 0;
        box-shadow: none;
        margin: 0;
        padding: 0;
        color: var(--govuk-link-colour, #1a65a6);
        cursor: pointer;
        font: inherit;
        text-decoration: underline max(1px, 0.0625rem);
        text-underline-offset: 0.1578em;
      }
      .shinygovstyle-width-toggle .shinygovstyle-width-toggle__button:hover {
        background: transparent;
        color: var(--govuk-link-hover-colour, #0f385c);
        text-decoration-thickness: max(3px, 0.1875rem, 0.12em);
        text-decoration-skip-ink: none;
      }
      .shinygovstyle-width-toggle .shinygovstyle-width-toggle__button:active {
        background: transparent;
        color: var(--govuk-link-active-colour, #0b0c0c);
      }
      .shinygovstyle-width-toggle
        .shinygovstyle-width-toggle__button[aria-pressed=\"true\"],
      .shinygovstyle-width-toggle
        .shinygovstyle-width-toggle__button[aria-pressed=\"true\"]:hover {
        color: var(--govuk-text-colour, #0b0c0c);
        text-decoration: none;
      }
      .shinygovstyle-width-toggle .shinygovstyle-width-toggle__button:focus {
        outline: 3px solid transparent;
        background: var(--govuk-focus-colour, #fd0);
        box-shadow: 0 -2px var(--govuk-focus-colour, #fd0),
          0 4px var(--govuk-focus-text-colour, #0b0c0c);
        color: var(--govuk-focus-text-colour, #0b0c0c);
        text-decoration: none;
      }
      @media (forced-colors: active) {
        .shinygovstyle-width-toggle .shinygovstyle-width-toggle__button:focus {
          outline-color: Highlight;
        }
      }
      "
    )),
    shiny::tags$div(
      id = shiny::NS(id, "control"),
      class = "shinygovstyle-width-toggle",
      role = "group",
      `aria-label` = "Preview page width",
      lapply(names(width_tiers), function(tier) {
        shiny::tags$span(
          class = "shinygovstyle-width-toggle__item",
          shiny::actionButton(
            inputId = shiny::NS(id, paste0("set_", tier)),
            label = width_tiers[[tier]],
            class = "shinygovstyle-width-toggle__button",
            `aria-pressed` = if (identical(tier, initial)) "true" else "false"
          )
        )
      })
    )
  )
}

mod_width_toggle_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    # Keep the buttons in place so the clicked button retains keyboard focus.
    lapply(names(width_tiers), function(tier) {
      shiny::observeEvent(input[[paste0("set_", tier)]], {
        shinyjs::runjs(sprintf(
          paste0(
            "(function () {",
            "var page = document.querySelector('[data-govuk-page-width]');",
            "var group = document.getElementById('%s');",
            "if (!page || !group) return;",
            "page.setAttribute('data-govuk-page-width', '%s');",
            "group.querySelectorAll('button').forEach(function (button) {",
            "button.setAttribute('aria-pressed', String(button.id === '%s'));",
            "});",
            "})();"
          ),
          session$ns("control"),
          tier,
          session$ns(paste0("set_", tier))
        ))
      })
    })
  })
}
