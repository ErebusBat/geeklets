#!/bin/sh

function cptmp() {
	# cptmp demitri PATH
	TMP_FILE=/tmp/$1-geeklet.jpg
	if [[ -f $TMP_FILE ]]; then rm $TMP_FILE; fi
	ln "$2" $TMP_FILE
}

IMG_FINDER="$PWD/tools/random_iphoto_pic.sh"
DEMITRI=`$IMG_FINDER Demitri`
LINUX=`$IMG_FINDER Linux`

cptmp demitri "$DEMITRI"
cptmp linux "$LINUX"