#' Radio Button Function
#'
#' This function create radio buttons
#' @param inputId The `input` slot that will be used to access the value
#' @param label Input label
#' @param choices List of values to select from (if elements of the list are
#' named then that name rather than the value is displayed to the user)
#' @param selected The initially selected value.
#' @param inline  If you want the radio inline or not,  Default is FALSE
#' @param small  If you want the smaller versions of radio buttons,  Default
#' is FALSE
#' @param choiceNames,choiceValues Same as in
#' [shiny::checkboxGroupInput()]. List of names and values,
#' respectively, that are displayed to the user in the app and correspond to
#' the each choice (for this reason they must have the same length). If either
#' of these arguments is provided, then the other must be provided and choices
#' must not be provided. The advantage of using both of these over a named list
#' for choices is that choiceNames allows any type of UI object to be passed
#' through (tag objects, icons, HTML code, ...), instead of just simple text
#' @param hint_label Additional hint text you may want to display below the
#' label. Defaults to NULL
#' @param error Whenever you want to include error handle on the component
#' @param error_message If you want a default error message
#' @param custom_class If you want to add additional classes to the radio
#' buttons
#' @param label_size Size modifier for the legend. One of `"m"`, `"s"`, `"l"`,
#' or `"xl"`, matching the GDS `govuk-fieldset__legend--*` classes. Defaults
#' to `"m"`.
#' @param heading_level Optional heading level for the legend. If supplied
#' (an integer 1-6), the legend text is wrapped in a `<hN>` with the GDS
#' `govuk-fieldset__heading` class, following the GDS pattern for using a
#' question as the page heading. Defaults to `NULL` (no heading wrap).
#' @return radio buttons HTML shiny tag object
#' @family Govstyle select inputs
#' @export
#' @examples
#' ui <- shiny::fluidPage(
#'   # Required for error handling function
#'   shinyjs::useShinyjs(),
#'   shinyGovstyle::header(
#'     org_name = "Example",
#'     service_name = "User Examples",
#'     logo = "shinyGovstyle/images/moj_logo.png"
#'   ),
#'   shinyGovstyle::banner(
#'     inputId = "banner", type = "beta", "This is a new service"
#'   ),
#'   shinyGovstyle::gov_layout(
#'     size = "two-thirds",
#'     # Simple radio
#'     shinyGovstyle::radio_button_Input(
#'       inputId = "radio1",
#'       choices = c("Yes", "No", "Maybe"),
#'       label = "Choice option"
#'     ),
#'     # Error radio
#'     shinyGovstyle::radio_button_Input(
#'       inputId = "radio2",
#'       choices = c("Yes", "No", "Maybe"),
#'       label = "Choice option",
#'       hint_label = "Select the best fit",
#'       inline = TRUE,
#'       error = TRUE,
#'       error_message = "Select one"
#'     ),
#'     # Button to trigger error
#'     shinyGovstyle::button_Input(inputId = "submit", label = "Submit")
#'   ),
#'   shinyGovstyle::footer(full = TRUE)
#' )
#'
#' server <- function(input, output, session) {
#'   # Trigger error on blank submit of eventId2
#'   observeEvent(input$submit, {
#'     if (is.null(input$radio2)) {
#'       shinyGovstyle::error_on(inputId = "radio2")
#'     } else {
#'       shinyGovstyle::error_off(
#'         inputId = "radio2"
#'       )
#'     }
#'   })
#' }
#' if (interactive()) shinyApp(ui = ui, server = server)
radio_button_Input <- # nolint
  function(
    inputId, # nolint
    label,
    choices = NULL,
    selected = NULL,
    inline = FALSE,
    small = FALSE,
    choiceNames = NULL, # nolint
    choiceValues = NULL, # nolint
    hint_label = NULL,
    error = FALSE,
    error_message = NULL,
    custom_class = "",
    label_size = c("m", "s", "l", "xl"),
    heading_level = NULL
  ) {
    label_size <- match.arg(label_size)
    if (!is.null(heading_level) &&
          !(length(heading_level) == 1 &&
              heading_level %in% 1:6)) {
      stop("`heading_level` must be NULL or a single integer between 1 and 6.")
    }
    args <- normalizeChoicesArgs2(choices, choiceNames, choiceValues)
    selected <- shiny::restoreInput(id = inputId, default = selected)
    selected <- as.character(selected)
    if (length(selected) > 1) {
      stop("The 'selected' argument must be of length 1")
    }
    options <- generateOptions2(
      inputId,
      selected,
      inline,
      small,
      "radio",
      args$choiceNames,
      args$choiceValues
    )
    div_class <- paste("govuk-form-group govuk-radios", custom_class)
    hint_id <- if (!is.null(hint_label)) paste0(inputId, "-hint")
    error_id <- if (error == TRUE) paste0(inputId, "error")
    described_by <- paste(c(hint_id, error_id), collapse = " ")
    legend_class <- paste0(
      "govuk-fieldset__legend govuk-fieldset__legend--",
      label_size
    )
    legend_content <- if (!is.null(heading_level)) {
      shiny::tag(
        paste0("h", heading_level),
        list(class = "govuk-fieldset__heading", label)
      )
    } else {
      label
    }
    fieldset_args <- list(
      class = "govuk-fieldset",
      shiny::tags$legend(
        legend_content,
        class = legend_class
      ),
      shiny::tags$div(
        hint_label,
        id = hint_id,
        class = "govuk-hint"
      ),
      if (error == TRUE) {
        shinyjs::hidden(
          shiny::tags$p(
            error_message,
            class = "govuk-error-message",
            id = error_id,
            shiny::tags$span(
              "Error:",
              class = "govuk-visually-hidden"
            )
          )
        )
      },
      options
    )
    if (nzchar(described_by)) {
      fieldset_args$`aria-describedby` <- described_by
    }
    gov_radio <- shiny::tags$div(
      id = inputId,
      class = div_class,
      shiny::tags$div(
        class = "govuk-form-group",
        id = paste0(inputId, "div"),
        do.call(shiny::tags$fieldset, fieldset_args)
      )
    )

    attachDependency(gov_radio, "radio")
  }

