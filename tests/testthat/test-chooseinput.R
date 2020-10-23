library(tibble)
library(shiny)
library(dplyr)
country = as.tibble(c(1:5))
asia_filter = as.tibble(c(1:5))
rename(asia_filter, administrative_area_level_1 = 1)

test_that("test ci", {
  expect_equal(selectInput(inputId = country,
                           label = "Select country",
                           selected = "India",
                           choices = unique(asia_filter$administrative_area_level_1)), chooseinput(country, asia_filter))
})
