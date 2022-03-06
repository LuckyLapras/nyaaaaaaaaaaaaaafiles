#!/bin/bash

export DIR=/home/lily/Pictures/Screenshots/$(date +\%Y-\%m)
export FILENAME=Screenshot-$(date +\%Y\%m\%d-\%H\%M\%S).png
export MESSAGE="File saved to $DIR/$FILENAME" 

while getopts ":qaws" option; do
    case $option in
        q) exec notify-send -a escrotum 'Screenshot taken!' "$(echo $MESSAGE)"
           exit;;
        a) exec notify-send -a escrotum 'Screenshot taken!' "$(echo $MESSAGE)"
           exit;;
        w) exec notify-send -a escrotum 'Screenshot taken!' "File saved to clipboard"
           exit;;
        s) exec notify-send -a escrotum 'Screenshot taken!' "File saved to clipboard"
           exit;;
    esac
done
