#!/bin/bash

fileName=$1
# check whether file exists
if [ ! -f "$fileName" ]; then
	echo "$fileName doesn't exist!"
	exit 1
fi

# get current time, format is HH:MM
currentTime=`date '+%H:%M'`

# flush file content
result="output.txt"
echo "minute, x, diff(cur - tar)s" > $result

# replace new line character with \n
IFS_old=$IFS
IFS=$'\n'

for line in `cat $fileName`
do
	matchedTime=`echo $line|grep -Eo '[0-2]{1}[0-9]{1}:[0-5]{1}[0-9]{1}'`

	if [ ! -n "$matchedTime" ]; then
		continue
	fi

	timeDiffSeconds=$(($(date +%s -d $currentTime) - $(date +%s -d $matchedTime)))
	echo $line | sed "s/$/, $timeDiffSeconds/g" >> $result
done

# revert new line character
IFS=$IFS_old

exit 0