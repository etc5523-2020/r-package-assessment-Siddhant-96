#' @title chosen_metric
#' 
#' @description This function is used to launch the covid_asia shiny app
#'   
#' @param data input data is the filtered dataset including active cases
#' @param input dataframe generated from shiny based on user control input
#' 
#'
#' @importFrom dplyr filter
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
