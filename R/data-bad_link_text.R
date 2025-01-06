#' Lookup for bad link text
#'
#' A single column data frame, listing out known examples of bad link text that
#' check for in the `external_link()` function.
#'
#' We've started curating this list so we can create automated checks to help
#' all link text to be as descriptive as possible in line with
#' [WCAG 2.2 success criteria 2.4.4: Link Purpose (In Context)](
#' https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context).
#'
#' @format ## `bad_link_text`
#' A data frame with 53 rows and 1 columns:
#' \describe{
#'   \item{bad_link_text}{Lower cased examples of non-descriptive link text}
#' }
#' @source Curated by explore.statistics@@education.gov.uk
"bad_link_text"
