#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


# Define UI for application that draws a Bar Charts
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Analyse the water quality data in India for impurities"),
  
  
  # Sidebar with a drop down menus and checkboxes
  sidebarLayout(
    sidebarPanel(

        selectInput("year", "Select the year that you want to see the results for:", c("2009","2010","2011","2012"), selected = NULL, multiple = FALSE,selectize = TRUE, width = NULL, size = NULL),
        selectInput("state", "Select the state that you want to see the results for:", c("ANDHRA PRADESH", "ARUNACHAL PRADESH", "ASSAM", "BIHAR", "CHATTISGARH", "GUJARAT", "HARYANA", "HIMACHAL PRADESH", "JAMMU AND KASHMIR", "JHARKHAND", "KARNATAKA", "KERALA", "MADHYA PRADESH", "MAHARASHTRA", "MANIPUR", "MEGHALAYA", "NAGALAND", "ORISSA", "PUDUCHERRY", "PUNJAB", "RAJASTHAN", "TAMIL NADU", "TRIPURA", "UTTAR PRADESH", "UTTARAKHAND", "WEST BENGAL"), selected = NULL, multiple = FALSE,selectize = TRUE, width = NULL, size = NULL),
        selectInput("impurity","Select the impurity type", c("Arsenic", "Fluoride", "Iron", "Nitrate", "Salinity"), selected = NULL, multiple = FALSE,selectize = TRUE, width = NULL, size = NULL),
        checkboxInput("YearStateWise","Show State Wise Results",value = TRUE),
        checkboxInput("YearImpurityState","Show Impurity Wise Results",value = TRUE)
    ),
    
    # Show Bar Charts as per requirement
    mainPanel(
        h3("A Shiny app that analyses the data obtained from water samples collected from different states in India and reports the common impurities found"),
 
        p("India has", strong("29"),"states", em("(at the time of collection of this data it had 27 states)."),"The dataset,", a(href="https://kaggle2.blob.core.windows.net/datasets/608/1152/india-water-quality-data.zip?sv=2015-12-11&sr=b&sig=I3AditolcgBgSGjcS5fEllISZJzd10PGcu37qWC%2BrcE%3D&se=2017-05-04T13%3A42%3A22Z&sp=r", "obtained from Kaggle,"), "contains data about common impurities found in water across all the states in India. The dataset (from 2009-2012) is at a", strong("State"), "level,", "then at a", strong("District"), "level, then at the", strong("Block"), "level, and so on. It lists the following impurities:",strong(em("Arsenic, Fluoride, Iron, Nitrate,")), "and,", strong(em("Salinity." ))),
        h4("How to run the app:"),
        p("The data analysis is done on a yearly basis. In order to run the analysis, one must", strong("select the Year"), "that he wants to see the data for from the left sidebar. Next depending on whether one chooses to see", strong("State-wise"),"details, or",strong("Impurity-Wise"),"details, one has to make the appropriate selection from the drop-down menu. Next depending on one's requirement the appropriate",strong("Check-Box(es)"),"need(s) to checked.",em("(Or one can enable both the Check-Boxes to see both the graphs together).")),
        hr(),
        
        plotOutput("barPlot", height = 960, width = 540)

    )
  )
))
