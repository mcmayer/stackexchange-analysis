.PHONY: clean analysis

analysis: analysis.R stackexchange.RData
	R CMD BATCH --vanilla analysis.R

stackexchange.RData: load.R stackexchange.csv
	R CMD BATCH --vanilla load.R

stackexchange.csv: get.py
	python2 get.py

clean:
	 rm -f stackexchange.csv stackexchange.xlsx stackexchange.RData *.Rout images/*.png
