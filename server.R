library(shiny)
library(ggplot2)

gdp_data <- read.csv("Asia_GDP.csv",header = T)

shinyServer(function(input, output, session) {
  
  # Dynamically populate the country dropdown based on the dataset
  observe({
    updateSelectInput(session, "country", 
                      choices = colnames(gdp_data[-1]))
  })
  
  # Reactive expression to filter the dataset based on user input
  filteredData <- reactive({
    req(input$country, input$yearRange)
    subset(gdp_data, Year >= input$yearRange[1] & Year <= input$yearRange[2], 
           select = c("Year", input$country))
  })
  
  # Display the selected country and year range
  output$selectedCountry <- renderText({
    paste("Country Selected:", input$country)
  })
  
  output$selectedYears <- renderText({
    paste("Year Range Selected:", input$yearRange[1], "-", input$yearRange[2])
  })
  
  # Show descriptive statistics for the filtered data
  output$summaryStats <- renderPrint({
    data <- filteredData()
    if (nrow(data) > 0) {
      summary(data[[input$country]])
    } else {
      "No data available for the selected inputs."
    }
  })
  
  # Show the filtered data table
  output$filteredData <- renderTable({
    filteredData()
  })
  
  # output bar plot
  output$barPlot <- renderPlot({
    data <- filteredData()
    if (nrow(data) > 0) {
      ggplot(data, aes(x = Year, y = data[[input$country]])) +
        geom_bar(stat = "identity", fill = "blue") +
        labs(x = "Year", y = "GDP Value", title = paste("GDP for", input$country)) +
        theme_minimal()
    } else {
      NULL
    }
  })
  
  # Add density plot for the selected country's data
  output$density <- renderPlot({
    data <- filteredData()
    if (nrow(data) > 0) {
      plot(density(data[[input$country]]), 
           main = paste("Density Plot of GDP Growth for", input$country),
           xlab = "GDP Growth", 
           col = "red", 
           lwd = 2)
    } else {
      plot.new()
      text(0.5, 0.5, "No data available for the selected inputs.", cex = 1.5)
    }
  })
})
