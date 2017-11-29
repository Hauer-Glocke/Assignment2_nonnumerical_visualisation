#Source: http://snap.stanford.edu/data/amazon0302.html

#libraries
library(dplyr)

#data preparation
tmp <- tempfile()
download.file("http://snap.stanford.edu/data/amazon0302.txt.gz",tmp)
df <- read.csv(
        gzfile(tmp),
        sep="\t",
        header=FALSE,
        skip=4,
        col.names=c("from", "to"))
rm(tmp)

df.nodges <- df %>%
        group_by(ID = from) %>%
        summarise(nr_edges = n()) %>% #Include all relevant nodges and the number of their received edges
        mutate(connected = if_else(nr_edges<7, "small",
                                   if_else(nr_edges>15, "big", "medium"))) #Classify the product by # of edges

df_big <- df[df$to %in% df.nodges[df.nodges$connected=="big",]$ID &
                     df$from %in% df.nodges[df.nodges$connected=="big",]$ID, ]

df <- df[df$to %in% df.nodges$ID != FALSE, ] #Exclude all non-hosts (nodges) - 25,537 observations


###################

df_test <- df[sample(df$from, 5000),]
df_test.nodges <- unique(c(df_test$from,df_test$to))

library(igraph)
df_test_net <- graph_from_data_frame(d=df_test, vertices=df_test.nodges, directed=T) 
df_test_net <- simplify(df_test_net, remove.multiple = F, remove.loops = T)
plot(df_test_net, 
     edge.arrow.size=.1,
     edge.width=.4,
     edge.arrow.width=.4,
     vertex.label=NA,
     vertex.size=8,
     layout=layout_on_sphere)

