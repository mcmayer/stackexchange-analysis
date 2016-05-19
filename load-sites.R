# Author: mcmayer
# Date: 2016-05-19
# (C) Markus Mayer

# Load and format the output of 'get-sites.py' and save the R data.frame with
# name 'sites' in the file in sites.RData.

# The script assumes that the output of get-sites.py can be found in
# the file sites.csv.

filename = "sites.csv"
sites = read.csv(filename, sep='\t', header=T)
rownames(sites) = sites[,'name']
sites = sites[rev(order(sites[,'users'])),-1]

dt = strptime(as.character(sites[,'start_date']), "%F %T", tz='UTC')
sites$'start_date' = dt
age = (Sys.time() - dt) / 365.2524  # age of site in years
sites[,'age'] = as.double(age)

sites$'link' = as.character(sites$'link')

save(sites, file='sites.RData')
