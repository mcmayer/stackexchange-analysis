.PHONY: clean analysis

analysis: analyse-sites.R sites.RData data.RData
	R CMD BATCH --vanilla analyse-sites.R

data.RData: make-data.R data.csv
	R CMD BATCH --vanilla make-data.R

sites.RData: make-sites.R sites.csv
	R CMD BATCH --vanilla make-sites.R

data.csv: get-data.py
	python2 get-data.py

sites.csv: get-sites.py
	python2 get-sites.py

clean:
	 rm -f sites.csv sites.xlsx sites.RData data.xlsx data.csv *.Rout images/*.png *.pyc
