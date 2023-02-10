#!/bin/bash

export DIR=$HOME/Pictures/Screenshots/$(date +\%Y-\%m)
export FILENAME=Screenshot-$(date +\%Y\%m\%d-\%H\%M\%S).png
mkdir -p $DIR
export MESSAGE="File saved to $DIR/$FILENAME"

notify() {
    notify-send -i $DIR/$FILENAME "Screenshot taken!" "$MESSAGE" -a 'screenshot.sh'
}

while getopts ":qaws" option; do
    case $option in
        q) flameshot full -c -p $DIR/$FILENAME
           notify
           exit;;
        w) # i like this shortcut and flameshot doesn't provide an alternative
           # so maim stays for this one
           maim -u -i $(xdotool getactivewindow) $DIR/$FILENAME
           xclip -sel clip < /dev/null
           xclip -selection clip -t image/png $DIR/$FILENAME
           notify
           exit;;
        s) flameshot gui -c -s -p $DIR/$FILENAME
           if [ -e $DIR/$FILENAME ]; then
               notify
           fi
           exit;;
    esac
done
