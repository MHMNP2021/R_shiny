library(shiny)

shinyUI(fluidPage(
  
  titlePanel(title = h2("GDP Growth of Asian Countries", align = "center")),
  
  sidebarLayout(
    sidebarPanel(
      h3("Input Selection"),
      
      # Dropdown to select a country
      selectInput("country", "Select a Country:",
                  choices = " "), # Will populate dynamically
      
      # Year range slider
      sliderInput("yearRange", "Select Year Range:",
                  min = 1960, max = 2020, value = c(1960, 2020),
                  sep = ""),
      
      actionButton("update", "Update View")
    ),
    
    mainPanel(
      h3("Descriptive Statistics"),
      
      # Display selected country and year range
      textOutput("selectedCountry"),
      textOutput("selectedYears"),
      
      # Display descriptive statistics
      verbatimTextOutput("summaryStats"),
      
      # Add histogram output
      plotOutput("barPlot"),
      
      # Add density plot
      plotOutput("density"),
      
      # Table of filtered data
      tableOutput("filteredData")
      
     
    )
  )
))
