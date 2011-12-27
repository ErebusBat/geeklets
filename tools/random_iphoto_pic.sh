#/bin/sh

# OSA Script adapted from http://hints.macworld.com/article.php?story=20040205114948502

if [[ -z $1 ]]; then
	ALBUM="Linux"
else
	ALBUM=$1
fi

/usr/bin/osascript <<END
    tell application "iPhoto"
        set p_max to the number of photos in album named "$ALBUM"
        set p_num to random number from 1 to p_max
        set the_bg to the image path of photo p_num of album named "$ALBUM"
    end tell
    copy the_bg to stdout
END