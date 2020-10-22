#' @title chooseinput
#' 
#' @description This function replaces the functionality of the built-in selectinput function of shiny based on the parameters mentioned in the ui part of the app.
#'
#' @param asia_filter filtered dataset inclding active cases
#' @param country inputID parameter based on UI page
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
