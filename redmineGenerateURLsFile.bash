#!/usr/bin/env bash

#Gerenates a url.config file from a baseURL and a list of redmine project handles

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


#Set the config file
configFile=$__dir/getURL.config


#Capture everything to log
log=/tmp/$__base-${ts}.log
exec >  >(tee -a $log)
exec 2> >(tee -a $log >&2)


#Check that the config file exists
if [[ ! -f "$configFile" ]] ; then
        echo "I need a file at $configFile with at least a baseURL variable set and redmine projects handle"
        echo "Example"
	echo redmineKey=balalbalbalalbala
	echo baseURL='https://code.credil.org/projects/PROJECT/issues.csv?set_filter=1&key=${redmineKey}&columns=all'
	echo projects="edit sg1 heimdal tenjin credil-time"

        exit 1
fi

. $configFile


echo Begin `date`  .....

### BEGIN SCRIPT ###############################################################

for project in `echo $projects`; do
	echo $project:${baseURL/'PROJECT'/$project}
done |tee $__dir/urls.config


### END SCIPT ##################################################################

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo Done.  `date` - $DIFF seconds
