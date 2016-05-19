# Author: mcmayer
# Date: 2016-05-19
# (C) Markus Mayer

# Load and format the output of 'get.py' and save the R data.frame with name
# 'stackexchange' in the file in stackexchange.RData.

# The script assumes that the output of get.py can be found in
# the file stackexchange.csv.

filename = "stackexchange.csv"
stackexchange = read.csv(filename, sep='\t', header=T)
rownames(stackexchange) = stackexchange[,'name']
stackexchange = stackexchange[rev(order(stackexchange[,'users'])),-1]

dt = strptime(as.character(stackexchange[,'start_date']), "%F %T", tz='UTC')
stackexchange$'start_date' = dt
age = (Sys.time() - dt) / 365.2524  # age of site in years
stackexchange[,'age'] = as.double(age)

stackexchange$'link' = as.character(stackexchange$'link')

save(stackexchange, file='stackexchange.RData')
