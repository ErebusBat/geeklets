#!/bin/sh

ROOT_PATH=`dirname $0`

function cptmp() {
	# cptmp demitri PATH
	TMP_FILE=/tmp/$1-geeklet.jpg
	if [[ -f $TMP_FILE ]]; then rm $TMP_FILE; fi
	ln "$2" $TMP_FILE
}

IMG_FINDER="$ROOT_PATH/tools/random_iphoto_pic.sh"


# Count how many results we get, we will get at least one for the grep
# so if we have more than 1 then assume it is already running
WAS_RUNNING=`ps aux | grep "iPhoto.app/Contents/MacOS/iPhoto " | wc -l`
if [[ $WAS_RUNNING -gt 1 ]]; then
	WAS_RUNNING=1
else
	WAS_RUNNING=0
fi


# Notice the Quote/Backtick
# Pass in the name of the iPhoto Album to use to select from
cptmp demitri "`$IMG_FINDER Demitri`"
cptmp linux "`$IMG_FINDER Linux`"
cptmp photostream "`$IMG_FINDER 'Dec 2011 Photo Stream'`"


# Only kill iPhoto if it wasn't running before we poked it
if [[ $WAS_RUNNING == "0" ]]; then	
	echo 'tell application "iPhoto" to quit' | osascript
fi