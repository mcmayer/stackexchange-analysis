.PHONY: clean analysis

analysis: analysis.R sites.RData
	R CMD BATCH --vanilla analysis.R

sites.RData: load-sites.R sites.csv
	R CMD BATCH --vanilla load-sites.R

sites.csv: get-sites.py
	python2 get-sites.py

clean:
	 rm -f sites.csv sites.xlsx sites.RData *.Rout images/*.png *.pyc
