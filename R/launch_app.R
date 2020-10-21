#' @title launch_app
#' 
#' @description This function is used to launch the covid_asia shiny app into a separate window.
#'   
#'    
#' @export
launch_app <- function() {
  appDir <- system.file("shiny_app", "app.R", package = "covidasia")
  if (appDir == "") {
    stop("File not found. Try to re-install `covid
         asia`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}

"launch_app"