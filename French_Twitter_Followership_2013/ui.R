###USER INTERFACE

library(ggplot2)
library(network)
library(sna)
library(GGally)
library(dplyr)
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("The Twitter Followship of French Politicians"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30),
       checkboxInput("GDR", "GDR", FALSE),
       verbatimTextOutput("value"),
       checkboxInput("SRC", "SRC", FALSE),
       verbatimTextOutput("value2"),
       checkboxInput("UMP", "UMP", FALSE),
       verbatimTextOutput("value3"),
       checkboxInput("RRDP", "RRDP", FALSE),
       checkboxInput("UDI", "UDI", FALSE),
       checkboxInput("Ecolo", "Ecolo", FALSE),
       checkboxInput("NI", "NI", FALSE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       h3("This is my shiny app, finished on the 28th of July"),     
       plotOutput("distPlot2"),
       h6("The data for the BMW share prices was retrieved from https://finance.yahoo.com/quote/BMW.DE/history?period1=847407600&period2=1501192800&interval=1d&filter=history&frequency=1d
")
    )
  )
))
