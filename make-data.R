# Author: mcmayer
# Date: 2016-05-19
# (C) Markus Mayer

# Load data.csv (produced by get-data.py) into a data.frame

data = read.csv('data.csv', sep="\t", header=T)
rownames(data) = as.character(data[,'url'])
data = data[,-1]
save(data, file="data.RData", compress=T)