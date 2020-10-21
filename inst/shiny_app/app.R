library(shiny)
library(shinythemes)
library("COVID19")
library(scales)
library(plotly)
library(tidyverse)
library(plotly)
library(leaflet)
library(DT)
library(lubridate)

asia_data <- covid19(c("IND", "MDV", "LKA", "PAK", "BGD", "NPL","CHN", verbose = FALSE))

asia_data_new <- asia_data %>% group_by(id) %>% 
  mutate(Daily_Cases = ifelse(date - 1 == lag(date), confirmed - lag(confirmed), NA),
         Daily_Deaths = ifelse(date - 1 == lag(date), deaths - lag(deaths), NA),
         Daily_Recoveries = ifelse(date - 1 == lag(date), recovered - lag(recovered), NA))

asia_data_real <- asia_data_new %>% filter(date >= "2020-01-25")

aisa_data_final <- asia_data_real %>% dplyr::select("id","date", "tests", "administrative_area_level_1", "confirmed", "deaths", "recovered","Daily_Cases","Daily_Deaths","Daily_Recoveries","cancel_events","stay_home_restrictions","international_movement_restrictions","contact_tracing", "stringency_index")

asia_data_ready <- aisa_data_final 

asia_filter <- asia_data_ready %>% 
  mutate(active_cases = confirmed - deaths - recovered)

