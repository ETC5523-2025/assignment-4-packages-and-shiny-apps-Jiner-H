#' Summarise leakage and detection rates by period
#'
#' This function takes the reconstructed quarantine dataset and returns
#' period-level summaries that are useful for tables or plots in the Shiny app.
#'
#' @param data A data frame, usually \code{delta_cases}.
#'
#' @return A tibble with one row per period and summary columns.
#' @examples
#' \dontrun{
#'   data(delta_cases)
#'   summarise_leakage(delta_cases)
#' }
#' @export
summarise_leakage <- function(data) {
  data |>
    dplyr::group_by(.data$period) |>
    dplyr::summarise(
      n_months = dplyr::n(),
      total_arrivals = sum(.data$arrivals, na.rm = TRUE),
      total_leakage = sum(.data$leakage, na.rm = TRUE),
      total_detected = sum(.data$detected_in_quarantine, na.rm = TRUE),
      mean_leakage_per_1000 = mean(.data$leakage_per_1000_arrivals, na.rm = TRUE),
      mean_detected_rate = mean(.data$detected_rate, na.rm = TRUE)
    ) |>
    dplyr::arrange(.data$period)
}
