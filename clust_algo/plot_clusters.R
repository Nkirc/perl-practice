args <- commandArgs()
myargs <- args[4:length(args)]
pointsfile <- myargs[1]
k=0
centers=c()

if (length(args) == 5) {
  k <- myargs[2]
} else {
  centersfile <- myargs[2]
  centers <- read.table(centersfile, header=F)
  k <- myargs[3]
}

datapoints <- read.table(pointsfile, header=T)

p <- cbind(datapoints$X, datapoints$Y)
p_mat <- matrix(data=p, ncol=2)

#plot datapoints with colors respect to their cluster
plot(p_mat, col=datapoints$Cluster, xlab="x", ylab="y")

if (length(centers) > 0) {
  #plot Centers as star
  points(centers, col = 1:k, pch = 8, cex = 2)
}