ui <- navbarPage("COVID-19 in SAARC Countries", 
                 theme = shinytheme("cosmo"),
                 tabPanel("About",
                          titlePanel("About"),
                          
                          sidebarLayout(
                            sidebarPanel(
                              h1("About the Creator"),
                              p("Name : Siddhant Tirodkar"),
                              p("Student ID : 31084486"),
                              p("Topic : Spread of COVID-19 in SAARC Countries."),
                              p("Email ID : stir0003@student.monash.edu")),
                            mainPanel(
                              h1("About the App"),
                              p("Spread of COVID-19 in SAARC Countries."),
                              p("This app provides an detailed summary of COVID-19 implications on the South Asian Association for Regional Cooperation(SAARC) countires. The app consists of 3 major tabs all of which take user input and renders different outputs."),
                              p("The first tab renders the details of total and active cases, deaths and recoveries over time by selecting the time frame and the country."),
                              p("The second tab renders the details of parameter chosen and the date. The parameters include daily cases, deaths, recoveries and tests done on any particular day in the last 9 months."),
                              p("The third tab renders the monthly statistics of the country chosen. Monthly statistics include the average cases, deaths, recoveries and the stringency index in that month."))
                          )
                 ),
                 tabPanel("Cases Over Time",
                          sidebarLayout(sidebarPanel(
                            chooseinput("Country", asia_filter = asia_filter),
                              dateRangeInput(
                                inputId = "dates",
                                label = "Date:",
                                start = "2020-02-01",
                                end = "2020-08-30"),
                              br(),
                              br(),
                              h1("About this Page"),
                              p("This tab enables the user to check the cummulative COVID19 summary for any of the SAARC countries. The tab takes the choice of the country and a time frame as the user input."),
                              p("The user input renders a line graph with the count on the y-axis and the time frame or the month on the x-axis. The figure shows the total cases, active cases, total deaths and recoveries for the country and the time frame chosen by the user."),),
                            mainPanel(plotlyOutput("plotone")))),
                 tabPanel("Daily Cases", sidebarLayout(sidebarPanel(
                              selectInput(inputId = "parameter",
                                          label = "Select Parameter",
                                          selected = "Daily_Cases",
                                          choices = c("Daily_Cases", "Daily_Deaths", "tests", "Daily_Recoveries")),
                              dateInput(inputId = "date",
                                label = "Date",
                                value =  "2020-05-28"),
                              br(),
                              br(),
                              h1("About this Page"),
                              p("This tab enables the user to check the daily COVID19 impact for all of the SAARC countries together for better differentiation. The tab takes the choice of the parameter and date as the user input."),
                              p("The user input renders a leaflet map of the SAARC region and the parameter chosen by the user are displayed for all the countries with the help of colourful circles. The legend is displayed at the top to enable the user to differentiate between the counts for all the countries."),
                              p("The parameter choices for this tab are the daily cases, recoveries, deaths andtesting undertaken on the chosen day in all the countries.")),
                            mainPanel(leafletOutput("plottwo")))),
                 tabPanel("Monthly Statistics",
                          sidebarLayout(sidebarPanel(
                            chooseinput("Country_t", asia_filter = asia_filter),
                            br(),
                            br(),
                            h1("About this Page"),
                            p("This tab eanbles the user to check the monthly effects of COVID19 on the SAARC countries. The tab takes the choice of country as the user input"),
                            p("The user input renders a monthly statistical summary for the country selected. Monthly statistics include the average cases, average deaths, average recoveries and the stringency index that prevailed in the month."),
                            p("Stringency index refers to the variation in the government's containment and closure policies only. It is not a tool to judge the appropriateness or effectiveness of the government’s response.")),
                            mainPanel(dataTableOutput("plottable")))),
                 tabPanel("Bibliography",
                          p("DT"),
                          p("Yihui Xie, Joe Cheng and Xianying Tan (2020). DT: A Wrapper of the JavaScript Library
  'DataTables'. R package version 0.15. https://CRAN.R-project.org/package=DT"),
                          p("Leaflet"),
                          p("Joe Cheng, Bhaskar Karambelkar and Yihui Xie (2019). leaflet: Create Interactive Web
  Maps with the JavaScript 'Leaflet' Library. R package version 2.0.3.
  https://CRAN.R-project.org/package=leaflet"),
                          p("plotly"),
                          p("C. Sievert. Interactive Web-Based Data Visualization with R, plotly, and shiny. Chapman
  and Hall/CRC Florida, 2020."),
                          p("Scales"),
                          p("Hadley Wickham and Dana Seidel (2020). scales: Scale Functions for Visualization. R
  package version 1.1.1. https://CRAN.R-project.org/package=scales"),
                          p("Shiny"),
                          p("Winston Chang, Joe Cheng, JJ Allaire, Yihui Xie and Jonathan McPherson (2020). shiny:
  Web Application Framework for R. R package version 1.5.0.
  https://CRAN.R-project.org/package=shiny"),
                          p("ShinyThemes"),
                          p("Winston Chang (2018). shinythemes: Themes for Shiny. R package version 1.1.2.
  https://CRAN.R-project.org/package=shinythemes"),
                          p("Tidyverse"),
                          p("Wickham et al., (2019). Welcome to the tidyverse. Journal of Open Source Software,
  4(43), 1686, https://doi.org/10.21105/joss.01686"),
                          p("Covid"),
                          p('Guidotti, E., Ardia, D., (2020), "COVID-19 Data Hub", Journal of Open Source Software 5(51):2376, doi: 10.21105/joss.02376.')
))
server <- function(input, output, session) {
  
  # Plot1
  selected_country <- chosen_metric(data = asia_filter, input = input$Country)
  
  selected_date <- reactive({
    asia_filter <- selected_country()
    asia_filter %>% 
      filter(between(date, input$dates[1], input$dates[2]))
  })
  
  #Plot2
  selected_parameter <- reactive({
    asia_data_real %>%
      rename(parameter = input$parameter)
  })

  selected_date_2 <- reactive({
    asia_data_real <- selected_parameter()
    asia_data_real %>% 
      filter(date == input$date)
  })
  
  #table
  selected_country_table <- chosen_metric(data = asia_filter, input = input$Country_t)
  
  
  #PLot1
  output$plotone <- renderPlotly({
    
    output_plot <- selected_date()
    p1 <- output_plot %>%
      ggplot(aes(x = date)) +
      geom_line(aes(y = active_cases, color = "Active")) +
      geom_line(aes(y = recovered, color = "Recovered")) +
      geom_line(aes(y = confirmed, color = "Total Cases")) +
      geom_line(aes(y = deaths, color = "Deaths")) +
      scale_y_continuous(label = comma) +
      scale_color_manual("", values = c("#f6d61a", "#b31004", "#56FF33", "#0F0307")) +
      ylab("Count") +
      xlab("Month") +
      ggtitle("Comprehensive Country-wise summary")
    ggplotly(p1)
  })
  
  #Plot 2
  output$plottwo <- renderLeaflet({
    output_plot <- selected_date_2()
    pal <- colorBin(palette = "plasma", domain = output_plot$parameter, bins = 5)

    leaflet(output_plot) %>%
      addTiles() %>%
      addCircleMarkers(~longitude,
                       ~latitude,
                       label = ~administrative_area_level_1,
                       radius = 10,
                       color = ~pal(parameter),
                       layerId = ~administrative_area_level_1) %>%
      addLegend("topright", pal = pal, values = ~parameter, title = "Parameter")
  })
  
  output$plottable <- renderDataTable({
    output_table <- selected_country_table() %>% mutate(Month = month(date, label = TRUE)) %>% group_by(Month) %>% summarise(`Average Cases` = round(mean(Daily_Cases, na.rm = TRUE),2),
                                                                     `Average Deaths` = round(mean(Daily_Deaths, na.rm = TRUE), 2),
                                                                     `Average Recoveries` = round(mean(Daily_Recoveries, na.rm = TRUE),2),
                                                                     Stringency = round(median(stringency_index, na.rm = TRUE),2))
    datatable(output_table, style = 'bootstrap4', options = list(pageLength = 5))
  })
}

shinyApp(ui = ui, server = server)