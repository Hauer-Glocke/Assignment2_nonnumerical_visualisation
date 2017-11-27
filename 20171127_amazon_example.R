#Source: http://snap.stanford.edu/data/amazon0302.html

tmp <- tempfile()
download.file("http://snap.stanford.edu/data/amazon0302.txt.gz",tmp)
df <- read.csv(
        gzfile(tmp),
        sep="\t",
        header=FALSE)
df <- df[-(1:4),]
names(df) <- c("from", "to")
df$from <- as.numeric(df$from)
df$to <- as.numeric(df$to)
rm(tmp)

library(dplyr)
df.nodes <- df %>%
        group_by(ID = from) %>%
        summarise(nr_edges = n()) #Include all relevant nodes and the number of their received edges
df.nodes$hosts <- if_else(df.nodes$nr_edges<10, "small",
                            if_else(df.nodes$nr_edges>50, "big", "medium"))
                        #Classify the hosts for size

df <- df[df$to %in% df.nodes$ID != FALSE, ] #Exclude all non-hosts (nodes) - 25,537 observations


###################

df_test <- df[sample(df$from, 200),]
df_test.nodes <- unique(c(df_test$from,df_test$to))

library(igraph)
df_test_net <- graph_from_data_frame(d=df_test, vertices=df_test.nodes, directed=T) 
df_test_net <- simplify(df_test_net, remove.multiple = F, remove.loops = T)
plot(df_test_net, 
     edge.arrow.size=.1,
     edge.width=.4,
     edge.arrow.width=.4,
     vertex.label=NA,
     vertex.size=8)

