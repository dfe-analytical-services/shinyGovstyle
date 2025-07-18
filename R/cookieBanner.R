#' Cookie Banner Function
#'
#' This function creates a cookie banner. You need to have shinyjs::useShinyjs()
#' enabled to work.  All the ids are pre set.  See example for how to
#' structure.
#' @param service_name Name for this service to add to banner
#' @return a cookie banner html shiny object.
#' @keywords cookie banner
#' @export
#' @examples
#' if (interactive()) {
#' ui <- fluidPage(
#'   shinyGovstyle::header(
#'     main_text = "Example",
#'     secondary_text = "User Examples",
#'     logo="shinyGovstyle/images/moj_logo.png"),
#'   #Needs shinyjs to work
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::cookieBanner("The best thing"),
#'   shinyGovstyle::gov_layout(size = "two-thirds"),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'
#'   #Need these set of observeEvent to create a path through the cookie banner
#'   observeEvent(input$cookieAccept, {
#'     shinyjs::show(id = "cookieAcceptDiv")
#'     shinyjs::hide(id = "cookieMain")
#'   })
#'
#'   observeEvent(input$cookieReject, {
#'     shinyjs::show(id = "cookieRejectDiv")
#'     shinyjs::hide(id = "cookieMain")
#'   })
#'
#'   observeEvent(input$hideAccept, {
#'     shinyjs::toggle(id = "cookieDiv")
#'   })
#'
#'   observeEvent(input$hideReject, {
#'     shinyjs::toggle(id = "cookieDiv")
#'   })
#'
#'   observeEvent(input$cookieLink, {
#'     #Need to link here to where further info is located.  You can use
#'     #updateTabsetPanel to have a cookie page for instance
#'   })
#'
#' }
#' shinyApp(ui = ui, server = server)
#' }

cookieBanner <- function(service_name) {
  govCookieLink <- shiny::actionLink(
    inputId = "cookieLink",
    label = "View cookies",
    class = "govuk-link"
  )

  cookieBanner_Input <-
    shiny::tags$div(
      id = "cookieDiv",
      class = "govuk-cookie-banner",
      `data-nosnippet role` = "region",
      `aria-label` = paste("Cookies on", service_name),
      shiny::tags$div(
        id = "cookieMain",
        class = "govuk-cookie-banner__message govuk-width-container",
        shiny::tags$div(
          class = "govuk-grid-row",
          shiny::tags$div(
            class = "govuk-grid-column-two-thirds",
            shiny::tags$h2(
              class = "govuk-cookie-banner__heading govuk-heading-m",
              paste("Cookies on", service_name)
            ),
            shiny::tags$div(
              class = "govuk-cookie-banner__content",
              shiny::tags$p(
                class = "govuk-body",
                "We use some essential cookies to make this service work."
              ),
              shiny::tags$p(
                class = "govuk-body",
                "We\u0027d also like to use analytics cookies so we can understand
                how you use the service and make improvements."
              )
            )
          )
        ),
        shiny::tags$div(
          class = "govuk-button-group",
          button_Input("cookieAccept", "Accept analytics cookies"),
          button_Input("cookieReject", "Reject analytics cookies"),
          govCookieLink
        )
      ),
      shinyjs::hidden(
        shiny::tags$div(
          id = "cookieAcceptDiv",
          class = "govuk-cookie-banner__message govuk-width-container",
          shiny::tags$div(
            class = "govuk-grid-row",
            shiny::tags$div(
              class = "govuk-grid-column-two-thirds",
              shiny::tags$div(
                class = "govuk-cookie-banner__content",
                shiny::tags$p(
                  class = "govuk-body",
                  "You\u0027ve accepted additional cookies. You can change your
                cookie settings at any time."
                )
              )
            )
          ),
          shiny::tags$div(
            class = "govuk-button-group",
            button_Input("hideAccept", "Hide this message")
          )
        )
      ),
      shinyjs::hidden(
        shiny::tags$div(
          id = "cookieRejectDiv",
          class = "govuk-cookie-banner__message govuk-width-container",
          shiny::tags$div(
            class = "govuk-grid-row",
            shiny::tags$div(
              class = "govuk-grid-column-two-thirds",
              shiny::tags$div(
                class = "govuk-cookie-banner__content",
                shiny::tags$p(
                  class = "govuk-body",
                  "You\u0027ve rejected additional cookies. You can change your
                cookie settings at any time."
                )
              )
            )
          ),
          shiny::tags$div(
            class = "govuk-button-group",
            button_Input("hideReject", "Hide this message")
          )
        )
      )
    )

  attachDependency(cookieBanner_Input)
}
