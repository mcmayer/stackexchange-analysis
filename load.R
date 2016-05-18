# Author: mcmayer
# Date: 2016-05-17

# Load and format the output of 'get.py' and save the R data.frame with name
# 'stackexchange' in the file in stackexchange.RData.

# The script assumes that the output of get.py can be found in
# the file stackexchange.csv.

filename = "stackexchange.csv"
stackexchange = read.csv(filename, sep='\t', header=T)
rownames(stackexchange) = stackexchange[,1]
stackexchange = stackexchange[rev(order(stackexchange[,'users'])),-1]

save(stackexchange, file='stackexchange.RData')
