"""Some helper functions."""
import re

__author__ = 'mcmayer'
__date__ = '20160519'

_parse_number_regexp = re.compile('([0-9.]+)(m|k)*')


def parse_number(s):
	"""Turn a number like 14k into a proper integer."""
	i, unit = _parse_number_regexp.match(s).groups()
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
