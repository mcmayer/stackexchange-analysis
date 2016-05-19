# Stackexchange Analysis #

## Overview ##
This repository contains one python script and a few R scripts for the quick
analysis of stackexchange sites. The analysis uses the publicly information
available on [http://stackexchange.com/sites](http://stackexchange.com/sites),
containing the following statistics for each site:

- Number of users
- Number of question
- Number of answers
- Percentage of questions marked as answered
- Link to site

In addition, the questions page of each site is downloaded
(two downloads, actually) in order to extract the date of the first
question. This date identifies the age of the site.

## Motivation ##
Stackexchange ([http://stackexchange.com/](http://stackexchange.com/)) was
founded in 2008 as a question-answer site for computer programming questions. In the early days it was called Stack Overflow. The success of the site lead the
founders to branch out beyond computer programming questions and apply their model to other topics. Now more than hundred such topics are covered.

Since stackoverflow is the oldest of the Stackexchange sites it is also the
one with the most users and answers. The following has a very quick analysis
of the relationships between:

- the number of users,
- the number of questions asked,
- the number of answers given, and
- the percentage of questions marked as answered.

## Analysis ##
### Quantiles of log(#answers) and log(#users) ###
Stackoverflow dominates the whole Stackexchange ecosystem. By any of the
extensive measures (#users, #questions, #answers) Stackoverflow is more than
ten times bigger than the next biggest (Super User).

Since stackoveflow site is so dominant it is identified as a red point
in all the scatterplots.

<img src="images/distrib-answers.png" alt="quantiles of log(#answers)" />
<img src="images/distrib-users.png" alt="quantiles of log(#users)" />

### Relationships between #questions, #answers, #users ###
The linear relationship is quite good:

<img src="images/answers-users.png" alt="#answers vs. #users" />
<img src="images/questions-answers.png" alt="#answers vs. #questions" />

### Percentage marked as answered vs. #questions ###
The percentage of questions answered varies hugely, and there is a weak
negative correlation between the percentage of questions marked as answered
and the number of users.

<img src="images/answered-users.png" alt="%answered vs. #questions" />

### Age vs. #users ###
<img src="images/age-users.png" alt="%answered vs. #questions" />

## Directory structure ##
### `get.py` ###
This script downloads [http://stackexchange.com/sites](http://stackexchange.com/sites), parses it and extracts the statistics for each stackexchange site.

The result is written to the file `stackexchange.csv` in tab delimited format, and the result is also written to `stackexchange.xlsx` for consumption
in MS Excel.

The download is throttled and takes about 10 min for 150 sites.

### `load.R` ###
Load and format the output of `get.py` and save the R data.frame with name
`stackexchange` in the file in stackexchange.RData.

### `analysis.R` ###
The data.frame prepared by `load.R` is loaded and a couple of graphs
are generated.

### `Makefile` ###
Type `make analysis` or `make` to run everything. Note that the download
of all the data is throttled and takes about 10 min.

### `images/` ###
The graphs generated by `analysis.R` are saved here.

## Dependencies ##
- BeautifulSoup4 [https://www.crummy.com/software/BeautifulSoup/bs4/doc/](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)
- requests
- Selenium [http://selenium-python.readthedocs.io/](http://selenium-python.readthedocs.io/)
- xlsxwriter [http://xlsxwriter.readthedocs.io](http://xlsxwriter.readthedocs.io)


## License ##
GPL V. 3
