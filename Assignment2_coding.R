#Download and Read Data
tmp <- tempfile()
download.file("http://snap.stanford.edu/data/p2p-Gnutella08.txt.gz",tmp)
data <- read.csv(
        gzfile(tmp),
        sep="\t",
        header=FALSE)
data <- data[-(1:4),]
names(data) <- c("nodes", "edges")
rm(tmp)

#Prepare Environment for Visualisation


#Create Data Visualisation and save as png
png(filename = "assignment1_submission.png", width = 450, height = 450)


xlab("Year of Observation") + 
ylab("Log change in temparatur to last year") + 
theme(legend.title=element_blank()) +
ggtitle("Illustration of Log Changes in Temparatur")
dev.off()