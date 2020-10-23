library(tibble)
data = as.tibble(c(1:5))
input = as.tibble(c(1:5))

test_that("test cm", {
  expect_equal(seleted_country <- reactive({
    data %>%
      filter(administrative_area_level_1 == input)
  }), chosen_metric(data, input))
})
