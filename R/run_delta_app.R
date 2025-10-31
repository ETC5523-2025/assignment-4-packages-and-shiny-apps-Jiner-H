#' Launch the Delta Outbreak Shiny app
#'
#' This function runs the Shiny application that is bundled with the package
#' under \code{inst/app}. It provides an interactive way to explore the
#' reconstructed quarantine/delta-period dataset.
#'
#' @return This function is called for its side-effect of launching a Shiny app.
#' @export
#' @examples
#' \dontrun{
#'   run_delta_app()
#' }
run_delta_app <- function() {
  app_dir <- system.file("app", package = "deltaoutbreak")
  if (app_dir == "") {
    stop("Could not find Shiny app. Try re-installing `deltaoutbreak`.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
