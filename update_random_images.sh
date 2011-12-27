#!/bin/sh

function cptmp() {
	# cptmp demitri PATH
	TMP_FILE=/tmp/$1-geeklet.jpg
	if [[ -f $TMP_FILE ]]; then rm $TMP_FILE; fi
	ln "$2" $TMP_FILE
}

IMG_FINDER="$PWD/tools/random_iphoto_pic.sh"

# Notice the Quote/Backtick
# Pass in the name of the iPhoto Album to use to select from
cptmp demitri "`$IMG_FINDER Demitri`"
cptmp linux "`$IMG_FINDER Linux`"