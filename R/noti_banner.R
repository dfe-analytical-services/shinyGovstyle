#' Notification Banner Function
#'
#' This function create a notification banner
#' @param inputId The input id for the banner
#' @param title_txt The wording that appears in the title
#' @param body_txt The wording that appears in the banner body
#' @param type The type of banner.  Options are standard and success.
#' Standard is default
#' @return a notification html shiny object
#' @keywords notification banner
#' @export
#' @examples
#' if (interactive()) {
#'
#'   ui <- fluidPage(
#'     shinyGovstyle::header(
#'       main_text = "Example",
#'       secondary_text = "User Examples",
#'       logo="shinyGovstyle/images/moj_logo.png"),
#'     shinyGovstyle::noti_banner(
#'       inputId = "banner", title_txt = "Important", body_txt = "Example text")
#'   )
#'
#'   server <- function(input, output, session) {}
#'
#'   shinyApp(ui = ui, server = server)
#' }
#'
noti_banner <- function(
  inputId, # nolint
  title_txt = "Important",
  body_txt = NULL,
  type = "standard"
) {
  if (type == "success") {
    type_class <- "govuk-notification-banner govuk-notification-banner--success"
    role_type <- "alert"
  } else {
    type_class <- "govuk-notification-banner"
    role_type <- "region"
  }

  shiny::tags$div(
    class = type_class,
    role = role_type,
    `aria-labelledby` = "govuk-notification-banner-title",
    `data-module` = "govuk-notification-banner",
    shiny::tags$div(
      class = "govuk-notification-banner__header",
      shiny::tags$h2(
        class = "govuk-notification-banner__title",
        id = inputId,
        title_txt
      )
    ),
    shiny::tags$div(
      class = "govuk-notification-banner__content",
      shiny::tags$p(
        class = "govuk-notification-banner__heading",
        shiny::HTML(body_txt)
      )
    )
  )
}
