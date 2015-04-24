#!/usr/bin/python

import csv
import re
from datetime import datetime

from os import listdir
from os import path
from os.path import isfile, join
#from aptdaemon.config import __author__

     
def toHeaderStr(fileName):
    "takes the expected filename and returns it as string in antoher date time format"
    dateTimeObj = datetime.strptime(fileName, '%Y%m%d-%H%M%S.csv')
    return dateTimeObj.strftime('%Y/%m/%d %H:%M:%S');




def getUniqueValues(seq):
    "Return sorted list of unique values in sequence"
    "author: Hugh Bothwell http://stackoverflow.com/questions/5432109/python-writing-to-a-csv-file-from-a-list-of-tuples-value-dicts#answer-5435335"
    values = list(set(seq))
    values.sort()
    return values

def dataArray(data2d, rowIterField=0, rowLabel='', defaultVal=''):
    "author: Hugh Bothwell http://stackoverflow.com/questions/5432109/python-writing-to-a-csv-file-from-a-list-of-tuples-value-dicts#answer-5435335"

    # get all unique unit and test labels
    rowLabels = getUniqueValues(key[rowIterField] for key in data2d)
    colLabels = getUniqueValues(key[1-rowIterField] for key in data2d)

    # create key-tuple maker
    if rowIterField==0:
        key = lambda row,col: (row, col)
    else:
        key = lambda row,col: (col, row)

    # header row
    yield [rowLabel] + colLabels
    for row in rowLabels:
        # data rows
        yield [row] + [data2d.get(key(row,col), defaultVal) for col in colLabels]



import sys


# Get the column user want as first argument
# Redmine issues report time spent:	column 15
# Redmine issues report time remaining:	column 14
column = 15
if sys.argv[1]:
    column = sys.argv[1]

# Get the basedir of the script
basedir = path.dirname(path.realpath(__file__))

# Set the datadir 
datadir = basedir + '/data/' 

# Regex for data files
matcher = re.compile("^[0-9]{8}-[0-9]{6}\.csv$")

# Get the data file in the datadir which match the pattern
files = [f for f in listdir(datadir) if isfile(join(datadir, f)) and matcher.match(f)]

# Create a list of headers based on the list of files
headers = [toHeaderStr(val) for val in files]

# Insert the header for column 0, which is the list of tickets
headers.insert(0, 'Ticket')


data = {}
for file in files:
    with open(datadir +'/'+ file, 'rb') as csvfile:
	#Read csv file
        reader = csv.reader(csvfile, delimiter=';');
        
        line = 0;
        
        for row in reader:
	    #Store in data varirable, indexed by tuple of (ticket number, timestamp)
	    #The tupple allows to express an xy grid for the csv file which csv.writerows can use
            if line > 0:
                data[(row[0], toHeaderStr(file))] = row[9]
            line += 1
            
            

#Output the file in summary.csv
with open(datadir + '/summary.csv', 'wb') as outf:
    outcsv = csv.writer(outf)
    outcsv.writerows(dataArray(data, 0, 'ticket'))
           
        
            
            
        
