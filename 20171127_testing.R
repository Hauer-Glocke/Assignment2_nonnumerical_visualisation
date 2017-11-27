
tmp <- tempfile()
download.file("http://snap.stanford.edu/data/p2p-Gnutella08.txt.gz",tmp)
data <- read.csv(
        gzfile(tmp),
        sep="\t",
        header=FALSE)
data <- data[-(1:4),]
names(data) <- c("nodes", "edges")
data$nodes <- as.numeric(data$nodes)
data$edges <- as.numeric(data$edges)
rm(tmp)

library(dplyr)
data.nodes <- data %>%
        group_by(ID = nodes) %>%
        summarise(nodes = n())

data.edges <- data %>%
        group_by(ID = edges) %>%
        summarise(edges = n())

data_nodes <- full_join(data.edges,data.nodes,  by = "ID")
rm(data.nodes, data.edges)

library(igraph)
net_t1 <- graph_from_data_frame(d=data, vertices=data_nodes, directed=T) 
net_t1 <- simplify(net_t1, remove.multiple = F, remove.loops = T) 
plot(test, edge.arrow.size=.4,vertex.label=NA)

library(GGally)
library(network)
library(sna)
library(ggplot2)

net = rgraph(10, mode = "graph", tprob = 0.5)
net = network(net, directed = FALSE)
network.vertex.names(net) = letters[1:10]
ggnet2(net)

test <- network(data)
test <- simplify(test, remove.multiple = F, remove.loops = T) 
plot(test, edge.arrow.size=.4,vertex.label=NA)
ggnet2(test, node.size = 0.1)

######################
require(readr)
tmp <- tempfile()
download.file("http://www.kateto.net/wordpress/wp-content/uploads/2017/06/polnet2017.zip",tmp)
links <- read_csv(unz(tmp, 
                   "Data files/Dataset1-Media-Example-EDGES.csv"))
nodes <- read_csv(unz(tmp, 
                      "Data files/Dataset1-Media-Example-NODES.csv"))

library(igraph)
net_ex <- graph_from_data_frame(d=links, vertices=nodes, directed=T) 
plot(net_ex)

