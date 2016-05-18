#!/usr/bin/env python2
"""Parse http://stackexchange.com/sites and extract the statistics.

The parsed data is dumped to stdout in tab delimited form.
The data is also written to stackexchange.xlsx for consumption in MS Excel.
"""

from bs4 import BeautifulSoup
import requests
import re
import xlsxwriter
import sys

__author__ = 'mcmayer'
__date__ = 20160518

regexp = re.compile('([0-9.]+)(m|k)*')

workbook = xlsxwriter.Workbook('stackexchange.xlsx')
worksheet = workbook.add_worksheet()
file = open("stackexchange.csv", 'wb')		# may contain unicode


def parse_number(s):
	"""Turn a number like 14k into a proper integer."""
	i, unit = regexp.match(s).groups()
	i = float(i)
	if unit is None:
		pass
	elif unit == 'k':
		i *= 1000
	elif unit == 'm':
		i *= 1000000
	else:
		raise Exception("What is {}?".format(s))
	return int(i)


url = 'http://stackexchange.com/sites'
doc = requests.get(url)
if doc.ok:
	sys.stderr.write("Downloaded {}\n".format(url))
else:
	sys.stderr.write("Failed to download {}\n".format(url))
	sys.exit(1)

# parse html
soup = BeautifulSoup(doc.content, "lxml")

# write the header
file.write(u"{}\t{}\t{}\t{}\t{}\n".format(
		"name", "questions", "answers", "answered", "users"))
lineno = 0
worksheet.write(lineno, 0, 'name')
worksheet.write(lineno, 1, 'questions')
worksheet.write(lineno, 2, 'answers')
worksheet.write(lineno, 3, 'answered')
worksheet.write(lineno, 4, 'users')

# extract statistics and write to files
for table in soup.findAll("table", {'class': "gv-stats"}):
	try:
		pa = table.parent.parent.parent
		name = pa.find('div', {'class': "gv-expanded-site-name"}).text
		(questions, answers, answered, users) = \
			map(lambda x: x.find('td').text, table.findAll('tr'))
		questions = parse_number(questions)
		answers = parse_number(answers)
		users = parse_number(users)
		answered = answered.strip('%')
	except Exception as e:
		sys.stderr.write("Something went wrong during parsing!\n")
		raise e
	s = u"{}\t{}\t{}\t{}\t{}\n".format(name, questions, answers, answered, users)
	file.write(s.encode('utf-8'))
	lineno += 1
	worksheet.write(lineno, 0, name)
	worksheet.write(lineno, 1, questions)
	worksheet.write(lineno, 2, answers)
	worksheet.write(lineno, 3, answered)
	worksheet.write(lineno, 4, users)

# clean up
workbook.close()
sys.stderr.write("Wrote data to stackexchange.xlsx\n")
file.write('\n')
file.close()
sys.stderr.write("Wrote data to stackexchange.csv\n")