generateOptions2 <- # nolint
  function(
    inputId, # nolint
    selected,
    inline,
    small,
    type = "checkbox",
    choiceNames, # nolint
    choiceValues, # nolint
    session = shiny::getDefaultReactiveDomain()
  ) {
    options <- mapply(
      choiceValues,
      choiceNames,
      seq_along(choiceValues),
      FUN = function(value, name, idx) {
        option_id <- paste0(inputId, "-", idx)
        inputTag <- # nolint
          shiny::tags$input(
            type = type,
            name = inputId,
            id = option_id,
            value = value,
            class = "govuk-radios__input"
          )
        if (is.null(selected) == FALSE & value %in% selected) {
          inputTag$attribs$checked <- "checked" # nolint
        }
        pd <- processDeps2(name, session)
        shiny::tags$div(
          class = "govuk-radios__item",
          inputTag,
          shiny::tags$label(
            pd$html,
            pd$deps,
            `for` = option_id,
            class = "govuk-label govuk-radios__label"
          )
        )
      },
      SIMPLIFY = FALSE,
      USE.NAMES = FALSE
    )

    class_build <- "govuk-radios"

    if (inline) {
      class_build <- paste(class_build, "govuk-radios--inline")
    }

    if (small) {
      class_build <- paste(class_build, "govuk-radios--small")
    }

    shiny::div(class = class_build, options)
  }

processDeps2 <- # nolint
  function(tags, session) {
    ui <- htmltools::takeSingletons(
      tags,
      session$singletons,
      desingleton = FALSE
    )$ui
    ui <- htmltools::surroundSingletons(ui)
    dependencies <- lapply(
      htmltools::resolveDependencies(
        htmltools::findDependencies(ui)
      ),
      shiny::createWebDependency
    )
    names(dependencies) <- NULL
    list(html = htmltools::doRenderTags(ui), deps = dependencies)
  }

normalizeChoicesArgs2 <- # nolint
  function(
    choices,
    choiceNames, # nolint
    choiceValues, # nolint
    mustExist = TRUE # nolint
  ) {
    if (!is.null(choices)) {
      if (!is.null(choiceNames) || !is.null(choiceValues)) {
        warning(
          "Using `choices` argument; ignoring `choiceNames`
              and `choiceValues`."
        )
      }
      choices <- choicesWithNames2(choices)
      choiceNames <- names(choices) # nolint
      choiceValues <- unname(choices) # nolint
      list(
        choiceNames = as.list(choiceNames),
        choiceValues = as.list(as.character(choiceValues))
      )
    } else if (is.null(choiceNames) || is.null(choiceValues)) {
      if (mustExist) {
        stop(
          "Please specify a non-empty vector for `choices` (or, ",
          "alternatively, for both `choiceNames` AND `choiceValues`)."
        )
      } else if (is.null(choiceNames) && is.null(choiceValues)) {
        list(choiceNames = NULL, choiceValues = NULL)
      } else {
        stop(
          "One of `choiceNames` or `choiceValues` was set to ",
          "NULL, but either both or none should be NULL."
        )
      }
    } else {
      if (length(choiceNames) != length(choiceValues)) {
        stop("`choiceNames` and `choiceValues` must have the same length.")
      }
      if (anyNamed2(choiceNames) || anyNamed2(choiceValues)) {
        stop("`choiceNames` and `choiceValues` must not be named.")
      }
      list(
        choiceNames = as.list(choiceNames),
        choiceValues = as.list(as.character(choiceValues))
      )
    }
  }


choicesWithNames2 <- # nolint
  function(choices) {
    listify <- function(obj) {
      makeNamed <- # nolint
        function(x) {
          if (is.null(names(x))) {
            names(x) <- character(length(x))
          }
          x
        }
      res <- lapply(obj, function(val) {
        if (is.list(val)) {
          listify(val)
        } else if (length(val) == 1 && is.null(names(val))) {
          as.character(val)
        } else {
          makeNamed(as.list(val))
        }
      })
      makeNamed(res)
    }
    choices <- listify(choices)
    if (length(choices) == 0) {
      choices
    } else {
      choices <- mapply(
        choices,
        names(choices),
        FUN = function(choice, name) {
          if (!is.list(choice)) {
            choice
          } else {
            if (name == "") {
              stop("All sub-lists in \"choices\" must be named.")
            }
            choicesWithNames2(choice)
          }
        },
        SIMPLIFY = FALSE
      )
      missing <- names(choices) == ""
      names(choices)[missing] <- as.character(choices)[missing]
      choices
    }
  }

anyNamed2 <- # nolint
  function(x) {
    if (length(x) == 0 || is.null(names(x))) {
      FALSE
    } else {
      any(nzchar(names(x)))
    }
  }
