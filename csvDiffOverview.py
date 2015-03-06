#!/usr/bin/python

import csv
import re

from os import listdir
from os import path
from os.path import isfile, join


basedir = path.dirname(path.realpath(__file__))
datadir = basedir + '/data/' 
matcher = re.compile("^[0-9]{8}-[0-9]{6}\.csv$")

files = [f for f in listdir(datadir) if isfile(join(datadir, f)) and matcher.match(f)]

