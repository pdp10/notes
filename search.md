# Useful commands for searching

## search files containing keyword
grep -r "word"
ag "word"


## search file path given file name (also wildcards)
find . -name "ReportData.pm"


# formatting json file nicely
cat JSON_FILE | python -mjson.tool > JSON_FILE_REFORMATTED
