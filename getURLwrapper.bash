#!/usr/bin/env bash

START=$(date +%s.%N)


#exit when command fails (use || true when a command can fail)
set -o errexit

#exit when your script tries to use undeclared variables
set -o nounset

#(a.k.a set -x) to trace what gets executed
set -o xtrace

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

#Capture everything to log
log=~/log/$__base-${ts}.log
exec >  >(tee -a $log)
exec 2> >(tee -a $log >&2)


#Check that the config file exists
if [[ ! -f "$configFile" ]] ; then
        echo "I need a file at $configFile with a variable called \$url.  "
        exit 1
fi

. $configFile

echo Begin `date`  .....

### BEGIN SCRIPT ###############################################################

file=`date +'%Y%m%d-%H%M%S'`.csv
datadir=$__dir/data/
dest=$datadir/$file
lynx --source $url > $dest

cd $__dir
python ./csvDiffOverview.py $column
cd -

### END SCIPT ##################################################################

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo Done.  `date` - $DIFF seconds
