#' Plot leakage over time
#'
#' Quick ggplot to show how leakage events change over time and across periods.
#' Good for vignettes and for embedding in the Shiny app via \code{renderPlot()}.
#'
#' @param data A data frame, usually \code{delta_cases}.
#' @return A ggplot object.
#' @examples
#' \dontrun{
#'   data(delta_cases)
#'   plot_leakage_trend(delta_cases)
#' }
#' @export
plot_leakage_trend <- function(data) {
  # ensure ggplot2 is available
  ggplot2::ggplot(data, ggplot2::aes(x = .data$date,
                                     y = .data$leakage,
                                     color = .data$period,
                                     group = 1)) +
    ggplot2::geom_line() +
    ggplot2::geom_point() +
    ggplot2::labs(
      x = "Month",
      y = "Leakage events",
      color = "Period",
      title = "Quarantine leakage events over time"
    ) +
    ggplot2::theme_minimal()
}
