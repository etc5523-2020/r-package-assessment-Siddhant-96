#' @title chooseinput
#' 
#' @description This function is used to launch the covid_asia shiny app
#'
#' @param asia_filter filtered dataset
#' @param country country para
#'    
#' @import shiny
#'   
#' @export
chooseinput <- function(country, asia_filter) {
  selectInput(inputId = country,
              label = "Select country",
              selected = "India",
              choices = unique(asia_filter$administrative_area_level_1))
}

"chooseinput"
