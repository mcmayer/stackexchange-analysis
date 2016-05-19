#!/usr/bin/env python2
"""Parse http://stackexchange.com/sites and extract the statistics.

The parsed data is dumped to stdout in tab delimited form.
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

# global settings
wait_before_download = 2

workbook = xlsxwriter.Workbook('stackexchange.xlsx')
worksheet = workbook.add_worksheet()
file = open("stackexchange.csv", 'wb')		# may contain unicode


def get_start_date(url, driver):
	"""Get the page at url and determine the date of the first question"""
	global wait_before_download
	try:
		sleep(wait_before_download)
		driver.get(url+'/questions?sort=newest')
		doc = driver.page_source
		print("Downloaded {}".format(url+'/questions?sort=newest'))
	except:
		raise Exception('Failed to load {}'.format(url))
	else:
		soup = BeautifulSoup(doc)
	pager = soup.find('div', {'class': 'pager'})
	# I'm looking for the last page, it looks something like
	# /questions?page=51&sort=newest
	# in the second to last button in the pager at the bottom of the page
	last_page = pager.findAll('a')[-2]['href']
	try:
		sleep(wait_before_download)
		driver.get(url+last_page)
		doc = driver.page_source
		print("Downloaded {}".format(url+last_page))
	except:
		raise Exception('Failed to load {}'.format(url))
	else:
		soup = BeautifulSoup(doc)
		timestr = None
		for question in soup.findAll('div', {'class': 'question-summary'}):
			try:
				timestr = question.find('span', {'class': 'relativetime'})['title']
			except:
				pass
		return timestr


url = 'http://stackexchange.com/sites'
try:
	driver = webdriver.Firefox()
	driver.get(url)
	doc = driver.page_source
except:
	sys.stderr.write("Failed to download {}\n".format(url))
	sys.exit(1)
else:
	sys.stderr.write("Downloaded {}\n".format(url))

# parse html
soup = BeautifulSoup(doc, "lxml")

# write the header
file.write(u"{}\t{}\t{}\t{}\t{}\t{}\t{}\n".format(
		"name", "questions", "answers", "answered", "users", "link",
		"start_date"))
lineno = 0
worksheet.write(lineno, 0, 'name')
worksheet.write(lineno, 1, 'questions')
worksheet.write(lineno, 2, 'answers')
worksheet.write(lineno, 3, 'answered')
worksheet.write(lineno, 4, 'users')
worksheet.write(lineno, 5, 'link')
worksheet.write(lineno, 6, 'start_date')

# extract statistics and write to files
counter = 0
for item in soup.findAll("div", {'class': "gv-item"}):
	try:
		table = item.find('table')
		link = item.find('a')['href']
		name = item.find('div', {'class': "gv-expanded-site-name"}).text
		(questions, answers, answered, users) = \
			map(lambda x: x.find('td').text, table.findAll('tr'))
		questions = parse_number(questions)
		answers = parse_number(answers)
		users = parse_number(users)
		answered = answered.strip('%')
		start_date = get_start_date(link, driver)
	except Exception as e:
		sys.stderr.write("Something went wrong during parsing!\n")
		raise e
	else:
		s = u"{}\t{}\t{}\t{}\t{}\t{}\t{}\n".format(name, questions, answers,
				answered, users, link, start_date)
		file.write(s.encode('utf-8'))
		lineno += 1
		worksheet.write(lineno, 0, name)
		worksheet.write(lineno, 1, questions)
		worksheet.write(lineno, 2, answers)
		worksheet.write(lineno, 3, answered)
		worksheet.write(lineno, 4, users)
		worksheet.write(lineno, 5, link)
		worksheet.write(lineno, 6, start_date)
		counter += 1

# clean up
driver.close()
workbook.close()
sys.stderr.write("Wrote {} lines to stackexchange.xlsx\n".format(counter))
file.write('\n')
file.close()
sys.stderr.write("Wrote {} lines to stackexchange.csv\n".format(counter))
