#!/bin/bash

export DIR=/home/lily/Pictures/Screenshots/$(date +\%Y-\%m)
export FILENAME=Screenshot-$(date +\%Y\%m\%d-\%H\%M\%S).png
mkdir -p $DIR
export MESSAGE="File saved to $DIR/$FILENAME"

notify() {
    notify-send -i $DIR/$FILENAME "Screenshot taken!" "$MESSAGE"
}

selection() (
    # take screenshot without cursor and pipe to feh, get its pid
    maim -u | feh - &
    feh_pid=$!

    # wait for feh to start
    while [ -z "$(xdotool search --pid "$feh_pid")" ]; do
        sleep 0.1
    done

    # get window ID of feh
    wid="$(xdotool search --pid "$feh_pid")"

    # fullscreen feh and move top-left (works with multi-monitor)
    xdotool windowsize "$wid" 100% 100%
    xdotool windowmove "$wid" 0 0

    # take the new screenshot by selection, pipe to clipboard
    # we sleep for half a second before invoking maim otherwise awesome does
    # some funky shit with opacity that doesn't really affect anything but
    # i don't like it anyway. this isn't necessary in i3 or bspwm.
    # maybe i should make some check for wm.
    sleep 0.5 && maim -s -r boxzoom -u $DIR/$FILENAME

    # kill feh
    kill "$feh_pid"
)

while getopts ":qaws" option; do
    case $option in
        q) maim -u $DIR/$FILENAME
           xclip -sel clip < /dev/null
           xclip -selection clip -t image/png $DIR/$FILENAME
           notify
           exit;;
        a) maim -s -r boxzoom -u $DIR/$FILENAME
            # we use maim -s without all the feh bullshit here bc the hypr
            # config doesn't handle feh how we want it to
            # feh also doesn't take focus when floating
            # there might be some hypr config i can fix that with but idk where to start
           #selection
           if [ -e $DIR/$FILENAME ]; then
               xclip -sel clip < /dev/null
               xclip -selection clip -t image/png $DIR/$FILENAME
               notify
           fi
           exit;;
        w) maim -u -i $(xdotool getactivewindow) $DIR/$FILENAME
           xclip -sel clip < /dev/null
           xclip -selection clip -t image/png $DIR/$FILENAME
           notify
           exit;;
        s) #exec escrotum -s -C
           selection
           if [ -e $DIR/$FILENAME ]; then
               xclip -sel clip < /dev/null
               xclip -selection clip -t image/png $DIR/$FILENAME
               notify
           fi

           exit;;
    esac
done
