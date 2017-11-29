#Based on https://briatte.github.io/ggnet/#additional-options

#libraries
library(ggplot2)
library(network)
library(sna)
library(GGally)
library(dplyr)

#load data
r = "https://raw.githubusercontent.com/briatte/ggnet/master/" #link to data
v = read.csv(paste0(r, "inst/extdata/nodes.tsv"), sep = "\t") #nodes
e = read.csv(paste0(r, "inst/extdata/network.tsv"), sep = "\t") #edges

#build network object
net = network(e, directed = TRUE)

# party affiliation
nodges = e %>%
        group_by(Twitter = Source) %>%
        summarise(edges = n()) %>%
        left_join(v, by = "Twitter", sort = FALSE)
net %v% "Political Party" = levels(nodges$Groupe)

#x = data.frame(Twitter = network.vertex.names(net))
#x = merge(x, v, by = "Twitter", sort = FALSE)$Groupe
#net %v% "Political Party" = as.character(x)

# color palette
y = RColorBrewer::brewer.pal(9, "Set1")[ c(3, 1, 9, 6, 8, 5, 2) ]
names(y) = levels(nodges$Groupe)

# network plot
png(filename = "test_ggnet2.png", width = 900, height = 500)
ggnet(net, color = "Political Party", 
      palette = y, 
      alpha = 0.75, 
      size = 4, 
      edge.alpha = 0.5, 
      group= "Political Party")
dev.off()

###########################
library(geomnet)
library(ggnetwork)
