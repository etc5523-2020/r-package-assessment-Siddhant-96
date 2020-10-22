#' @title chosen_metric
#' 
#' @description This function incorporates the reactive function from shiny and filters the dataset based on the inputid from the ui part.
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
