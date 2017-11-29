####SERVER

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$value <- renderText({ 
          input$GDR
          input$SRC
          input$UMP
          input$RRDP
          input$UDI
          input$Ecolo
          input$NI
          })
  
  output$value2 <- renderText({ 
          input$GDR
          input$SRC
          input$UMP
          input$RRDP
          input$UDI
          input$Ecolo
          input$NI
  })
  
  output$value3 <- renderText({ 
          input$GDR
          input$SRC
          input$UMP
          input$RRDP
          input$UDI
          input$Ecolo
          input$NI
  })

  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
   
    })
  output$distPlot2 <- renderPlot({
          #libraries
          library(ggplot2)
          library(network)
          library(sna)
          library(GGally)
          library(dplyr)
          
          #Data
          r = "https://raw.githubusercontent.com/briatte/ggnet/master/" #link to data
          v = read.csv(paste0(r, "inst/extdata/nodes.tsv"), sep = "\t") #nodes
          e = read.csv(paste0(r, "inst/extdata/network.tsv"), sep = "\t") #edges
          
          #Preparation for plotting
          net = network(e, directed = TRUE)#build network object
          nodges = e %>% #party affiliation
                  group_by(Twitter = Source) %>%
                  summarise(edges = n()) %>%
                  left_join(v, by = "Twitter", sort = FALSE)
          net %v% "Political Party" = levels(nodges$Groupe)
          y = RColorBrewer::brewer.pal(9, "Set1")[ c(3, 1, 9, 6, 8, 5, 2) ] #Colors
          names(y) = levels(nodges$Groupe)
          
          #Plot
          ggnet(net, color = "Political Party", 
                palette = y, 
                alpha = 0.75, 
                size = 4, 
                edge.alpha = 0.5, 
                group= "Political Party")
  })
  
})
