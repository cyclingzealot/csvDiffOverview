# csvDiffOverview
Offers an overview of a diff on a csv file over time of a specified column. 

This was made with the purpose of showing the change in project scope using the output of redmine projects/sg1/issues.csv service 

# Usage with redmine
1. cp getURL.config.sample getURL.config
1. Edit getURL.config with the right variables. 
1. Run redmineGenerateURLsFile.bash . This will generate the urls.config file
1. Create the following crontab: ```0 * * * 1-5 $baseDir/csvDiffOverview/getURLwrapper.bash > ~/log/csvDiffOverview.crontab.log 2>&1
1. Your reports will be created  in $baseDir/csvDiffOverview/data/$projectName/summary.csv
