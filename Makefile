.PHONY: clean analysis

stackexchange.RData: load.R stackexchange.csv
	R CMD BATCH --vanilla load.R

stackexchange.csv: get.py
	python2 get.py

analysis: analysis.R stackexchange.RData
	R CMD BATCH --vanilla analysis.R

clean:
	 rm -f stackexchange.csv stackexchange.xlsx stackexchange.RData *.Rout images/*.png
