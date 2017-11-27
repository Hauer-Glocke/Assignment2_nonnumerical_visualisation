#Load Libraries
library(dplyr)

#Download and Read Data
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

data.nodes <- data %>%
        group_by(ID = nodes) %>%
        summarise(nodes = n())
data.edges <- data %>%
        group_by(ID = edges) %>%
        summarise(edges = n())
data_nodes <- full_join(data.edges,data.nodes,  by = "ID")
rm(data.nodes, data.edges)

data_nodes$hosts <- if_else(data_nodes$edges<10, "small",
                            if_else(data_nodes$edges>50, "big", "medium"))

#Prepare Environment for Visualisation


#Create Data Visualisation and save as png
png(filename = "assignment1_submission.png", width = 450, height = 450)


xlab("Year of Observation") + 
ylab("Log change in temparatur to last year") + 
theme(legend.title=element_blank()) +
ggtitle("Illustration of Log Changes in Temparatur")
dev.off()