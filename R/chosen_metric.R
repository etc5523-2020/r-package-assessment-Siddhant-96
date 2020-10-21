#' @title chosen_metric
#' 
#' @description This function is used to launch the covid_asia shiny app
#'   
#' @param 
#' @param 
#'    
#' @import shiny
#'   
#' @export
chosen_metric <- function(data, input) {
  selected_country <- reactive({
    data %>%
      filter(administrative_area_level_1 == input)
  })
  return(selected_country)
}

"chosen_metric"
