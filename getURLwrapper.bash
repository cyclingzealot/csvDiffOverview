#!/usr/bin/env bash

START=$(date +%s.%N)


#exit when command fails (use || true when a command can fail)
set -o errexit

#exit when your script tries to use undeclared variables
set -o nounset

#(a.k.a set -x) to trace what gets executed
#set -o xtrace

# in scripts to catch mysqldump fails 
set -o pipefail

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
ts=`date +'%Y%m%d-%H%M%S'`

#Set the config fi2ddle
configFile=$__dir/getURL.config
urlsFile=$__dir/urls.config

#Capture everything to log
log=~/log/$__base-${ts}.log
exec >  >(tee -a $log)
exec 2> >(tee -a $log >&2)


#Check that the config file exists
if [[ ! -f "$configFile" ]] ; then
        echo "I need a file at $configFile with a variable set called \$column=integer  "
        exit 1
fi
. $configFile

if [[ ! -f "$urlsFile" ]] ; then
        echo "I need a file at $urlsFile with a list of directories in data and urls formatted like \$dirName:\$url.  "
        exit 1
fi

echo Begin `date`  .....

### BEGIN SCRIPT ###############################################################


cd $__dir
for pair in `cat $urlsFile`; do
	dir=`echo $pair | cut -d ':' -f 1`
	file=`date +'%Y%m%d-%H%M%S'`.csv
	datadir=$__dir/data/$dir
	dest=$datadir/$file
	url=`echo $pair | cut -d ':' -f 2-`

	mkdir -p $datadir
	echo Getting data for $dir and putting in $dest...
	curl -sS $url > $dest

	echo Generating summary for $dir in $datadir
	python ./csvDiffOverview.py $datadir $column

	echo
done
cd -

### END SCIPT ##################################################################

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo Done.  `date` - $DIFF seconds
