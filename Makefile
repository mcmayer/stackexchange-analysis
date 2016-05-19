.PHONY: clean analysis

analysis: analyse-sites.R sites.RData data.RData
	R CMD BATCH --vanilla analyse-sites.R

data.RData: load-data.R data.csv
	R CMD BATCH --vanilla load-data.R

sites.RData: load-sites.R sites.csv
	R CMD BATCH --vanilla load-sites.R

data.csv: get-data.py
	python2 get-data.py

sites.csv: get-sites.py
	python2 get-sites.py

clean:
	 rm -f sites.csv sites.xlsx sites.RData data.xlsx data.csv *.Rout images/*.png *.pyc
