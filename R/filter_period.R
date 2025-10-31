#' Filter the reconstructed dataset by period
#'
#' This is a small convenience wrapper around \code{dplyr::filter()} so that
#' the Shiny app and vignettes don't repeat the same code. It assumes the
#' dataset has a column called \code{period} with values like "pre-delta"
#' and "delta", as created in \code{data-raw/delta_cases.R}.
#'
#' @param data A data frame, usually \code{delta_cases}.
#' @param period A character string, e.g. "pre-delta" or "delta".
#'
#' @return A filtered data frame.
#' @examples
#' \dontrun{
#'   data(delta_cases)
#'   filter_period(delta_cases, "delta")
#' }
#' @export
filter_period <- function(data, period) {
  dplyr::filter(data, .data$period == period)
}
