#' Phase banner
#'
#' This function creates the GOV.UK
#' [phase banner](https://design-system.service.gov.uk/components/phase-banner/)
#' component, used to show that a service is still being worked on, for
#' example in alpha or beta.
#' @inheritParams id_arg
#' @param type Main type of label e.g. alpha or beta. Can be any word
#' @param label Text to display. Accepts a plain character string, or `shiny`
#' tag objects such as `shiny::tags$b("Bold")` or a `shiny::tagList()`. Not
#' required if `feedback_url` is supplied instead.
#' @inheritParams width_arg
#' @param feedback_url Optional URL used to auto-generate the standard GOV.UK
#' phase banner feedback text, e.g. "This is a new service - your feedback
#' (opens in new tab) will help us to improve it.", with `feedback` linking to
#' `feedback_url`. If `feedback_url` starts with `mailto:` the text instead
#' reads "This is a new service - please contact \[email address\] if you
#' have any questions or feedback.". Exactly one of `label` or `feedback_url`
#' must be supplied.
#' @return a phase banner HTML shiny tag object
#' @family Govstyle page structure
#' @export
#' @examples
#' ui <- shinyGovstyle::gov_page(
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::phase_banner(
#'     inputId = "banner", type = "Beta", 'This is a new service'
#'   )
#' )
#'
#' server <- function(input, output, session) {}
#'
#' if (interactive()) shinyApp(ui = ui, server = server)
#'
#' # Auto-generate the standard feedback text from a URL
#' shinyGovstyle::phase_banner(
#'   inputId = "banner",
#'   type = "Beta",
#'   feedback_url = "https://example.com/feedback"
#' )
#'
#' # Auto-generate contact text from a mailto: link
#' shinyGovstyle::phase_banner(
#'   inputId = "banner",
#'   type = "Beta",
#'   feedback_url = "mailto:feedback@example.com"
#' )
phase_banner <- function(
  inputId, # nolint
  type,
  label = NULL,
  feedback_url = NULL,
  width = "standard"
) {
  wc <- gov_width_container(width, is_default = missing(width))

  if (is.null(label) && is.null(feedback_url)) {
    stop("Either `label` or `feedback_url` must be provided")
  }

  if (!is.null(label) && !is.null(feedback_url)) {
    stop("Provide only one of `label` or `feedback_url`")
  }

  if (!is.null(feedback_url)) {
    label <- feedback_banner_label(feedback_url)
  }

  gov_banner <- shiny::tags$div(
    class = "govuk-phase-banner",
    id = inputId,
    shiny::tags$div(
      class = wc$class,
      style = wc$style,
      shiny::tags$p(
        class = "govuk-phase-banner__content",
        shiny::tags$strong(
          class = "govuk-tag govuk-phase-banner__content__tag",
          type
        ),
        shiny::tags$span(
          class = "govuk-phase-banner__text",
          as_govuk_html(label)
        )
      )
    )
  )
  attachDependency(gov_banner)
}

# Internal helper: builds the standard GOV.UK phase banner feedback label from
# a URL. mailto: links get contact-style wording; external_link() itself
# suppresses the new-tab attributes/text for mailto hrefs.
feedback_banner_label <- function(feedback_url) {
  if (grepl("^mailto:", feedback_url, ignore.case = TRUE)) {
    email_address <- sub("^mailto:", "", feedback_url, ignore.case = TRUE)
    email_address <- sub("\\?.*$", "", email_address)

    shiny::tagList(
      "This is a new service - please contact ",
      external_link(feedback_url, email_address),
      " if you have any questions or feedback."
    )
  } else {
    shiny::tagList(
      "This is a new service - your ",
      external_link(feedback_url, "feedback"),
      " will help us to improve it."
    )
  }
}
