#!/usr/bin/env python2
"""Parse http://data.stackexchange.com and extract the statistics.

The parsed data is dumped to data.csv in tab delimited format.
The data is also written to stackexchange.xlsx for consumption in MS Excel.
"""

from bs4 import BeautifulSoup
from selenium import webdriver
import re
import xlsxwriter
import sys
from time import sleep
from helper import parse_number

__author__ = 'mcmayer'
__date__ = 20160519

# global variables
wait_before_download = 2
driver = webdriver.Firefox()


workbook = xlsxwriter.Workbook('data.xlsx')
worksheet = workbook.add_worksheet()
file = open("data.csv", 'wb')		# may contain unicode


url = 'http://data.stackexchange.com'
try:
	driver.get(url)
	doc = driver.page_source
	driver.close()
except:
	sys.stderr.write("Failed to download {}\n".format(url))
	sys.exit(1)
else:
	sys.stderr.write("Downloaded {}\n".format(url))

# parse html
soup = BeautifulSoup(doc, "lxml")

counter = 0			# number of rows
header = ['url', 'questions', 'answers', 'comments', 'tags']
file.write('\t'.join(map(str, header)) + '\n')
[worksheet.write(counter, i, name) for i, name in enumerate(header)]


for li in soup.find('ul', {'class': 'site-list'}).findAll('li'):
	ul = li.find('ul')
	if ul is None:
		continue
	url = ul.find('a')
	if url is None:
		continue
	url = url['href']
	all_li = [li.find('span', {'class': 'pretty-short'}) for
				li in ul.findAll('li')]
	try:
		questions, answers, comments, tags = [
			int(li['title'].replace(',', '')) for li in all_li[:-1]]
	except:
		questions, answers, comments, tags = None, None, None, None
	row = [url, questions, answers, comments, tags]
	file.write('\t'.join(map(unicode, row)) + '\n')
	[worksheet.write(counter, i, val) for i, val in enumerate(row)]
	counter += 1

# clean up
workbook.close()
sys.stderr.write("Wrote {} lines to data.xlsx\n".format(counter))
file.write('\n')
file.close()
sys.stderr.write("Wrote {} lines to data.csv\n".format(counter))
