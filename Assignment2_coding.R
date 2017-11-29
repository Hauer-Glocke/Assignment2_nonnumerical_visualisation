#Load Libraries
library(dplyr)
library(RColorBrewer)
library(igraph)

#Data Preparation
tmp <- tempfile()
download.file("http://snap.stanford.edu/data/p2p-Gnutella08.txt.gz",tmp)
data <- read.csv(
        gzfile(tmp),
        sep="\t",
        header=FALSE,
        skip=4,
        col.names = c("from", "to"))
rm(tmp)

data.nodges <- data %>%
        group_by(ID = from) %>%
        summarise(nr_edges = n()) %>% #Include all relevant nodges and the number of their received edges
        mutate(connected = if_else(nr_edges<5, "small",
                                   if_else(nr_edges>20, "big", "medium"))) #Classify the product by # of edges

#Prepare Environment for Visualisation
data_big <- data[#data$to %in% data.nodges[data.nodges$connected=="big",]$ID &
        data$from %in% data.nodges[data.nodges$connected=="big",]$ID, ]

data_big_ids <- data.frame(ID = as.integer(unique(c(data_big$from, data_big$to))), 
                           stringsAsFactors=FALSE)
data_big_ids$class <- if_else(data_big_ids$ID %in% data.nodges[data.nodges$connected=="big",]$ID,
                              "host", "connection")

net_t1 <- graph_from_data_frame(d=data_big, vertices=data_big_ids, directed=T) 
net_t1 <- simplify(net_t1, remove.multiple = F, remove.loops = T)
colrs <- brewer.pal(6, "Blues")[c(2,6)]
wdt <- c(0.3,1)
my_color <- colrs[as.numeric(as.factor(V(net_t1)$class))]
my_width <- wdt[as.numeric(as.factor(V(net_t1)$class))]
V(net_t1)$label <- as.character(data_big_ids$ID)

#Create Data Visualisation and save as png
png(filename = "assignment2_submission.png", width = 600, height = 600)
plot(net_t1, 
     edge.arrow.size=.1,
     edge.width=my_width,
     edge.arrow.width=my_width,
     vertex.label=if_else(V(net_t1)$class=="host", V(net_t1)$label, ""),
     vertex.label.font = 2,
     vertex.label.degree = pi/2,
     vertex.label.color = "red",
     vertex.size=8, 
     vertex.color=my_color,
     title="Connections of Major Hosts in Gnutella peer-to-peer network")
title("Connections of Major Hosts in Gnutella peer-to-peer network")
legend("bottomright",
       title = "Nodge Type",
       legend=levels(as.factor(V(net_t1)$class)) , 
       col = colrs, 
       pch=20 , pt.cex = 1.5, cex = 1, 
       horiz = FALSE)
dev.off()